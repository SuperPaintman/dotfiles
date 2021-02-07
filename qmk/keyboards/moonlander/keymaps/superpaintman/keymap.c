/* Copyright 2020 ZSA Technology Labs, Inc <@zsa>
 * Copyright 2020 Jack Humbert <jack.humb@gmail.com>
 * Copyright 2020 Christopher Courtney <drashna@live.com> (@drashna)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include QMK_KEYBOARD_H
#include "version.h"

#define KC_MAC_UNDO LGUI(KC_Z)
#define KC_MAC_CUT LGUI(KC_X)
#define KC_MAC_COPY LGUI(KC_C)
#define KC_MAC_PASTE LGUI(KC_V)
#define KC_PC_UNDO LCTL(KC_Z)
#define KC_PC_CUT LCTL(KC_X)
#define KC_PC_COPY LCTL(KC_C)
#define KC_PC_PASTE LCTL(KC_V)
#define ES_LESS_MAC KC_GRAVE
#define ES_GRTR_MAC LSFT(KC_GRAVE)
#define ES_BSLS_MAC ALGR(KC_6)
#define NO_PIPE_ALT KC_GRAVE
#define NO_BSLS_ALT KC_EQUAL
#define LSA_T(kc) MT(MOD_LSFT | MOD_LALT, kc)
#define KC_TGL_LANG LALT(LGUI(KC_SPACE))
#define BP_NDSH_MAC ALGR(KC_8)
#define MOON_LED_LEVEL LED_LEVEL

// clang-format off
#define LEDMAP_moonlander(                                                     \
    k00, k01, k02, k03, k04, k05, k06,   k60, k61, k62, k63, k64, k65, k66,    \
    k10, k11, k12, k13, k14, k15, k16,   k70, k71, k72, k73, k74, k75, k76,    \
    k20, k21, k22, k23, k24, k25, k26,   k80, k81, k82, k83, k84, k85, k86,    \
    k30, k31, k32, k33, k34, k35,             k91, k92, k93, k94, k95, k96,    \
    k40, k41, k42, k43, k44,      k53,   kb3,      ka2, ka3, ka4, ka5, ka6,    \
                        k50, k51, k52,   kb4, kb5, kb6                         \
)                                                                              \
  {k00, k10, k20, k30, k40,                                                    \
   k01, k11, k21, k31, k41,                                                    \
   k02, k12, k22, k32, k42,                                                    \
   k03, k13, k23, k33, k43,                                                    \
   k04, k14, k24, k34, k44,                                                    \
   k05, k15, k25, k35,                                                         \
   k06, k16, k26,                                                              \
   k50,                                                                        \
   k51,                                                                        \
   k52,                                                                        \
   k53,                                                                        \
                                                                               \
   k66, k76, k86, k96, ka6,                                                    \
   k65, k75, k85, k95, ka5,                                                    \
   k64, k74, k84, k94, ka4,                                                    \
   k63, k73, k83, k93, ka3,                                                    \
   k62, k72, k82, k92, ka2,                                                    \
   k61, k71, k81, k91,                                                         \
   k60, k70, k80,                                                              \
   kb6,                                                                        \
   kb5,                                                                        \
   kb4,                                                                        \
   kb3}
// clang-format on

#define CLR_XXXXXX                                                             \
  { 0, 0, 0 }
#define CLR_BLACK                                                              \
  { 0, 0, 0 }
#define CLR_YELLOW                                                             \
  { 32, 255, 234 }
#define CLR_ORANGE                                                             \
  { 12, 225, 241 }
#define CLR_RED                                                                \
  { 0, 204, 255 }
#define CLR_PURPLE                                                             \
  { 169, 120, 255 }
#define CLR_BLUE                                                               \
  { 146, 224, 255 }

enum layouts {
  _LAYOUTS_BEGINNING = -1,
  BASE,          // default layout.
  GAMING,        // gaming.
  GAMING_NUMPAD, // gaming NumPad.
  SYMBOLS,       // symbols.
  NUMPAD,        // NumPad.
  MOUSE,         // mouse.
  MEDIA,         // media.
  FUNCTIONAL,    // functional.
  EMOJI,         // emoji.
  CLICKY,        // clicky layout just to do clicky-clacky.
  _LAYOUTS_END,
};

enum custom_keycodes {
  _CUSTOM_KEYCODES_BEGINNING = ML_SAFE_RANGE - 1,
  _CUSTOM_KEYCODES_EMOJI_BEGINNING = _CUSTOM_KEYCODES_BEGINNING,
  EMOJI_HEART, // ❤.
  EMOJI_UP,    // 👍.
  EMOJI_DOWN,  // 👎.
  EMOJI_MARK,  // ✅.
  EMOJI_BEAR,  // 🐻
  _CUSTOM_KEYCODES_EMOJI_END,
  _CUSTOM_KEYCODES_END = _CUSTOM_KEYCODES_EMOJI_END,
};

struct emoji_t {
  const char *shortcode;
};

const struct emoji_t emojis[] = {
    [EMOJI_HEART] = {.shortcode = ":heart:"},
    [EMOJI_UP] = {.shortcode = ":thumbsup:"},
    [EMOJI_DOWN] = {.shortcode = ":thumbsdown:"},
    [EMOJI_MARK] = {.shortcode = ":white_check_mark:"},
    [EMOJI_BEAR] = {.shortcode = ":bear:"},
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [BASE] = LAYOUT_moonlander(
    MO(FUNCTIONAL), KC_1,           KC_2,           KC_3,           KC_4,           KC_5,           MO(MOUSE),        /**/   TO(CLICKY),     KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           XXXXXXX,
    KC_TAB,         KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,           _______,          /**/   _______,        KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_BSLASH,
    KC_ESCAPE,      KC_A,           KC_S,           KC_D,           KC_F,           KC_G,           _______,          /**/   _______,        KC_H,           KC_J,           KC_K,           KC_L,           KC_SCOLON,      KC_QUOTE,
    KC_LSHIFT,      KC_Z,           KC_X,           KC_C,           KC_V,           KC_B,                             /**/                   KC_N,           KC_M,           KC_COMMA,       KC_DOT,         KC_SLASH,       KC_RSHIFT,
    KC_LCTRL,       MO(SYMBOLS),    KC_TGL_LANG,    KC_LALT,        MO(NUMPAD),                     MO(EMOJI),        /**/   TO(GAMING),                     KC_LEFT,        KC_DOWN,        KC_UP,          KC_RIGHT,       MO(MEDIA),
                                                                    KC_SPACE,       KC_LGUI,        KC_LALT,          /**/   KC_DELETE,      KC_BSPACE,      KC_ENTER
  ),

  [GAMING] = LAYOUT_moonlander(
    _______,        KC_1,           KC_2,           KC_3,           KC_4,           KC_5,           KC_6,             /**/   _______,        _______,        _______,        _______,        _______,        _______,        TO(BASE),
    _______,        _______,        _______,        _______,        _______,        _______,        KC_Y,             /**/   _______,        _______,        _______,        _______,        _______,        _______,        _______,
    _______,        _______,        _______,        _______,        _______,        _______,        KC_H,             /**/   _______,        _______,        _______,        _______,        _______,        _______,        _______,
    _______,        _______,        _______,        _______,        _______,        _______,                          /**/                   _______,        _______,        _______,        _______,        _______,        _______,
    _______,        XXXXXXX,        MO(GAMING_NUMPAD),KC_LALT,      KC_SPACE,                       KC_I,             /**/   _______,                        _______,        _______,        _______,        _______,        _______,
                                                                    _______,        KC_ENTER,       KC_M,             /**/   KC_TGL_LANG,    _______,        _______
  ),

  [GAMING_NUMPAD] = LAYOUT_moonlander(
    XXXXXXX,        KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,          XXXXXXX,          /**/   _______,        _______,        _______,        _______,        _______,        _______,        _______,
    _______,        KC_KP_7,        KC_KP_8,        KC_KP_9,        KC_7,           KC_0,           XXXXXXX,          /**/   _______,        _______,        _______,        _______,        _______,        _______,        _______,
    _______,        KC_KP_4,        KC_KP_5,        KC_KP_6,        KC_8,           KC_MINUS,       XXXXXXX,          /**/   _______,        _______,        _______,        _______,        _______,        _______,        _______,
    _______,        KC_KP_1,        KC_KP_2,        KC_KP_3,        KC_9,           KC_EQUAL,                         /**/                   _______,        _______,        _______,        _______,        _______,        _______,
    _______,        KC_KP_0,        _______,        KC_LALT,        KC_SPACE,                       KC_NUMLOCK,       /**/   XXXXXXX,                        _______,        _______,        _______,        _______,        _______,
                                                                    _______,        KC_ENTER,       XXXXXXX,          /**/   KC_TGL_LANG,    _______,        _______
  ),

  [SYMBOLS] = LAYOUT_moonlander(
    _______,        _______,        _______,        _______,        _______,        _______,        _______,          /**/   _______,        _______,        _______,        _______,        _______,        _______,        _______,
    _______,        _______,        _______,        _______,        _______,        _______,        _______,          /**/   _______,        _______,        KC_ASTR,        KC_LPRN,        KC_RPRN,        KC_AMPR,        _______,
    _______,        _______,        KC_EXLM,        KC_AT,          KC_HASH,        KC_DLR,         _______,          /**/   _______,        _______,        KC_PLUS,        KC_LCBR,        KC_RCBR,        KC_EQUAL,       _______,
    _______,        _______,        KC_TILD,        KC_GRAVE,       KC_PERC,        KC_CIRC,                          /**/                   _______,        KC_MINUS,       KC_LBRACKET,    KC_RBRACKET,    KC_UNDS,        _______,
    _______,        _______,        _______,        _______,        _______,                        _______,          /**/   _______,                        _______,        _______,        _______,        _______,        _______,
                                                                    _______,        _______,        _______,          /**/   _______,        _______,        _______
  ),

  [NUMPAD] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_NUMLOCK,     KC_TRANSPARENT, KC_KP_SLASH,    KC_KP_ASTERISK, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_KP_7,        KC_KP_8,        KC_KP_9,        KC_KP_MINUS,    KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_KP_0,        KC_KP_4,        KC_KP_5,        KC_KP_6,        KC_KP_PLUS,     KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_KP_1,        KC_KP_2,        KC_KP_3,        KC_KP_ENTER,    KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_KP_0,        KC_TRANSPARENT, KC_KP_DOT,      KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),

  [MOUSE] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_MS_WH_UP,    KC_MS_WH_DOWN,  KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_MS_LEFT,     KC_MS_DOWN,     KC_MS_UP,       KC_MS_RIGHT,    KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_MS_BTN3,     KC_MS_BTN1,     KC_MS_BTN2
  ),

  [MEDIA] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, RESET,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_UP,KC_BRIGHTNESS_UP,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_DOWN,KC_BRIGHTNESS_DOWN,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_AUDIO_MUTE,  KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),

  [FUNCTIONAL] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,          KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_F6,          KC_F7,          KC_F8,          KC_F9,          KC_F10,         KC_F11,
    KC_TRANSPARENT, KC_BRIGHTNESS_DOWN,KC_BRIGHTNESS_UP,KC_AUDIO_VOL_DOWN,KC_AUDIO_VOL_UP,KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_F12,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),

  [EMOJI] = LAYOUT_moonlander(
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        EMOJI_UP,       XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        EMOJI_HEART,    EMOJI_MARK,     XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,                        /**/                   XXXXXXX,        EMOJI_DOWN,     XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,                        _______,        /**/   EMOJI_BEAR,                     XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
                                                                    _______,        _______,        _______,        /**/   _______,        _______,        _______
  ),

  [CLICKY] = LAYOUT_moonlander(
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        TO(BASE),
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,                        /**/                   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
    XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,                        XXXXXXX,        /**/   XXXXXXX,                        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
                                                                    XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX
  ),

  // Template.
  //
  // [NAME] = LAYOUT_moonlander(
  //   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
  //   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
  //   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
  //   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,                        /**/                   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
  //   XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,                        XXXXXXX,        /**/   XXXXXXX,                        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,        XXXXXXX,
  //                                                                   XXXXXXX,        XXXXXXX,        XXXXXXX,        /**/   XXXXXXX,        XXXXXXX,        XXXXXXX
  // ),
};
// clang-format on

