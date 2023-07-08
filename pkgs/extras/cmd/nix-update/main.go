package main

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	"gopkg.in/yaml.v3"
)

func main() {
	ctx := context.Background()

	filename := os.Args[1]

	updater := NewUpdater()

	if err := updater.Update(ctx, path.Dir(filename), filename); err != nil {
		log.Fatalf("Failed to update %q file: %s", filename, err)
	}
}

type packageID struct {
	filename string
	name     string
}

type Updater struct {
	knownFiles    map[string]struct{}
	knownPackages map[packageID]struct{}
}

type UpdaterOptions struct {
}

type UpdaterOption interface {
	ApplyUpdaterOption(*UpdaterOptions)
}

type UpdaterOptionFunc func(*UpdaterOptions)

func (f UpdaterOptionFunc) ApplyUpdaterOption(o *UpdaterOptions) {
	if f != nil {
		f(o)
	}
}

func NewUpdater(opts ...UpdaterOption) *Updater {
	options := UpdaterOptions{}
	for _, opt := range opts {
		if opt != nil {
			opt.ApplyUpdaterOption(&options)
		}
	}

	u := &Updater{
		knownFiles:    make(map[string]struct{}),
		knownPackages: make(map[packageID]struct{}),
	}

	return u
}

type generatedPackage struct {
	name  string
	lines []string
}

type generatedFile struct {
	w        bufio.Writer
	params   map[string]struct{}
	packages []generatedPackage
}

func (g *generatedFile) addParam(name string) {
	if g.params == nil {
		g.params = make(map[string]struct{})
	}

	if _, ok := g.params[name]; ok {
		return
	}
	g.params[name] = struct{}{}
}

func (g *generatedFile) addPackage(name string, lines []string) {
	g.packages = append(g.packages, generatedPackage{
		name:  name,
		lines: lines,
	})
}

func (g *generatedFile) generate(w io.Writer) error {
	g.w.Reset(w)

	// Generate params.
	args := make([]string, 0, len(g.params))
	for fetcher := range g.params {
		args = append(args, fetcher)
	}
	sort.Strings(args)

	g.w.WriteString("{")

	for i, fetcher := range args {
		if i > 0 {
			g.w.WriteString(",")
		}

		g.w.WriteString(" ")
		g.w.WriteString(fetcher)
	}

	if len(args) > 0 {
		g.w.WriteString(", ")
	}
	g.w.WriteString("...")

	g.w.WriteString(" }:\n")
	g.w.WriteString("\n")

	// Generate packages.
	sort.SliceStable(g.packages, func(i, j int) bool {
		return g.packages[i].name < g.packages[j].name
	})

	g.w.WriteString("{\n")

	for i, pkg := range g.packages {
		if i > 0 {
			g.w.WriteString("\n")
		}

		fmt.Fprintf(&g.w, "  %s = ", pkg.name)

		for j, line := range pkg.lines {
			if j > 0 {
				g.w.WriteString("\n")
				g.w.WriteString("  ")
			}

			g.w.WriteString(line)
		}

		g.w.WriteString(";\n")
	}

	g.w.WriteString("}\n")

	// Flush.
	if err := g.w.Flush(); err != nil {
		return err
	}

	return nil
}

func (u *Updater) Update(ctx context.Context, dir, filename string) error {
	absFilename, err := filepath.Abs(filename)
	if err != nil {
		return fmt.Errorf("nix-update: failed to get abs path of file: %w", err)
	}

	// Check if the file is already processed.
	_, known := u.knownFiles[absFilename]
	if known {
		return nil
	}
	u.knownFiles[absFilename] = struct{}{}

	// Process the file.
	log.Printf("Processing file %s", filename)

	// Parse the config.
	cfg, err := os.ReadFile(filename)
	if err != nil {
		return fmt.Errorf("nix-update: failed to open config file: %w", err)
	}

	var config Config
	if err := yaml.Unmarshal(cfg, &config); err != nil {
		return fmt.Errorf("nix-update: failed to unmarshal config file: %w", err)
	}

	// Update the packages.
	var gen generatedFile

	for name, pkg := range config.Packages {
		id := packageID{filename: absFilename, name: name}
		if _, ok := u.knownPackages[id]; ok {
			continue
		}
		u.knownPackages[id] = struct{}{}

		if err := u.updatePackage(ctx, &gen, dir, name, pkg); err != nil {
			return err
		}
	}

	// Generate the output file.
	var out io.Writer = os.Stdout
	if config.Output != "" {
		outputFilename := path.Join(dir, config.Output)

		if err := os.MkdirAll(path.Dir(outputFilename), 0755); err != nil {
			return fmt.Errorf("nix-update: failed to create dir for output file: %w", err)
		}

		f, err := os.OpenFile(outputFilename, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0644)
		if err != nil {
			return fmt.Errorf("nix-update: failed to open output file: %w", err)
		}
		defer f.Close()

		out = f
	}

	if err := gen.generate(out); err != nil {
		log.Fatalf("Failed to generate file: %s", err)
	}

	return nil
}

