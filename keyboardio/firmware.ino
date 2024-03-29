#include "Kaleidoscope.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-NumPad.h"
#include "Kaleidoscope-LEDEffect-BootGreeting.h"
#include "Kaleidoscope-HostPowerManagement.h"
#include "Kaleidoscope-OneShot.h"
#include "Kaleidoscope-LED-ActiveModColor.h"
#include "Kaleidoscope-LEDControl.h"
#include "Kaleidoscope-Escape-OneShot.h"
#include "Kaleidoscope-Qukeys.h"

enum { M_FN_LED, M_FN_ANY, M_FN_EQUALS,
       M_PAGEUP, M_FN_PAGEUP, M_FN_W, M_FN_B, M_TAB, M_FN_TAB, M_FN_ENTER, M_ENTER, M_FN_SEMICOLON, M_FN_APOSTROPHE,
       M_ESCAPE, M_FN_ESCAPE, M_FN_BUTTERFLY, M_BUTTERFLY, M_FN_COMMA, M_FN_PERIOD };
enum { QWERTY, NUMPAD, FUNCTION };

KEYMAPS(

  [QWERTY] = KEYMAP_STACKED
  (___,          Key_1, Key_2, Key_3, Key_4, Key_5, Key_LeftCurlyBracket,
   Key_Backtick, Key_Q, Key_W, Key_E, Key_R, Key_T, Key_LeftParen,
   M(M_PAGEUP),  Key_A, Key_S, Key_D, Key_F, Key_G,
   Key_LeftGui,  Key_Z, Key_X, Key_C, Key_V, Key_B, Key_LeftBracket,
   OSM(LeftControl), Key_Backspace, OSM(LeftShift), GUI_T(Tab),
   ShiftToLayer(FUNCTION),

   Key_RightCurlyBracket, Key_6, Key_7, Key_8,     Key_9,      Key_0,         LockLayer(NUMPAD),
   Key_RightParen,        Key_Y, Key_U, Key_I,     Key_O,      Key_P,         Key_Equals,
                          Key_H, Key_J, Key_K,     Key_L,      Key_Semicolon, Key_Quote,
   Key_RightBracket,      Key_N, Key_M, Key_Comma, Key_Period, Key_Slash,     Key_Minus,
   Key_Enter, OSM(RightShift), Key_Spacebar, OSM(RightAlt),
   ShiftToLayer(FUNCTION)),

  [NUMPAD] =  KEYMAP_STACKED
  (___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___,
   ___,

   ___, ___,         ___,         ___,         ___,         ___,                ___,
   ___, ___,         Key_Keypad7, Key_Keypad8, Key_Keypad9, Key_KeypadDot,      ___,
        Key_Keypad0, Key_Keypad4, Key_Keypad5, Key_Keypad6, Key_KeypadMultiply, Key_KeypadAdd,
   ___, ___,         Key_Keypad1, Key_Keypad2, Key_Keypad3, Key_KeypadDivide,   Key_KeypadSubtract,
   ___, ___, ___, ___,
   ___),

  [FUNCTION] =  KEYMAP_STACKED
  (___,            Key_F1,          Key_F2,     Key_F3, Key_F4, Key_F5,    M(M_FN_LED),
   ___,            ___,             M(M_FN_W),  ___,    ___,    ___,       M(M_FN_TAB),
   M(M_FN_PAGEUP), ___,             ___,        ___,    ___,    ___,
   ___,            Key_PrintScreen, Key_Insert, ___,    ___,    M(M_FN_B), M(M_FN_ESCAPE),
   ___, Key_Delete, ___, ___,
   ___,

   M(M_FN_ANY),       Key_F6,                  Key_F7,                     Key_F8,                   Key_F9,                     Key_F10,                Key_F11,
   M(M_FN_ENTER),     Consumer_PlaySlashPause, Consumer_VolumeDecrement,   Consumer_VolumeIncrement, Consumer_ScanPreviousTrack, Consumer_ScanNextTrack, M(M_FN_EQUALS),
                      Key_LeftArrow,           Key_DownArrow,              Key_UpArrow,              Key_RightArrow,             M(M_FN_SEMICOLON),      M(M_FN_APOSTROPHE),
   M(M_FN_BUTTERFLY), Consumer_Mute,           ___,                        M(M_FN_COMMA),            M(M_FN_PERIOD),             Key_Backslash,          Key_Pipe,
   ___, ___, Key_Escape, ___,
   ___)

  )

