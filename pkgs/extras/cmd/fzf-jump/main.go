package main

import (
	"bytes"
	"context"
	"errors"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path"
	"sort"

	"github.com/SuperPaintman/nice/colors"

	"github.com/SuperPaintman/dotfiles/pkgs/extras/internal/commands"
)

var (
	projectsDir string
)

func init() {
	flag.StringVar(&projectsDir, "projects", "~/Projects", "Path to the projects dir.")
}

const (
	defaultProjectsSymbol = ""
	defaultZoxideSymbol   = ""
)

type Kind uint8

const (
	KindProject Kind = iota
	KindZoxide
)

type Directory struct {
	Kind  Kind
	Score float64
	Path  string
}

type ByPriority []Directory

func (s ByPriority) Len() int      { return len(s) }
func (s ByPriority) Swap(i, j int) { s[i], s[j] = s[j], s[i] }
func (s ByPriority) Less(i, j int) bool {
	if s[i].Score != s[j].Score {
		return s[i].Score < s[j].Score
	}

	return s[i].Path < s[j].Path
}

func main() {
	// Parse flags.
	flag.Parse()

	homedir, _ := os.UserHomeDir()

	projectsDir = replacePrefix(projectsDir, "~", homedir)

	// Initialize colors.
	colors.SetMode(colors.Always)

	// Find directories.
	ctx := context.Background()

	known := make(map[string]int)
	var dirs []Directory

	// Find all projects.
	fd := commands.FD{
		Hidden:   true,
		MaxDepth: 5,
		Type:     "directory",
	}

	projectDirs, err := fd.Find(ctx, "^\\.git$", projectsDir)
	if err != nil {
		log.Fatalf("Failed to find all git project dirs: %s", err)
	}

	// Trim the `.git` dir.
	for i := range projectDirs {
		projectDirs[i] = path.Join(projectDirs[i], "..")
	}

	for _, pd := range projectDirs {
		if _, ok := known[pd]; ok {
			// Noop.
		} else {
			idx := len(dirs)
			dirs = append(dirs, Directory{
				Kind: KindProject,
				Path: pd,
			})
			known[pd] = idx
		}
	}

	// Find all zoxide dirs.
	z := commands.Zoxide{
		List:  true,
		Score: true,
	}

	zoxideRecords, err := z.Query(ctx)
	if err != nil {
		log.Fatalf("Failed to query zoxide dirs: %s", err)
	}

	for _, zr := range zoxideRecords {
		if idx, ok := known[zr.Path]; ok {
			dirs[idx].Score += zr.Score
		} else {
			idx := len(dirs)
			dirs = append(dirs, Directory{
				Kind:  KindZoxide,
				Path:  zr.Path,
				Score: zr.Score,
			})
			known[zr.Path] = idx
		}
	}

	// Normalize dirs.
	sort.Stable(ByPriority(dirs))
	replaceDirPrefixes(dirs, homedir, "~")

	// Run FZF.
	var input bytes.Buffer
	for _, dir := range dirs {
		var (
			symbol string
			color  string
		)
		switch dir.Kind {
		case KindProject:
			symbol = defaultProjectsSymbol
			color = colors.Blue.String()

		case KindZoxide:
			symbol = defaultZoxideSymbol
			color = colors.Yellow.String()

		default:
			symbol = " "
			color = colors.Red.String()
		}

		_, _ = fmt.Fprintf(&input, "%s%s%s %s\n",
			color,
			symbol,
			colors.ResetColor.String(),
			dir.Path,
		)
	}

	fzf := commands.FZF{
		NoSort:  true,
		Tac:     true,
		ANSI:    true,
		Exit0:   true,
		Nth:     "2..",
		Preview: `eza -la --color=always $(sh -c 'echo {-1}')`,
	}

	results, err := fzf.Run(ctx, &input)
	if err != nil {
		var e *exec.ExitError
		if errors.As(err, &e) {
			// Interrupted with CTRL-C or ESC.
			if code := e.ExitCode(); code == 130 {
				os.Exit(code)
			}
		}

		log.Fatalf("Failed to run FZF: %s", err)
	}

	// Normalize and print results.
	var zoxideAddPaths []string
	for _, res := range results {
		if len(res) >= 4 {
			res = res[4:]
		}
		res = replacePrefix(res, "~", homedir)

		zoxideAddPaths = append(zoxideAddPaths, res)

		fmt.Println(res)

		break // Only the first dir.
	}

	// Update zoxide ranks.
	if len(zoxideAddPaths) > 0 {
		_ = z.Add(ctx, zoxideAddPaths...)
	}
}

func replaceDirPrefixes(dirs []Directory, oldPrefix, newPrefix string) {
	for i := range dirs {
		dirs[i].Path = replacePrefix(dirs[i].Path, oldPrefix, newPrefix)
	}
}

func replacePrefix(s, oldPrefix, newPrefix string) string {
	if len(oldPrefix) > len(s) {
		return s
	}

	if s[:len(oldPrefix)] != oldPrefix {
		return s
	}

	return newPrefix + s[len(oldPrefix):]
}
