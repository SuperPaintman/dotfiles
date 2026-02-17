package main

import (
	"fmt"
	"strconv"
	"strings"
)

type RofiState uint8

const (
	RofiStateInitialCall         RofiState = 0
	RofiStateSelectedEntry       RofiState = 1
	RofiStateSelectedCustomEntry RofiState = 2
	RofiStateDeletedEntry        RofiState = 3

	RofiStateCustomKeybinding1  RofiState = 10
	RofiStateCustomKeybinding2  RofiState = 11
	RofiStateCustomKeybinding3  RofiState = 12
	RofiStateCustomKeybinding4  RofiState = 13
	RofiStateCustomKeybinding5  RofiState = 14
	RofiStateCustomKeybinding6  RofiState = 15
	RofiStateCustomKeybinding7  RofiState = 16
	RofiStateCustomKeybinding8  RofiState = 17
	RofiStateCustomKeybinding9  RofiState = 18
	RofiStateCustomKeybinding10 RofiState = 19
	RofiStateCustomKeybinding11 RofiState = 20
	RofiStateCustomKeybinding12 RofiState = 21
	RofiStateCustomKeybinding13 RofiState = 22
	RofiStateCustomKeybinding14 RofiState = 23
	RofiStateCustomKeybinding15 RofiState = 24
	RofiStateCustomKeybinding16 RofiState = 25
	RofiStateCustomKeybinding17 RofiState = 26
	RofiStateCustomKeybinding18 RofiState = 27
	RofiStateCustomKeybinding19 RofiState = 28

	RofiStateError RofiState = 255
)

func (rs RofiState) String() string {
	switch rs {
	case RofiStateInitialCall:
		return "InitialCall"
	case RofiStateSelectedEntry:
		return "SelectedEntry"
	case RofiStateSelectedCustomEntry:
		return "SelectedCustomEntry"
	case RofiStateDeletedEntry:
		return "DeletedEntry"

	case RofiStateCustomKeybinding1:
		return "CustomKeybinding1"
	case RofiStateCustomKeybinding2:
		return "CustomKeybinding2"
	case RofiStateCustomKeybinding3:
		return "CustomKeybinding3"
	case RofiStateCustomKeybinding4:
		return "CustomKeybinding4"
	case RofiStateCustomKeybinding5:
		return "CustomKeybinding5"
	case RofiStateCustomKeybinding6:
		return "CustomKeybinding6"
	case RofiStateCustomKeybinding7:
		return "CustomKeybinding7"
	case RofiStateCustomKeybinding8:
		return "CustomKeybinding8"
	case RofiStateCustomKeybinding9:
		return "CustomKeybinding9"
	case RofiStateCustomKeybinding10:
		return "CustomKeybinding10"
	case RofiStateCustomKeybinding11:
		return "CustomKeybinding11"
	case RofiStateCustomKeybinding12:
		return "CustomKeybinding12"
	case RofiStateCustomKeybinding13:
		return "CustomKeybinding13"
	case RofiStateCustomKeybinding14:
		return "CustomKeybinding14"
	case RofiStateCustomKeybinding15:
		return "CustomKeybinding15"
	case RofiStateCustomKeybinding16:
		return "CustomKeybinding16"
	case RofiStateCustomKeybinding17:
		return "CustomKeybinding17"
	case RofiStateCustomKeybinding18:
		return "CustomKeybinding18"
	case RofiStateCustomKeybinding19:
		return "CustomKeybinding19"

	case RofiStateError:
		return "Error"

	default:
		return fmt.Sprintf("RofiState(%d)", rs)
	}
}

// ParseRofiState returns the RofiState from ROFI_RETV.
func ParseRofiState(s string) RofiState {
	v, err := strconv.ParseUint(s, 10, 8)
	if err != nil {
		v = 255
	}
	return RofiState(v)
}

// See: https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown#passing-mode-options
func SetModeOption(name, value string) {
	value = strings.ReplaceAll(value, "\n", "\\n")

	const null = string(rune(0))
	fmt.Printf(null+"%s\x1f%s\n", name, value)
}

// SetPrompt updates the prompt text.
func SetPrompt(text string) {
	SetModeOption("prompt", text)
}

// SetMessage updates the message text.
func SetMessage(text string) {
	SetModeOption("message", text)
}

// SetMarkupRows sets the markup-rows option. If true, renders markup in the
// row.
func SetMarkupRows(value bool) {
	SetModeOption("markup-rows", bool2String(value))
}

// urgent

// active

// delim

// SetNoCustom sets the no-custom option. If true, only accepts listed entries,
// and ignores custom input.
func SetNoCustom(value bool) {
	SetModeOption("no-custom", bool2String(value))
}

// use-hot-keys

// keep-selection

// keep-filter

// new-selection

// data

// theme

// switch-mode

// https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown#parsing-row-options
type RowOptions struct {
	Icon          string // Icon for the row.
	Display       string // Replacement for the displayed text.
	Meta          string // Invisible search term for filtering.
	NonSelectable bool   // If true the row cannot be activated.
	// permanent
	// info
	// urgent
	Active bool // Set active flag on entry.
}

type RowOption func(o *RowOptions)

// WithIcon sets the icon for the row.
func WithIcon(icon string) RowOption { return func(o *RowOptions) { o.Icon = icon } }

// WithDisplay sets the display text for the row.
func WithDisplay(display string) RowOption { return func(o *RowOptions) { o.Display = display } }

// WithMeta sets the invisible search term for filtering.
func WithMeta(meta string) RowOption { return func(o *RowOptions) { o.Meta = meta } }

// WithNonSelectable makes the row non-selectable / cannot be activated.
func WithNonSelectable(v bool) RowOption { return func(o *RowOptions) { o.NonSelectable = v } }

// SetActive sets active flag on entry.
func WithActive(v bool) RowOption { return func(o *RowOptions) { o.Active = v } }

func Option(value string, opts ...RowOption) {
	var o RowOptions
	for _, opt := range opts {
		if opt != nil {
			opt(&o)
		}
	}

	fmt.Printf("%s", value)

	// Apply options.
	const (
		null       = string(rune(0))
		firstDelim = null
		nextDelim  = "\x1f"
	)

	delim := firstDelim

	for _, ro := range [...]struct {
		Key, Value string
	}{
		{"icon", o.Icon},
		{"display", o.Display},
		{"meta", o.Meta},
		{"nonselectable", true2String(o.NonSelectable)},
		{"active", true2String(o.Active)},
	} {
		if ro.Value != "" {
			fmt.Printf("%s%s%s%s", delim, ro.Key, nextDelim, ro.Value)
			delim = nextDelim
		}
	}

	fmt.Printf("\n")
}

func ParseRofiColor(v string) string {
	if v == "" {
		return "inherit"
	}
	return v
}

func bool2String(v bool) string {
	if v {
		return "true"
	}
	return "false"
}

func true2String(v bool) string {
	if v {
		return "true"
	}
	return ""
}
