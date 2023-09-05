// See: https://github.com/joshmedeski/t-smart-tmux-session-manager

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
	"regexp"
	"sort"

	"github.com/SuperPaintman/nice/colors"

	"github.com/SuperPaintman/dotfiles/pkgs/extras/internal/commands"
)

var (
	projectsDir         string
	personalProjectsDir string
)

func init() {
	flag.StringVar(&projectsDir, "projects", "~/Projects", "Path to the projects dir.")
	flag.StringVar(&personalProjectsDir, "personal-projects", "~/Projects", "Path to the personal projects dir.")
}

const (
	defaultProjectsSymbol = ""
	defaultZoxideSymbol   = ""
	defaultTmuxSymbol     = ""
)

type Kind uint8

const (
	KindProject Kind = iota
	KindZoxide
	KindTmux
)

type Session struct {
	Kind    Kind
	Name    string
	Current bool
	Active  bool
	Score   float64
	Path    string
}

type ByPriority []Session

func (s ByPriority) Len() int      { return len(s) }
func (s ByPriority) Swap(i, j int) { s[i], s[j] = s[j], s[i] }
func (s ByPriority) Less(i, j int) bool {
	if s[i].Current != s[j].Current {
		return !s[i].Current
	}

	if s[i].Active != s[j].Active {
		return !s[i].Active
	}

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

	// Check if tmux is running.
	_, tmuxRunning := os.LookupEnv("TMUX")
	tmuxPane := os.Getenv("TMUX_PANE")

	// Find sessions.
	ctx := context.Background()

	knownName := make(map[string]int)
	knownPath := make(map[string]int)
	var sessions []Session

	// Get current session.
	tmux := commands.Tmux{}

	var currentSession *commands.TmuxSession
	if tmuxRunning && tmuxPane != "" {
		session, err := tmux.PaneSession(ctx, tmuxPane)
		if err != nil {
			// Ignore tmux errors, maybe tmux is not running.
		} else {
			currentSession = session
		}
	}

	// Find active sessions.
	tmuxActiveSessions, err := tmux.ListSessions(ctx)
	if err != nil {
		// Ignore tmux errors, maybe tmux is not running.
	}

	for _, s := range tmuxActiveSessions {
		current := currentSession != nil && currentSession.ID == s.ID

		if idx, ok := knownName[s.Name]; ok {
			session := &sessions[idx]

			session.Current = current
			session.Active = true

			if session.Name == "" {
				session.Name = s.Name
			}
		} else {
			idx := len(sessions)
			sessions = append(sessions, Session{
				Kind:    KindTmux,
				Current: current,
				Active:  true,
				Name:    s.Name,
			})
			knownName[s.Name] = idx
		}
	}

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
		name := pathToTmuxSessionName(pd, homedir, projectsDir, personalProjectsDir)

		var session *Session
		if session == nil {
			if idx, ok := knownPath[pd]; ok {
				session = &sessions[idx]
				knownName[name] = idx
			}
		}

		if session == nil {
			if idx, ok := knownName[name]; ok {
				session = &sessions[idx]
				knownPath[pd] = idx
			}
		}

		if session != nil {
			if session.Name == "" {
				session.Name = name
			}
			if session.Path == "" {
				session.Path = pd
			}
		} else {
			idx := len(sessions)
			sessions = append(sessions, Session{
				Kind: KindProject,
				Name: name,
				Path: pd,
			})
			knownName[name] = idx
			knownPath[pd] = idx
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
		name := pathToTmuxSessionName(zr.Path, homedir, "", "")

		var session *Session
		if session == nil {
			if idx, ok := knownPath[zr.Path]; ok {
				session = &sessions[idx]
				knownName[name] = idx
			}
		}

		if session == nil {
			if idx, ok := knownName[name]; ok {
				session = &sessions[idx]
				knownPath[zr.Path] = idx
			}
		}

		if session != nil {
			if session.Name == "" {
				session.Name = name
			}
			if session.Path == "" {
				session.Path = zr.Path
			}
			session.Score += zr.Score
		} else {
			idx := len(sessions)
			sessions = append(sessions, Session{
				Kind:  KindZoxide,
				Name:  name,
				Path:  zr.Path,
				Score: zr.Score,
			})
			knownName[name] = idx
			knownPath[zr.Path] = idx
		}
	}

	// Sort sessions.
	sort.Stable(ByPriority(sessions))

	// Reindex sessions.
	for idx, session := range sessions {
		if session.Name != "" {
			knownName[session.Name] = idx
		}

		if session.Path != "" {
			knownPath[session.Path] = idx
		}
	}

	// Run FZF.
	var input bytes.Buffer
	for _, session := range sessions {
		var (
			symbol string
			color  string
		)
		switch session.Kind {
		case KindProject:
			symbol = defaultProjectsSymbol
			color = colors.Blue.String()

		case KindZoxide:
			symbol = defaultZoxideSymbol
			color = colors.Yellow.String()

		case KindTmux:
			symbol = defaultTmuxSymbol
			if session.Current {
				color = colors.Magenta.String()
			} else {
				color = colors.Green.String()
			}

		default:
			symbol = " "
			color = colors.Red.String()
		}

		_, _ = fmt.Fprintf(&input, "%s%s%s %s\n",
			color,
			symbol,
			colors.ResetColor.String(),
			session.Name,
		)
	}

	fzf := commands.FZF{
		NoSort: true,
		Tac:    true,
		ANSI:   true,
		Exit0:  true,
		Nth:    "2..",
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

	// Normalize and create tmux sessions.
	for _, res := range results {
		if len(res) >= 4 {
			res = res[4:]
		}

		session := &sessions[knownName[res]]

		// Get the default path.
		path := session.Path
		if path == "" {
			path, _ = os.Getwd()
		}
		if path == "" && homedir != "" {
			path = homedir
		}
		if path == "" {
			path = "/"
		}

		// Update zoxide ranks.
		if session.Path != "" {
			_ = z.Add(ctx, session.Path)
		}

		// Create tmux session.
		var err error
		if tmuxRunning {
			if session.Active {
				err = tmux.SwitchClient(ctx, commands.WithTmuxSessionName(session.Name))
			} else {
				err = tmux.NewSession(ctx,
					commands.WithTmuxDetach(true),
					commands.WithTmuxSessionName(session.Name),
					commands.WithTmuxStartDirrectory(path),
				)
				if err == nil {
					err = tmux.SwitchClient(ctx, commands.WithTmuxSessionName(session.Name))
				}
			}
		} else {
			if session.Active {
				tmux.AttachSession(ctx,
					commands.WithTmuxInteractive(true),
					commands.WithTmuxSessionName(session.Name),
				)
			} else {
				err = tmux.NewSession(ctx,
					commands.WithTmuxInteractive(true),
					commands.WithTmuxSessionName(session.Name),
					commands.WithTmuxStartDirrectory(path),
				)
			}
		}

		if err != nil {
			log.Fatalf("Failed to execute tmux command: %s", err)
		}

		break // Only the first session.
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

var tmuxIlligalSessionSymbolsRe = regexp.MustCompile("[\\ \\.:]")

func pathToTmuxSessionName(s, homedir, projectsDir, personalProjectsDir string) string {
	projectsDir = replacePrefix(projectsDir, "~", homedir)
	personalProjectsDir = replacePrefix(personalProjectsDir, "~", homedir)

	res := s

	var replaced bool

	if personalProjectsDir != "" && !replaced {
		res = replacePrefix(res, personalProjectsDir, "")
		replaced = s != res
	}

	if personalProjectsDir != "" && !replaced {
		res = replacePrefix(res, projectsDir, "")
		replaced = s != res
	}

	if replaced && res == "" {
		res = s
		replaced = false
	}

	if !replaced {
		res = replacePrefix(res, homedir, "~")
		replaced = s != res
	}

	res = replacePrefix(res, "/", "")

	return tmuxIlligalSessionSymbolsRe.ReplaceAllString(res, "_")
}
