package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"io"
	"log"
	"os"

	"github.com/SuperPaintman/dotfiles/pkgs/wtk"

	"github.com/SuperPaintman/nice/colors"
)

const (
	defaultLeftSymbol   = ""
	defaultRightSymbol  = ""
	defaultLeaderSymbol = "Leader"
	defaultMetaSymbol   = "Meta"
	defaultCtrlSymbol   = "Ctrl"
	defaultAltSymbol    = "Alt"
	// defaultShiftSymbol = "Shift"
)

const (
	spaces16  = "                "
	spaces32  = spaces16 + spaces16
	spaces64  = spaces32 + spaces32
	spaces128 = spaces64 + spaces64
	spaces    = spaces128 + spaces128
)

var (
	config    string
	colorMode string
)

func init() {
	flag.StringVar(&config, "c", "-", "Path to the config.")
	flag.StringVar(&colorMode, "color", "auto", "When to use colors (auto, never, always).")
}

func main() {
	flag.Parse()

	switch colorMode {
	case "auto":
		colors.SetMode(colors.Auto)

	case "never":
		colors.SetMode(colors.Never)

	case "always":
		colors.SetMode(colors.Always)

	default:
		log.Fatalf("Unknown color mode: %s", colorMode)
	}

	// Read the config.
	var b []byte
	if config == "-" {
		var err error
		b, err = io.ReadAll(os.Stdin)
		if err != nil {
			log.Fatalf("Failed to read the config from STDIN: %s", err)
		}
	} else {
		var err error
		b, err = os.ReadFile(config)
		if err != nil {
			log.Fatalf("Failed to read the config file: %s", err)
		}
	}

	// Parse the config.
	var cfg wtk.Config
	if err := json.Unmarshal(b, &cfg); err != nil {
		log.Fatalf("Failed to parse the config: %s", err)
	}

	// Print the key bindings.
	p := Printer{}
	p.Reset(os.Stdout)
	for i := range cfg.Groups {
		g := &cfg.Groups[i]

		p.CalculateAlignment(g.Bindings)
	}

	for i := range cfg.Groups {
		g := &cfg.Groups[i]

		if i > 0 || g.Name != "" {
			_ = p.PrintGroupName(g.Name)
		}

		for j := range g.Bindings {
			_ = p.PrintBinding(&g.Bindings[j])
		}
	}

	_ = p.Flush()
}

type Printer struct {
	LeftSymbol   string
	RightSymbol  string
	LeaderSymbol string
	MetaSymbol   string
	CtrlSymbol   string
	AltSymbol    string
	// ShiftSymbol string

	bw bufio.Writer
	w  interface {
		io.Writer
		io.ByteWriter
		io.StringWriter
	}
	err       error
	printed   int
	maxKeyLen int
}

func (p *Printer) Reset(w io.Writer) {
	p.bw.Reset(w)
	p.w = &p.bw
	p.err = nil
	p.printed = 0
	p.maxKeyLen = 0
}

func (p *Printer) Flush() error {
	return p.bw.Flush()
}

func (p *Printer) CalculateAlignment(bb []wtk.Binding) {
	oldW := p.w
	p.w = nil
	defer func() {
		p.w = oldW
	}()

	for j := range bb {
		b := &bb[j]

		p.printBinding(b, false)

		if p.printed > p.maxKeyLen {
			p.maxKeyLen = p.printed
		}
	}
}

func (p *Printer) PrintGroupName(name string) error {
	p.printed = 0

	if name != "" {
		p.printBold(name)

		if p.err != nil {
			return p.err
		}
	}

	if p.w != nil {
		if err := p.w.WriteByte('\n'); err != nil {
			return err
		}
	}

	return nil
}

func (p *Printer) PrintBinding(b *wtk.Binding) error {
	return p.printBinding(b, true)
}

func (p *Printer) printBinding(b *wtk.Binding, printDescription bool) error {
	p.printed = 0

	p.p("  ")

	for i, key := range b.Keys {
		if i > 0 {
			p.p("  ")
		}

		var counter int

		if key.Leader {
			if counter > 0 {
				p.printBold("+")
			}

			p.printKey(or(p.LeaderSymbol, defaultLeaderSymbol))
			counter++
		}

		if key.Meta {
			if counter > 0 {
				p.printBold("+")
			}

			p.printKey(or(p.MetaSymbol, defaultMetaSymbol))
			counter++
		}

		if key.Ctrl {
			if counter > 0 {
				p.printBold("+")
			}

			p.printKey(or(p.CtrlSymbol, defaultCtrlSymbol))
			counter++
		}

		if key.Alt {
			if counter > 0 {
				p.printBold("+")
			}

			p.printKey(or(p.AltSymbol, defaultAltSymbol))
			counter++
		}

		// if key.Shift {
		// 	if counter > 0 {
		// 		p.printBold("+")
		// 	}
		//
		// 	p.printKey(or(p.ShiftSymbol, defaultShiftSymbol))
		// 	counter++
		// }

		for _, k := range key.Keys {
			if counter > 0 {
				p.printBold("+")
			}

			p.printKey(k)
			counter++
		}

		if p.err != nil {
			return p.err
		}
	}

	if printDescription {
		if b.Description != "" {
			if len(b.Keys) > 0 {
				offset := p.maxKeyLen - p.printed + 4
				if offset <= 0 {
					offset = 4
				}

				for offset > 0 {
					s := offset
					if s >= len(spaces) {
						s = len(spaces)
					}

					p.p(spaces[:s])

					offset -= s
				}
			}

			p.p(b.Description)
		}

		if p.err != nil {
			return p.err
		}
	}

	if p.w != nil {
		if err := p.w.WriteByte('\n'); err != nil {
			return err
		}
	}

	return nil
}

func (p *Printer) printKey(k string) {
	// Left corner.
	p.pc(colors.White.String())
	p.p(or(p.LeftSymbol, defaultLeftSymbol))
	p.pc(colors.Reset.String())

	// Key.
	p.pc(colors.BgWhite.String())
	p.pc(colors.Bold.String())
	p.pc(colors.Black.String())
	p.p(k)
	p.pc(colors.Reset.String())
	p.pc(colors.ResetBold.String())
	p.pc(colors.ResetBgColor.String())

	// Right corner.
	p.pc(colors.White.String())
	p.p(or(p.RightSymbol, defaultRightSymbol))
	p.pc(colors.Reset.String())
}

func (p *Printer) printBold(s string) {
	p.pc(colors.Bold.String())
	p.p(s)
	p.pc(colors.ResetBold.String())
}

func (p *Printer) p(s string) {
	if p.err != nil {
		return
	}

	if p.w != nil {
		_, p.err = p.w.WriteString(s)
	}

	p.printed += len([]rune(s))
}

func (p *Printer) pc(s string) {
	if p.err != nil {
		return
	}

	if p.w != nil {
		_, p.err = p.w.WriteString(s)
	}
}

func or(a, b string) string {
	if a != "" {
		return a
	}
	return b
}