type fetcher struct {
	name string
	args []string
}

func (u *Updater) updatePackage(ctx context.Context, gen *generatedFile, dir, name string, pkg *Package) error {
	log.Printf("Processing package %s", name)

	// Prefetch package.
	var (
		fetch *fetcher
		err   error
	)
	switch pkg.Type {
	case PackageTypeGit:
		fetch, err = u.prefetchGitPackage(ctx, pkg.Args.(*PackageGitArgs))

	case PackageTypeGithub:
		fetch, err = u.prefetchGithubPackage(ctx, pkg.Args.(*PackageGithubArgs))

	default:
		return fmt.Errorf("nix-update: unknown package type: %s", pkg.Type)
	}
	if err != nil {
		// log.Printf("Failed to prefetch %s, but continue: %s", name, err)
		return err
	}

	// Generate package body.
	var lines []string
	lines = append(lines, "{")

	// Pname.
	pname := pkg.Pname
	if pname == "" {
		pname = name
	}
	lines = append(lines, fmt.Sprintf("  pname = %q;", pname))

	// Version.
	if v := pkg.Version(); v != "" {
		lines = append(lines, fmt.Sprintf("  version = %q;", v))
	}

	// Src.
	lines = append(lines, fmt.Sprintf("  src = %s {", fetch.name))
	for _, arg := range fetch.args {
		lines = append(lines, "    "+arg+";")
	}
	lines = append(lines, "  };")

	// Extra attrs.
	if len(pkg.ExtraAttrs) > 0 {
		extraAttrKeys := make([]string, 0, len(pkg.ExtraAttrs))
		for key := range pkg.ExtraAttrs {
			extraAttrKeys = append(extraAttrKeys, key)
		}
		sort.Strings(extraAttrKeys)

		for _, key := range extraAttrKeys {
			// TODO(SuperPaitnman): encode to correct nix values.
			lines = append(lines, fmt.Sprintf("  %s = %#v;", key, pkg.ExtraAttrs[key]))
		}
	}

	lines = append(lines, "}")

	// Register package.
	gen.addParam(fetch.name)
	gen.addPackage(name, lines)

	// Run after scripts.
	if len(pkg.After) > 0 {
		subupdates, err := u.runAfterScripts(ctx, name, pkg, fetch)
		if err != nil {
			return err
		}

		for _, subupdate := range subupdates {
			if err := u.Update(ctx, dir, subupdate); err != nil {
				return err
			}
		}
	}

	return nil
}

func (u *Updater) prefetchGitPackage(ctx context.Context, a *PackageGitArgs) (*fetcher, error) {
	args := make([]string, 0, 8)
	args = append(args, "fetchgit")
	if a != nil {
		if a.URL != "" {
			args = append(args, "--arg", "url", strconv.Quote(a.URL))
		}

		if a.Rev != "" {
			args = append(args, "--arg", "rev", strconv.Quote(a.Rev))
		}
	}

	hash, err := u.nixPrefetch(ctx, args)
	if err != nil {
		return nil, err
	}

	fetcherArgs := make([]string, 0, 4)
	if a != nil {
		if a.URL != "" {
			fetcherArgs = append(fetcherArgs, fmt.Sprintf(`url = %q`, a.URL))
		}

		if a.Rev != "" {
			fetcherArgs = append(fetcherArgs, fmt.Sprintf(`rev = %q`, a.Rev))
		}
	}

	fetcherArgs = append(fetcherArgs, fmt.Sprintf(`sha256 = %q`, hash))

	return &fetcher{
		name: "fetchgit",
		args: fetcherArgs,
	}, nil
}

func (u *Updater) prefetchGithubPackage(ctx context.Context, a *PackageGithubArgs) (*fetcher, error) {
	args := make([]string, 0, 8)
	args = append(args, "fetchFromGitHub")
	if a != nil {
		if a.Owner != "" {
			args = append(args, "--arg", "owner", strconv.Quote(a.Owner))
		}

		if a.Repo != "" {
			args = append(args, "--arg", "repo", strconv.Quote(a.Repo))
		}

		if a.Rev != "" {
			args = append(args, "--arg", "rev", strconv.Quote(a.Rev))
		}
	}

	hash, err := u.nixPrefetch(ctx, args)
	if err != nil {
		return nil, err
	}

	fetcherArgs := make([]string, 0, 4)
	if a != nil {
		if a.Owner != "" {
			fetcherArgs = append(fetcherArgs, fmt.Sprintf(`owner = %q`, a.Owner))
		}

		if a.Repo != "" {
			fetcherArgs = append(fetcherArgs, fmt.Sprintf(`repo = %q`, a.Repo))
		}

		if a.Rev != "" {
			fetcherArgs = append(fetcherArgs, fmt.Sprintf(`rev = %q`, a.Rev))
		}
	}

	fetcherArgs = append(fetcherArgs, fmt.Sprintf(`sha256 = %q`, hash))

	return &fetcher{
		name: "fetchFromGitHub",
		args: fetcherArgs,
	}, nil
}