const macro_t* macroAction(uint8_t macro_id, KeyEvent &event) {
  if (keyToggledOn(event.state)) {
    switch(macro_id) {
      case M_TAB: return MACRO(D(LeftShift), T(9), U(LeftShift));
      case M_ENTER: return MACRO(D(LeftShift), T(0), U(LeftShift));
      case M_ESCAPE: return MACRO(D(LeftShift), T(LeftBracket), U(LeftShift));
      case M_BUTTERFLY: return MACRO(D(LeftShift), T(RightBracket), U(LeftShift));
      case M_PAGEUP: return MACRO(D(LeftControl), T(Backspace), U(LeftControl));
      case M_FN_PAGEUP: return MACRO(D(LeftShift), T(Home), T(Backspace), U(LeftShift));
      case M_FN_SEMICOLON: return MACRO(D(LeftShift), T(Quote), U(LeftShift), D(LeftShift), T(Quote), U(LeftShift), T(LeftArrow));
      case M_FN_APOSTROPHE: return MACRO(T(Quote), T(Quote), T(LeftArrow));
      case M_FN_EQUALS: return MACRO(T(Equals), T(Equals));
      case M_FN_COMMA: return MACRO(D(LeftShift), T(Comma), U(LeftShift), D(LeftShift), T(Period), U(LeftShift), T(LeftArrow));
      case M_FN_PERIOD: return MACRO(T(Minus), D(LeftShift), T(Period), U(LeftShift));
      case M_FN_B: return MACRO(D(LeftControl), T(LeftArrow), U(LeftControl));
      case M_FN_W: return MACRO(D(LeftControl), T(RightArrow), U(LeftControl));
      case M_FN_TAB: return MACRO(D(LeftShift), T(9), U(LeftShift), D(LeftShift), T(0), U(LeftShift), T(LeftArrow));
      case M_FN_ENTER: return MACRO(D(LeftShift), T(9), U(LeftShift), D(LeftShift), T(0), U(LeftShift));
      case M_FN_ESCAPE: return MACRO(T(LeftBracket), T(RightBracket), T(LeftArrow));
      case M_FN_BUTTERFLY: return MACRO(T(LeftBracket), T(RightBracket));
      case M_FN_LED: return MACRO(D(LeftShift), T(LeftBracket), U(LeftShift), D(LeftShift), T(RightBracket), U(LeftShift), T(LeftArrow));
      case M_FN_ANY: return MACRO(D(LeftShift), T(LeftBracket), U(LeftShift), D(LeftShift), T(RightBracket), U(LeftShift));
      default: break;
    }
  }
  return MACRO_NONE;
}

void toggleLedsOnSuspendResume(kaleidoscope::plugin::HostPowerManagement::Event event) {
  switch (event) {
  case kaleidoscope::plugin::HostPowerManagement::Suspend:
    LEDControl.disable();
    break;
  case kaleidoscope::plugin::HostPowerManagement::Resume:
    LEDControl.enable();
    break;
  case kaleidoscope::plugin::HostPowerManagement::Sleep:
    break;
  }
}

void hostPowerManagementEventHandler(kaleidoscope::HostPowerManagement::Event event) {
  toggleLedsOnSuspendResume(event);
}

KALEIDOSCOPE_INIT_PLUGINS(
  BootGreetingEffect,
  HostPowerManagement,
  LEDControl,
  LEDOff,
  NumPad,
  OneShot,
  EscapeOneShot,
  Qukeys,
  Macros,
  ActiveModColorEffect
);

void setup() {
  Kaleidoscope.setup();
  NumPad.numPadLayer = NUMPAD;
  LEDOff.activate();
}

void loop() {
  Kaleidoscope.loop();
}
