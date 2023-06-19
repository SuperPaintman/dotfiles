package wtk

// Key represents a key with modifier keys.
type Key struct {
	// Leader indicates if the leader key must be pressed.
	Leader bool `json:"leader,omitempty"`
	// Meta indicates if the meta key must be pressed.
	Meta bool `json:"meta,omitempty"`
	// Ctrl indicates if the control key must be pressed.
	Ctrl bool `json:"ctrl,omitempty"`
	// Alt indicates if the alt key must be pressed.
	Alt bool `json:"alt,ommitempty"`
	// Shift indicates if the shift key must be pressed.
	// Shift bool `json:"shift,omitempty"`
	// Keys represents the actual keys must be pressed.
	Keys []string `json:"keys,omitempty"`
}

// Binding represents a key binding.
type Binding struct {
	// Keys represents the sequence of keystrokes.
	Keys []Key `json:"keys,omitempty"`
	// Description represents the description of the binding.
	Description string `json:"description,omitempty"`
}

// Group represends a group of key bindings.
type Group struct {
	// Name represents the name of the group.
	Name string `json:"name,omitempty"`
	// Bindings represents the key bindings in the group.
	Bindings []Binding `json:"bindings,omitempty"`
}

// Config represents a key bindings config.
type Config struct {
	// Groups represents the key binding groups.
	Groups []Group `json:"groups,omitempty"`
}
