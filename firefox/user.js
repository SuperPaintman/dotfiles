// See: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences.
// See: resource:///defaults/preferences/firefox.js.
// See: resource://gre/greprefs.js

/* devtools */
// Default theme ("dark" or "light").
user_pref('devtools.theme', 'dark');
// Dock position ("bottom", "left", "right", "window").
user_pref('devtools.toolbox.host', 'right');

/* toolkit */
// Enable userContent.css and userChrome.css.
user_pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);
