package colors

import (
	"fmt"
	"math"
)

// RGBA represents a color in the Red-Green-Blue-Alpha color space.
type RGBA struct {
	r, g, b uint8
	a       float64
}

// HSLA represents a color in the Hue-Saturation-Lightness-Alpha color space.
type HSLA struct {
	h, s, l float64
	a       float64
}

// NewRGB creates a new RGBA color with the given red, green, and blue
// components.
// Alpha is set to 1 by default.
func NewRGB(r, g, b uint8) *RGBA {
	return NewRGBA(r, g, b, 1)
}

// NewRGBA creates a new RGBA color with the given red, green, blue, and alpha
// components.
func NewRGBA(r, g, b uint8, a float64) *RGBA {
	return &RGBA{
		r: r,
		g: g,
		b: b,
		a: boundFloat(0, a, 1),
	}
}

// NewHex creates a new RGBA color from a hexadecimal color code.
func NewHex(hex uint32) *RGBA {
	if hex >= 0xffffff {
		hex = 0xffffff
	}

	r := uint8((hex >> 16) & 0xff)
	g := uint8((hex >> 8) & 0xff)
	b := uint8((hex >> 0) & 0xff)

	return NewRGB(r, g, b)
}

// String returns a string representation of the RGBA color.
func (c *RGBA) String() string {
	return fmt.Sprintf("RGBA(%d, %d, %d, %f)", c.r, c.g, c.b, c.a)
}

// HexString returns a string representation of the RGBA color in hexadecimal
// format.
func (c *RGBA) HexString() string {
	return fmt.Sprintf("#%02x%02x%02x", c.r, c.g, c.b)
}

// Hex8String returns a string representation of the RGBA color in hexadecimal
// format with alpha component.
func (c *RGBA) Hex8String() string {
	return fmt.Sprintf("#%02x%02x%02x%02x", c.r, c.g, c.b, uint8(boundFloat(0, 255.0*c.a, 255)))
}

// HSL returns a HSLA representation of the RGBA color.
func (c *RGBA) HSL() *HSLA {
	h, s, l := rgbToHSL(c.r, c.g, c.b)
	return NewHSLA(h, s, l, c.a)
}

// NewHSL creates a new HSLA color with the given hue, saturation, and
// lightness components.
// Alpha is set to 1 by default.
func NewHSL(h, s, l float64) *HSLA {
	return NewHSLA(h, s, l, 1)
}

// NewHSLA creates a new HSLA color with the given hue, saturation, lightness,
// and alpha components.
func NewHSLA(h, s, l, a float64) *HSLA {
	return &HSLA{
		h: boundFloat(0, h, 1),
		s: boundFloat(0, s, 1),
		l: boundFloat(0, l, 1),
		a: boundFloat(0, a, 1),
	}
}

// String returns a string representation of the HSLA color.
func (c *HSLA) String() string {
	return fmt.Sprintf("HSLA(%.0f, %.0f%%, %0.f%%, %f)", c.h*360, c.s*100, c.l*100, c.a)
}

// RGB returns a RGBA representation of the HSLA color.
func (c *HSLA) RGB() *RGBA {
	r, g, b := hslToRGB(c.h, c.s, c.l)
	return NewRGBA(r, g, b, c.a)
}

// clone creates a copy of the HSLA color.
func (c *HSLA) clone() *HSLA {
	if c == nil {
		return nil
	}

	hsla := *c
	return &hsla
}

// Spin applies a hue rotation to the HSLA color.
func (c *HSLA) Spin(amount float64) *HSLA {
	hsl := c.clone()

	hue := int64((hsl.h+amount)*360.0) % 360
	if hue < 0 {
		hue = 360 + hue
	}

	hsl.h = float64(hue) / 360.0
	return hsl
}

// rgbToHSL converts a RGB color to a HSL color.
func rgbToHSL(r, g, b uint8) (h, s, l float64) {
	rr := float64(r) / 255
	gg := float64(g) / 255
	bb := float64(b) / 255

	max := max3(rr, gg, bb)
	min := min3(rr, gg, bb)

	// Luminosity.
	l = (max + min) / 2

	delta := max - min
	if delta == 0 {
		return 0, 0, l
	}

	// Saturation.
	if l <= 0.5 {
		s = delta / (max + min)
	} else {
		s = delta / (2.0 - max - min)
	}

	// Hue.
	if rr == max {
		if gg < bb {
			h = ((gg-bb)/delta + 6) / 6
		} else {
			h = ((gg - bb) / delta) / 6
		}
	} else if gg == max {
		h = ((bb-rr)/delta + 2) / 6
	} else if bb == max {
		h = ((rr-gg)/delta + 4) / 6
	}

	return h, s, l
}

// hslToRGB converts a HSL color to a RGB color.
func hslToRGB(h, s, l float64) (r, g, b uint8) {
	if s == 0.0 {
		x := uint8(boundFloat(0, l*255, 255))
		return x, x, x
	}

	var q float64
	if l < 0.5 {
		q = l * (1 + s)
	} else {
		q = l + s - l*s
	}

	p := 2*l - q

	rr := hueToRGB(p, q, h+1.0/3.0)
	gg := hueToRGB(p, q, h)
	bb := hueToRGB(p, q, h-1.0/3.0)

	r = uint8(boundFloat(0, math.Round(rr*255), 255))
	g = uint8(boundFloat(0, math.Round(gg*255), 255))
	b = uint8(boundFloat(0, math.Round(bb*255), 255))

	return r, g, b
}

// hueToRGB converts a hue to a RGB color.
func hueToRGB(p, q, t float64) float64 {
	if t < 0 {
		t += 1
	} else if t > 1 {
		t -= 1
	}

	if t < 1.0/6.0 {
		return p + (q-p)*6.0*t
	}
	if t < 0.5 {
		return q
	}
	if t < 2.0/3.0 {
		return p + (q-p)*(2.0/3.0-t)*6.0
	}
	return p
}

func max(a, b float64) float64 {
	if a > b {
		return a
	}
	return b
}

func max3(a, b, c float64) float64 {
	return max(a, max(b, c))
}

func min(a, b float64) float64 {
	if a < b {
		return a
	}
	return b
}

func min3(a, b, c float64) float64 {
	return min(a, min(b, c))
}

// boundFloat ensures a float64 value is within a specific range [min, max].
func boundFloat(min, v, max float64) float64 {
	if v < min {
		return min
	}
	if v > max {
		return max
	}
	return v
}