func (u *Updater) nixPrefetch(ctx context.Context, args []string) (string, error) {
	cmd := exec.CommandContext(ctx, "nix-prefetch", args...)
	// cmd.Stderr = os.Stderr

	out, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("nix-update: failed to run nix-prefetch: %w", err)
	}

	return strings.TrimSpace(string(out)), nil
}

func (u *Updater) runAfterScripts(ctx context.Context, name string, pkg *Package, fetch *fetcher) ([]string, error) {
	// Create a temporary nix file.
	f, err := os.CreateTemp("", "nix-update-*.nix")
	if err != nil {
		return nil, fmt.Errorf("nix-update: failed to create temp nix file: %w", err)
	}
	tmpfilename := f.Name()
	defer os.Remove(tmpfilename)
	defer f.Close()

	// Pname.
	pkgName := "nix-update-" + name
	if v := pkg.Version(); v != "" {
		pkgName += "-" + v
	}

	// Generate a temporary nix file.
	w := bufio.NewWriter(f)

	w.WriteString(`{ pkgs ? import <nixpkgs> { }, ... }:` + "\n")
	w.WriteString("\n")
	w.WriteString("let\n")
	w.WriteString("  inherit (pkgs) stdenv lib writeScript;\n")
	fmt.Fprintf(w, "  inherit (pkgs) %s;\n", fetch.name)

	// Prepare scripts.
	for i, cmd := range pkg.After {
		if cmd.Type != CommandTypeShell {
			continue
		}

		args := cmd.Args.(*CommandShellArgs)

		fscript, err := os.CreateTemp("", fmt.Sprintf("nix-update-*-script%d.sh", i))
		if err != nil {
			return nil, fmt.Errorf("nix-update: failed to create temp script file: %w", err)
		}
		tmpfilename := fscript.Name()
		defer os.Remove(tmpfilename)
		defer fscript.Close()

		if _, err := fscript.Write([]byte(args.Text)); err != nil {
			return nil, fmt.Errorf("nix-update: failed to write content to temp script file: %w", err)
		}

		fmt.Fprintf(w, "  script%d = writeScript %q (builtins.readFile %q);\n",
			i,
			pkgName+"-script"+strconv.Itoa(i)+".sh",
			tmpfilename,
		)
	}

	w.WriteString("in\n")
	w.WriteString("\n")

	w.WriteString("stdenv.mkDerivation {\n")

	// Name
	fmt.Fprintf(w, "  name = %q;\n", pkgName)
	w.WriteString("\n")

	// Src
	fmt.Fprintf(w, "  src = %s {\n", fetch.name)
	for _, arg := range fetch.args {
		fmt.Fprintf(w, "    %s;\n", arg)
	}
	w.WriteString("  };\n")
	w.WriteString("\n")

	// Build inputs.
	if len(pkg.BuildInputs) > 0 {
		w.WriteString(`  buildInputs = map (name: lib.getAttrFromPath (lib.splitString "." name) pkgs) [` + "\n")
		for _, bi := range pkg.BuildInputs {
			fmt.Fprintf(w, "    %q\n", bi)
		}
		w.WriteString("  ];\n")
		w.WriteString("\n")
	}

	// Build Phase.
	w.WriteString("  buildPhase = ''\n")

	for i, cmd := range pkg.After {
		switch cmd.Type {
		case CommandTypeShell:
			fmt.Fprintf(w, `    src="$src" ${script%d}`+"\n", i)
		}
	}

	w.WriteString("  '';\n")
	w.WriteString("\n")

	// Install Phase.
	w.WriteString("  installPhase = ''\n")
	w.WriteString(`    mkdir "$out"` + "\n")

	for _, cmd := range pkg.After {
		switch cmd.Type {
		case CommandTypeUpdate:
			args := cmd.Args.(*CommandUpdateArgs)

			fmt.Fprintf(w, `    cp %q "$out/"`+"\n", args.Filename)
		}
	}

	w.WriteString("  '';\n")

	w.WriteString("}\n")

	// Flush.
	if err := w.Flush(); err != nil {
		return nil, fmt.Errorf("nix-update: failed to write content to temp nix file: %w", err)
	}

	// Run nix-build.
	cmd := exec.CommandContext(ctx, "nix-build",
		"--no-out-link",
		tmpfilename,
	)
	// cmd.Stderr = os.Stderr

	out, err := cmd.Output()
	if err != nil {
		return nil, fmt.Errorf("nix-update: failed to run nix-build: %w", err)
	}

	result := strings.TrimSpace(string(out))

	// Run sub-updates.
	var subupdates []string
	for _, cmd := range pkg.After {
		if cmd.Type != CommandTypeUpdate {
			continue
		}

		args := cmd.Args.(*CommandUpdateArgs)

		subupdates = append(subupdates, path.Join(result, args.Filename))
	}

	return subupdates, nil
}
