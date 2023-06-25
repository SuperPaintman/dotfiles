package commands

import (
	"bufio"
	"bytes"
	"context"
	"errors"
	"io"
	"os"
	"os/exec"
	"strconv"
)

type FZF struct {
	Executable string

	// Search
	Nth    string
	NoSort bool
	Tac    bool

	// Interface
	Multi int

	// Layout
	Border string

	// Display
	ANSI bool

	// Preview
	Preview string

	// Scriptiong
	Exit0 bool
}

func (fzf *FZF) Run(ctx context.Context, input io.Reader) ([]string, error) {
	args := make([]string, 0, 16)

	// Search
	if fzf.Nth != "" {
		args = append(args, "--nth", fzf.Nth)
	}

	if fzf.NoSort {
		args = append(args, "--no-sort")
	}

	if fzf.Tac {
		args = append(args, "--tac")
	}

	// Interface
	if fzf.Multi < 0 {
		args = append(args, "--multi")
	} else if fzf.Multi > 0 {
		args = append(args, "--multi", strconv.Itoa(fzf.Multi))
	}

	// Layout
	if fzf.Border != "" {
		args = append(args, "--border", fzf.Border)
	}

	// Display
	if fzf.ANSI {
		args = append(args, "--ansi")
	}

	// Preview
	if fzf.Preview != "" {
		args = append(args, "--preview", fzf.Preview)
	}

	// Scriptiong
	if fzf.Exit0 {
		args = append(args, "--exit-0")
	}

	var (
		stdout bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, fzf.executable(), args...)
	cmd.Stdin = input
	cmd.Stdout = &stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		var e *exec.ExitError
		if errors.As(err, &e) {
			if e.ExitCode() == 1 {
				return nil, nil
			}
		}

		return nil, err
	}

	var results []string
	s := bufio.NewScanner(&stdout)
	s.Split(bufio.ScanLines)
	for s.Scan() {
		results = append(results, s.Text())
	}

	return results, nil
}

func (fzf *FZF) executable() string {
	if fzf.Executable != "" {
		return fzf.Executable
	}

	return "fzf"
}
