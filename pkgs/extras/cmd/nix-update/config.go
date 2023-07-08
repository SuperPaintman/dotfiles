package main

import (
	"fmt"

	"gopkg.in/yaml.v3"
)

type Config struct {
	Output   string              `json:"output"`
	Packages map[string]*Package `yaml:"packages"`
}

type Package struct {
	Type            PackageType            `yaml:"type"`
	Pname           string                 `yaml:"pname"`
	VersionOverride string                 `yaml:"version"`
	ExtraAttrs      map[string]interface{} `yaml:"extraAttrs"`
	Args            PackageArgs            `yaml:"args"`
	BuildInputs     []string               `yaml:"buildInputs"`
	After           []*Command             `yaml:"after"`
}

func (p *Package) Version() string {
	if p.VersionOverride != "" {
		return p.VersionOverride
	}

	if p.Args != nil {
		switch args := p.Args.(type) {
		case *PackageGitArgs:
			return "0.0.0+rev=" + args.Rev[0:7]

		case *PackageGithubArgs:
			return "0.0.0+rev=" + args.Rev[0:7]
		}
	}

	return ""
}

func (p *Package) UnmarshalYAML(value *yaml.Node) error {
	pkg := struct {
		Type        PackageType            `yaml:"type"`
		Pname       string                 `yaml:"pname"`
		Version     string                 `yaml:"version"`
		ExtraAttrs  map[string]interface{} `yaml:"extraAttrs"`
		Args        yaml.Node              `yaml:"args"`
		BuildInputs []string               `yaml:"buildInputs"`
		After       []*Command             `yaml:"after"`
	}{}

	if err := value.Decode(&pkg); err != nil {
		return err
	}

	var args PackageArgs
	if pkg.Args.Kind == yaml.MappingNode {
		switch pkg.Type {
		case PackageTypeGit:
			var a PackageGitArgs
			if err := pkg.Args.Decode(&a); err != nil {
				return err
			}
			args = &a

		case PackageTypeGithub:
			var a PackageGithubArgs
			if err := pkg.Args.Decode(&a); err != nil {
				return err
			}
			args = &a

		default:
			return fmt.Errorf("nix-update: unknown package type: %s", pkg.Type)
		}
	}

	*p = Package{
		Type:            pkg.Type,
		Pname:           pkg.Pname,
		VersionOverride: pkg.Version,
		ExtraAttrs:      pkg.ExtraAttrs,
		Args:            args,
		BuildInputs:     pkg.BuildInputs,
		After:           pkg.After,
	}

	return nil
}

func (p *Package) MarshalYAML() (interface{}, error) {
	panic("not implemented")
}

type PackageType string

const (
	PackageTypeGit    = "git"
	PackageTypeGithub = "github"
)

type PackageArgs interface {
	packageArgs()
}

type PackageGitArgs struct {
	URL string `yaml:"url"`
	Rev string `yaml:"rev"`
}

func (*PackageGitArgs) packageArgs() {}

type PackageGithubArgs struct {
	Owner string `yaml:"owner"`
	Repo  string `yaml:"repo"`
	Rev   string `yaml:"rev"`
}

func (*PackageGithubArgs) packageArgs() {}

type CommandType string

const (
	CommandTypeShell  = "shell"
	CommandTypeUpdate = "update"
)

type CommandArgs interface {
	commandArgs()
}

type CommandShellArgs struct {
	Text string `yaml:"text"`
}

func (*CommandShellArgs) commandArgs() {}

type CommandUpdateArgs struct {
	Filename string `yaml:"filename"`
}

func (*CommandUpdateArgs) commandArgs() {}

type Command struct {
	Type CommandType `yaml:"type"`
	Args CommandArgs `yaml:"args"`
}

func (c *Command) UnmarshalYAML(value *yaml.Node) error {
	cmd := struct {
		Type CommandType `yaml:"type"`
		Args yaml.Node   `yaml:"args"`
	}{}

	if err := value.Decode(&cmd); err != nil {
		return err
	}

	var args CommandArgs
	if cmd.Args.Kind == yaml.MappingNode {
		switch cmd.Type {
		case CommandTypeShell:
			var a CommandShellArgs
			if err := cmd.Args.Decode(&a); err != nil {
				return err
			}
			args = &a

		case CommandTypeUpdate:
			var a CommandUpdateArgs
			if err := cmd.Args.Decode(&a); err != nil {
				return err
			}
			args = &a

		default:
			return fmt.Errorf("nix-update: unknown command type: %s", cmd.Type)
		}
	}

	*c = Command{
		Type: cmd.Type,
		Args: args,
	}

	return nil
}

func (c *Command) MarshalYAML() (interface{}, error) {
	panic("not implemented")
}