extern bool g_suspend_state;
extern rgb_config_t rgb_matrix_config;

void keyboard_post_init_user(void) { rgb_matrix_enable(); }

// clang-format off
const uint8_t PROGMEM ledmap[][DRIVER_LED_TOTAL][3] = {
  [BASE] = LEDMAP_moonlander(
    CLR_RED,      CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_RED,      /**/   CLR_RED,      CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_XXXXXX,
    CLR_ORANGE,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,
    CLR_ORANGE,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,
    CLR_PURPLE,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,                 /**/                 CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_YELLOW,   CLR_PURPLE,
    CLR_PURPLE,   CLR_RED,      CLR_BLUE,     CLR_PURPLE,   CLR_RED,                    CLR_RED,      /**/   CLR_RED,                    CLR_ORANGE,   CLR_ORANGE,   CLR_ORANGE,   CLR_ORANGE,   CLR_RED,
                                                            CLR_ORANGE,   CLR_PURPLE,   CLR_PURPLE,   /**/   CLR_ORANGE,   CLR_ORANGE,   CLR_ORANGE
  ),

  [GAMING] = { CLR_RED, CLR_PURPLE, CLR_PURPLE, CLR_PURPLE, CLR_PURPLE, CLR_BLUE, CLR_YELLOW, CLR_RED, CLR_YELLOW, CLR_BLACK, CLR_BLUE, CLR_RED, CLR_RED, CLR_YELLOW, CLR_RED, CLR_BLUE, CLR_YELLOW, CLR_RED, CLR_YELLOW, CLR_PURPLE, CLR_BLUE, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_ORANGE, CLR_BLUE, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_BLUE, CLR_YELLOW, CLR_YELLOW, CLR_ORANGE, CLR_ORANGE, CLR_YELLOW, CLR_YELLOW, CLR_RED, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK },

  [GAMING_NUMPAD] = { CLR_BLACK, CLR_PURPLE, CLR_PURPLE, CLR_PURPLE, CLR_PURPLE, CLR_ORANGE, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_ORANGE, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_BLUE, CLR_ORANGE, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_PURPLE, CLR_ORANGE, CLR_BLUE, CLR_BLUE, CLR_BLUE, CLR_ORANGE, CLR_ORANGE, CLR_BLUE, CLR_BLUE, CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_ORANGE, CLR_ORANGE, CLR_BLACK, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK },

  [SYMBOLS] = { CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_PURPLE, CLR_BLUE, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_ORANGE, CLR_RED, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_ORANGE, CLR_RED, CLR_BLACK, CLR_BLACK, CLR_PURPLE, CLR_BLUE, CLR_PURPLE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK },

  [NUMPAD] = { CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_RED, CLR_ORANGE, CLR_ORANGE, CLR_RED, CLR_BLACK, CLR_RED, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_RED, CLR_BLACK, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_BLACK, CLR_PURPLE, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK },

  [MOUSE] = { CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_RED, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_RED, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_ORANGE, CLR_ORANGE, CLR_ORANGE, CLR_BLACK },

  [MEDIA] = { CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_RED, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_ORANGE, CLR_ORANGE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_YELLOW, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK },

  [FUNCTIONAL] = { CLR_BLUE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_RED, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_RED, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_ORANGE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_ORANGE, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_YELLOW, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK, CLR_BLACK },

  [EMOJI] = LEDMAP_moonlander(
    CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
    CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_YELLOW,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
    CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_RED,      CLR_BLUE,     CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
    CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,                 /**/                 CLR_XXXXXX,   CLR_YELLOW,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
    CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,                 CLR_BLUE,     /**/   CLR_PURPLE,                 CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
                                                            CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX
  ),

  [CLICKY] = { {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {180,255,233}, {205,255,255}, {233,218,217}, {14,222,242}, {14,222,242}, {14,222,242}, {255,220,201}, CLR_RED, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {14,222,242}, {180,255,233}, {205,255,255}, {233,218,217}, {255,220,201}, {180,255,233}, {205,255,255}, {233,218,217}, {14,222,242}, {14,222,242}, {14,222,242}, {255,220,201} },

  // Template.
  //
  // [NAME] = LEDMAP_moonlander(
  //   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
  //   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
  //   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
  //   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,                 /**/                 CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
  //   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,                 CLR_XXXXXX,   /**/   CLR_XXXXXX,                 CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,
  //                                                           CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX,   /**/   CLR_XXXXXX,   CLR_XXXXXX,   CLR_XXXXXX
  // ),
};
// clang-format on

void set_layer_color(int layer) {
  for (int i = 0; i < DRIVER_LED_TOTAL; i++) {
    HSV hsv = {
        .h = pgm_read_byte(&ledmap[layer][i][0]),
        .s = pgm_read_byte(&ledmap[layer][i][1]),
        .v = pgm_read_byte(&ledmap[layer][i][2]),
    };

    if (!hsv.h && !hsv.s && !hsv.v) {
      rgb_matrix_set_color(i, 0, 0, 0);
      continue;
    }

    RGB rgb = hsv_to_rgb(hsv);
    float f = (float)rgb_matrix_config.hsv.v / UINT8_MAX;
    rgb_matrix_set_color(i, f * rgb.r, f * rgb.g, f * rgb.b);
  }
}

void rgb_matrix_indicators_user(void) {
  if (g_suspend_state || keyboard_config.disable_layer_led) {
    return;
  }

  const uint8_t layout = biton32(layer_state);
  if (layout > _LAYOUTS_BEGINNING && layout < _LAYOUTS_END) {
    set_layer_color(layout);
    return;
  }

  if (rgb_matrix_get_flags() == LED_FLAG_NONE) {
    rgb_matrix_set_color_all(0, 0, 0);
  }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  if (record->event.pressed) {
    if (keycode > _CUSTOM_KEYCODES_EMOJI_BEGINNING &&
        keycode < _CUSTOM_KEYCODES_EMOJI_END) {
      SEND_STRING(emojis[keycode].shortcode);
      return false;
    }
  }

  return true;
}
