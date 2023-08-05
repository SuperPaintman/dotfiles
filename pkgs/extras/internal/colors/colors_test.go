package colors

import "testing"

var colorsConversionTests = []struct {
	rgba       *RGBA
	hsla       *HSLA
	hexString  string
	hex8String string
}{
	{
		rgba:       NewRGB(0x00, 0x00, 0x00),
		hsla:       NewHSL(0, 0, 0),
		hexString:  "#000000",
		hex8String: "#000000ff",
	},
	{
		rgba:       NewRGB(0x00, 0x00, 0xff),
		hsla:       NewHSL(240.0/360.0, 1, 0.5),
		hexString:  "#0000ff",
		hex8String: "#0000ffff",
	},
	{
		rgba:       NewRGB(0x00, 0xff, 0x00),
		hsla:       NewHSL(120.0/360.0, 1, 0.5),
		hexString:  "#00ff00",
		hex8String: "#00ff00ff",
	},
	{
		rgba:       NewRGB(0x00, 0xff, 0xff),
		hsla:       NewHSL(180.0/360.0, 1, 0.5),
		hexString:  "#00ffff",
		hex8String: "#00ffffff",
	},
	{
		rgba:       NewRGB(0xff, 0x00, 0x00),
		hsla:       NewHSL(0, 1, 0.5),
		hexString:  "#ff0000",
		hex8String: "#ff0000ff",
	},
	{
		rgba:       NewRGB(0xff, 0x00, 0xff),
		hsla:       NewHSL(300.0/360.0, 1, 0.5),
		hexString:  "#ff00ff",
		hex8String: "#ff00ffff",
	},
	{
		rgba:       NewRGB(0xff, 0xff, 0x00),
		hsla:       NewHSL(60.0/360.0, 1, 0.5),
		hexString:  "#ffff00",
		hex8String: "#ffff00ff",
	},
	{
		rgba:       NewRGB(0xff, 0xff, 0xff),
		hsla:       NewHSL(0, 0, 1),
		hexString:  "#ffffff",
		hex8String: "#ffffffff",
	},
	{
		rgba:       NewRGBA(0xff, 0x00, 0x00, 0.2),
		hsla:       NewHSLA(0, 1, 0.5, 0.2),
		hexString:  "#ff0000",
		hex8String: "#ff000033",
	},
}

func TestRGBA_HexString(t *testing.T) {
	for _, tc := range colorsConversionTests {
		t.Run(tc.rgba.String(), func(t *testing.T) {
			got := tc.rgba.HexString()
			want := tc.hexString

			if got != want {
				t.Fatalf("RGBA.HexString() = %s, want = %s", got, want)
			}
		})
	}
}

func TestRGBA_Hex8String(t *testing.T) {
	for _, tc := range colorsConversionTests {
		t.Run(tc.rgba.String(), func(t *testing.T) {
			got := tc.rgba.Hex8String()
			want := tc.hex8String

			if got != want {
				t.Fatalf("RGBA.Hex8String() = %s, want = %s", got, want)
			}
		})
	}
}

func TestRGBA_HSL(t *testing.T) {
	for _, tc := range colorsConversionTests {
		t.Run(tc.rgba.String(), func(t *testing.T) {
			got := tc.rgba.HSL().String()
			want := tc.hsla.String()

			if got != want {
				t.Fatalf("RGBA.HSL() = %s, want = %s", got, want)
			}
		})
	}
}

func TestHSLA_RGB(t *testing.T) {
	for _, tc := range colorsConversionTests {
		t.Run(tc.rgba.String(), func(t *testing.T) {
			got := tc.hsla.RGB().String()
			want := tc.rgba.String()

			if got != want {
				t.Fatalf("HSLA.RGB() = %s, want = %s", got, want)
			}
		})
	}
}

func TestHSLA_Spin(t *testing.T) {
	tt := []struct {
		hsla   *HSLA
		amount float64
		want   *HSLA
	}{
		{
			hsla:   NewHSL(0, 1, 0.5),
			amount: 0,
			want:   NewHSL(0, 1, 0.5),
		},
		{
			hsla:   NewHSL(0, 1, 0.5),
			amount: 0.3,
			want:   NewHSL(0.3, 1, 0.5),
		},
		{
			hsla:   NewHSL(0, 1, 0.5),
			amount: -0.3,
			want:   NewHSL(0.7, 1, 0.5),
		},
		{
			hsla:   NewHSL(0.5, 1, 0.5),
			amount: 0.6,
			want:   NewHSL(0.1, 1, 0.5),
		},
	}

	for _, tc := range tt {
		t.Run(tc.hsla.String(), func(t *testing.T) {
			got := tc.hsla.Spin(tc.amount).String()
			want := tc.want.String()

			if got != want {
				t.Fatalf("HSLA.Spin(%f) = %s, want = %s", tc.amount, got, want)
			}
		})
	}
}
