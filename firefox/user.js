// See: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences.
// See: resource:///defaults/preferences/firefox.js.
// See: resource://gre/greprefs.js
// See: https://github.com/mozilla/gecko-dev

/* browser */
// Show a blank tab in a new tab.
user_pref('browser.newtabpage.enabled', false);

// Check if firefox is default browser.
user_pref('browser.shell.checkDefaultBrowser', false);

// Homepage and new windows.
user_pref('browser.startup.homepage', 'about:blank');

// Restore previous session.
user_pref('browser.startup.page', 3);

// Default search engine.
user_pref('browser.urlbar.placeholderName', 'DuckDuckGo');

/* datareporting */
// Disable health reports.
user_pref('datareporting.healthreport.uploadEnabled', false);
user_pref('datareporting.healthreport.service.enabled', false);
user_pref('datareporting.policy.dataSubmissionEnabled', false);

/* devtools */
// Default theme ("dark" or "light").
user_pref('devtools.theme', 'dark');
// Dock position ("bottom", "left", "right", "window").
user_pref('devtools.toolbox.host', 'right');

/* extensions */
// Default browser theme.
user_pref('extensions.activeThemeID', 'firefox-compact-dark@mozilla.org');

/* general */
// Use smooth scrolling.
user_pref('general.smoothScroll', true);

/* permissions */
// Block new requests asking to allow notifications.
user_pref('permissions.default.desktop-notification', 2);

// Block new requests asking to access user's location.
user_pref('permissions.default.geo', 2);

/* privacy */
// Send websites a “Do Not Track” signal that you don't want to be tracked.
user_pref('privacy.donottrackheader.enabled', false);

/* toolkit */
// Enable userContent.css and userChrome.css.
user_pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);

// Disable telemetry.
user_pref('toolkit.telemetry.enabled', false);
user_pref('toolkit.telemetry.unified', false);
user_pref('toolkit.telemetry.archive.enabled', false);
