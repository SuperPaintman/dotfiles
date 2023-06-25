package commands

import "strings"

type Error struct {
	Err    error
	Stderr string
}

func (e *Error) Error() string {
	var (
		nonEmpty bool
		b        strings.Builder
	)
	b.WriteString("commands")

	if e.Err != nil {
		nonEmpty = true
		b.WriteString(": ")
		b.WriteString(e.Err.Error())
	}

	if e.Stderr != "" {
		nonEmpty = true
		b.WriteString(":\n")
		b.WriteString(e.Stderr)
	}

	if !nonEmpty {
		b.WriteString(": unknown")
	}

	return b.String()
}
