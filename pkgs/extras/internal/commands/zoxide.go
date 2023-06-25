package commands

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"os/exec"
	"strconv"
	"strings"
)

type Zoxide struct {
	Executable string
	All        bool
	List       bool
	Score      bool
}

type ZoxideRecord struct {
	Score float64
	Path  string
}

func (z *Zoxide) Query(ctx context.Context, keywords ...string) ([]ZoxideRecord, error) {
	args := make([]string, 0, 16)

	args = append(args, "query")

	if z.All {
		args = append(args, "--all")
	}

	if z.List {
		args = append(args, "--list")
	}

	if z.Score {
		args = append(args, "--score")
	}

	args = append(args, keywords...)

	var (
		stdout bytes.Buffer
		stderr bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, z.executable(), args...)
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return nil, &Error{
			Err:    err,
			Stderr: stderr.String(),
		}
	}

	var records []ZoxideRecord
	s := bufio.NewScanner(&stdout)
	s.Split(bufio.ScanLines)
	for s.Scan() {
		line := strings.TrimSpace(s.Text())
		if line == "" {
			continue
		}

		var score float64
		path := line
		if z.Score {
			idx := strings.IndexRune(line, ' ')
			if idx < 0 {
				continue
			}

			var err error
			score, err = strconv.ParseFloat(line[:idx], 64)
			if err != nil {
				return nil, fmt.Errorf("commands: failed to parse zoxide score: %w", err)
			}

			path = line[idx+1:]
		}

		records = append(records, ZoxideRecord{
			Score: score,
			Path:  path,
		})
	}

	return records, nil
}

func (z *Zoxide) Add(ctx context.Context, paths ...string) error {
	args := make([]string, 0, 16)

	args = append(args, "add")
	args = append(args, paths...)

	var (
		stderr bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, z.executable(), args...)
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return &Error{
			Err:    err,
			Stderr: stderr.String(),
		}
	}

	return nil
}

func (z *Zoxide) executable() string {
	if z.Executable != "" {
		return z.Executable
	}

	return "zoxide"
}
