package commands

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type Tmux struct {
	Executable string
}

type TmuxSession struct {
	ID   int
	Name string
}

func (t *Tmux) ListSessions(ctx context.Context) ([]TmuxSession, error) {
	args := make([]string, 0, 16)

	args = append(args, "list-sessions")
	args = append(args, "-F", "#{session_id} #{session_name}")

	var (
		stdout bytes.Buffer
		stderr bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, t.executable(), args...)
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return nil, &Error{
			Err:    err,
			Stderr: stderr.String(),
		}
	}

	var sessions []TmuxSession
	s := bufio.NewScanner(&stdout)
	s.Split(bufio.ScanLines)
	for s.Scan() {
		line := strings.TrimSpace(s.Text())
		if line == "" {
			continue
		}

		var (
			id   int
			name string
		)
		if _, err := fmt.Sscanf(line, "$%d %s", &id, &name); err != nil {
			continue
		}

		sessions = append(sessions, TmuxSession{
			ID:   id,
			Name: name,
		})
	}

	return sessions, nil
}

func (t *Tmux) PaneSession(ctx context.Context, pane string) (*TmuxSession, error) {
	args := make([]string, 0, 16)

	args = append(args, "list-panes")
	args = append(args, "-t", pane)
	args = append(args, "-F", "#{session_id} #{session_name}")

	var (
		stdout bytes.Buffer
		stderr bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, t.executable(), args...)
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return nil, &Error{
			Err:    err,
			Stderr: stderr.String(),
		}
	}

	var session *TmuxSession
	s := bufio.NewScanner(&stdout)
	s.Split(bufio.ScanLines)
	for s.Scan() {
		line := strings.TrimSpace(s.Text())
		if line == "" {
			continue
		}

		var (
			id   int
			name string
		)
		if _, err := fmt.Sscanf(line, "$%d %s", &id, &name); err != nil {
			continue
		}

		session = &TmuxSession{
			ID:   id,
			Name: name,
		}

		break // Only the first session.
	}

	return session, nil
}

type TmuxOptions struct {
	Detach          bool
	SessionName     string
	StartDirrectory string
	Interactive     bool
}

func (src *TmuxOptions) ApplyTmuxOption(o *TmuxOptions) {
	if src == nil {
		return
	}

	if src.Detach {
		o.Detach = src.Detach
	}

	if src.SessionName != "" {
		o.SessionName = src.SessionName
	}

	if src.StartDirrectory != "" {
		o.StartDirrectory = src.StartDirrectory
	}

	if src.Interactive {
		o.Interactive = src.Interactive
	}
}

type TmuxOption interface {
	ApplyTmuxOption(*TmuxOptions)
}

type TmuxOptionFunc func(*TmuxOptions)

func (f TmuxOptionFunc) ApplyTmuxOption(o *TmuxOptions) {
	if f != nil {
		f(o)
	}
}

func WithTmuxDetach(v bool) TmuxOption {
	return TmuxOptionFunc(func(o *TmuxOptions) { o.Detach = v })
}

func WithTmuxSessionName(name string) TmuxOption {
	return TmuxOptionFunc(func(o *TmuxOptions) { o.SessionName = name })
}

func WithTmuxStartDirrectory(name string) TmuxOption {
	return TmuxOptionFunc(func(o *TmuxOptions) { o.StartDirrectory = name })
}

func WithTmuxInteractive(v bool) TmuxOption {
	return TmuxOptionFunc(func(o *TmuxOptions) { o.Interactive = v })
}

func (t *Tmux) SwitchClient(ctx context.Context, opts ...TmuxOption) error {
	var o TmuxOptions
	collectTmuxOptions(&o, opts...)

	args := make([]string, 0, 16)

	args = append(args, "switch-client")

	if o.SessionName != "" {
		args = append(args, "-t", o.SessionName)
	}

	return t.run(ctx, o.Interactive, args...)
}

func (t *Tmux) NewSession(ctx context.Context, opts ...TmuxOption) error {
	var o TmuxOptions
	collectTmuxOptions(&o, opts...)

	args := make([]string, 0, 16)

	args = append(args, "new-session")

	if o.Detach {
		args = append(args, "-d")
	}

	if o.SessionName != "" {
		args = append(args, "-s", o.SessionName)
	}

	if o.StartDirrectory != "" {
		args = append(args, "-c", o.StartDirrectory)
	}

	return t.run(ctx, o.Interactive, args...)
}

func (t *Tmux) AttachSession(ctx context.Context, opts ...TmuxOption) error {
	var o TmuxOptions
	collectTmuxOptions(&o, opts...)

	args := make([]string, 0, 16)

	args = append(args, "attach-session")

	if o.SessionName != "" {
		args = append(args, "-t", o.SessionName)
	}

	return t.run(ctx, o.Interactive, args...)
}

func (t *Tmux) run(ctx context.Context, interactive bool, arg ...string) error {
	var (
		stderr bytes.Buffer
	)

	cmd := exec.CommandContext(ctx, t.executable(), arg...)
	if interactive {
		cmd.Stdin = os.Stdin
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
	} else {
		cmd.Stderr = &stderr
	}

	if err := cmd.Run(); err != nil {
		return &Error{
			Err:    err,
			Stderr: stderr.String(),
		}
	}

	return nil
}

func (t *Tmux) executable() string {
	if t.Executable != "" {
		return t.Executable
	}

	return "tmux"
}

func collectTmuxOptions(o *TmuxOptions, opts ...TmuxOption) {
	for _, opt := range opts {
		if opt != nil {
			opt.ApplyTmuxOption(o)
		}
	}
}
