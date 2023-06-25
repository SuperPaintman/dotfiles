package commands

import (
	"bufio"
	"bytes"
	"context"
	"os/exec"
	"strconv"
	"strings"
)

type FD struct {
	Executable string
	Hidden     bool
	MaxDepth   int
	Type       string
}

func (fd *FD) Find(ctx context.Context, pattern string, path ...string) ([]string, error) {
	args := make([]string, 0, 16)

	if fd.Hidden {
		args = append(args, "--hidden")
	}

	if fd.MaxDepth > 0 {
		args = append(args, "--max-depth", strconv.Itoa(fd.MaxDepth))
	}

	if fd.Type != "" {
		args = append(args, "--type", fd.Type)
	}

	args = append(args, "--color", "never")

	args = append(args, pattern)
	args = append(args, path...)

	var (
		stdout bytes.Buffer
		stderr bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, fd.executable(), args...)
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return nil, &Error{
			Err:    err,
			Stderr: stderr.String(),
		}
	}

	var paths []string
	s := bufio.NewScanner(&stdout)
	s.Split(bufio.ScanLines)
	for s.Scan() {
		path := strings.TrimSpace(s.Text())
		if path != "" {
			paths = append(paths, path)
		}
	}

	return paths, nil
}

func (fd *FD) executable() string {
	if fd.Executable != "" {
		return fd.Executable
	}

	return "fd"
}
