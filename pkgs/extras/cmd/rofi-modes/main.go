// See: https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown

package main

import (
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"strings"
)

var errRofiLogDisabled = errors.New("rofi log disabled")

var rofiLogFile io.Writer

func RofiLogf(format string, a ...any) (n int, err error) {
	if rofiLogFile != nil {
		return fmt.Fprintf(rofiLogFile, format, a...)
	} else {
		return 0, errRofiLogDisabled
	}
}

type State struct {
	Frames []StateFrame `json:"frames"`
}

type StateMode string

const (
	StateModeMain StateMode = "main"

	StateModeVPN        StateMode = "vpn"
	StateModeWiFi       StateMode = "wifi"
	StateModeScreenshot StateMode = "screenshot"
	StateModePower      StateMode = "power"
)

func (sm StateMode) Valid() bool {
	switch sm {
	case StateModeMain, StateModeVPN, StateModeWiFi, StateModeScreenshot, StateModePower:
		return true
	default:
		return false
	}
}

type StateFrame struct {
	Mode  StateMode       `json:"mode"`
	Value json.RawMessage `json:"raw"`
}

func sh(args ...string) (output []byte, err error) {
	// cmd := exec.Command(name, args...)
	cmd := exec.Command("bash", "-c", strings.Join(args, " "))

	cmd.Env = os.Environ()

	return cmd.Output()
}

var (
	modeRaw string
)

func init() {
	flag.StringVar(&modeRaw, "mode", string(StateModeMain), "")
}

func main() {
	flag.Parse()

	mode := StateMode(modeRaw)
	if !mode.Valid() {
		mode = StateModeMain
	}

	colorBase6 := ParseRofiColor(os.Getenv("ROFI_CUSTOM_COLOR_BASE6"))

	// Debug rofi.
	const debug = false
	const rofiLogFilename = ""
	if rofiLogFilename != "" {
		rlf, err := os.OpenFile(rofiLogFilename, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
		if err == nil {
			defer rlf.Close()
			rofiLogFile = rlf
		}
	}

	// Parse args.
	args := flag.Args()

	// Selected option.
	var selected string
	if len(args) > 0 {
		selected = args[0]
	}

	rofiState := ParseRofiState(os.Getenv("ROFI_RETV"))

	RofiLogf("---\n")
	if debug {
		RofiLogf("rofi-modes:\n")
		RofiLogf("    mode: %s\n", mode)
		RofiLogf("    rofiState: %s\n", rofiState)
		RofiLogf("    args: %v\n", args)
		RofiLogf("    selected: %q\n", selected)
		RofiLogf("    env:\n")
		for _, env := range os.Environ() {
			key, value, _ := strings.Cut(env, "=")
			if strings.HasPrefix(key, "ROFI_") {
				RofiLogf("        %s: %q\n", key, value)
			}
		}
	}

	// Parse data.
	var state State
	if data, ok := os.LookupEnv("ROFI_DATA"); ok && data != "" {
		if err := json.Unmarshal([]byte(data), &state); err != nil {
			RofiLogf("error: failed to decode rofi data: %s\n", err)
		}
	}

	if len(state.Frames) == 0 {
		state.Frames = append(state.Frames, StateFrame{Mode: mode})
	}

	// Handle action.
	var err error
	switch selected {
	case "main:vpn":
		state.Frames = append(state.Frames, StateFrame{Mode: StateModeVPN})
	case "main:wifi":
		state.Frames = append(state.Frames, StateFrame{Mode: StateModeWiFi})
	case "main:screenshot":
		state.Frames = append(state.Frames, StateFrame{Mode: StateModeScreenshot})
	case "main:power":
		state.Frames = append(state.Frames, StateFrame{Mode: StateModePower})

	case "screenshot:screen":
		// TODO(SuperPaintman): send notification about the taken screenshot.
		_, err = sh("~/bin/screenshot", "screen")
		if err == nil {
			return
		}
	case "screenshot:area":
		_, err = sh("~/bin/screenshot", "area")
		if err == nil {
			return
		}
	case "screenshot:window":
		_, err = sh("~/bin/screenshot", "window")
		if err == nil {
			return
		}

	case "power:suspend":
		_, err = sh("systemctl", "suspend")
		if err == nil {
			return
		}
	case "power:poweroff":
		_, err = sh("systemctl", "poweroff")
		if err == nil {
			return
		}
	case "power:reboot":
		_, err = sh("systemctl", "reboot")
		if err == nil {
			return
		}
	case "power:hibernate":
		_, err = sh("systemctl", "hibernate")
		if err == nil {
			return
		}

	case "[back]":
		if len(state.Frames) > 1 {
			state.Frames = state.Frames[:len(state.Frames)-1]
		}
	}
	frame := &state.Frames[len(state.Frames)-1]
	mode = frame.Mode

	// Mode options.
	SetMarkupRows(true)
	SetNoCustom(true)

	if err != nil {
		SetMessage(err.Error())
	}

	if debug {
		RofiLogf("state:\n")
		RofiLogf("    mode: %s\n", mode)
		RofiLogf("    frames: %#+v\n", state.Frames)
	}

	// Data.
	data, err := json.Marshal(&state)
	if err != nil {
		RofiLogf("error: failed to encode rofi data: %s\n", err)
	} else {
		const null = string(rune(0))
		fmt.Printf(null+"%s\x1f%s\n", "data", data)
	}

	// Options.
	switch mode {
	case StateModeMain:
		Option("main:power",
			WithDisplay("Power"),
			// WithIcon("battery"),
		)

		Option("main:vpn",
			WithDisplay("VPN"),
			WithMeta("WireGuard"),
			// WithIcon("network-vpn"),
		)

		Option("main:wifi",
			WithDisplay("WiFi"),
		)

		Option("main:screenshot",
			WithDisplay("Screenshot"),
		)

	case StateModeVPN:

	case StateModeWiFi:

	case StateModeScreenshot:
		Option("screenshot:screen", WithDisplay("Screen"))
		Option("screenshot:area", WithDisplay("Area"))
		Option("screenshot:window", WithDisplay("Window"))

	case StateModePower:
		Option("power:suspend", WithDisplay("Suspend"))
		Option("power:poweroff", WithDisplay("Power-off"))
		Option("power:reboot", WithDisplay("Reboot"))
		Option("power:hibernate", WithDisplay("Hibernate"))
	}

	if len(state.Frames) > 1 {
		// Back options.
		Option("---",
			WithDisplay("<span color='#00000000'></span>"),
			WithNonSelectable(true),
		)

		Option("[back]",
			WithDisplay("<span color='"+colorBase6+"'>[back]</span>"),
		)
	}
}
