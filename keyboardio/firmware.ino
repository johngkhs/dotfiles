#include "Kaleidoscope.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-NumPad.h"
#include "LED-Off.h"
#include "Kaleidoscope-LEDEffect-BootGreeting.h"
#include "Kaleidoscope-HostPowerManagement.h"
#include <Kaleidoscope-OneShot.h>
#include <Kaleidoscope-LED-ActiveModColor.h>
#include <Kaleidoscope-Escape-OneShot.h>

enum { M_LED, M_ANY, M_PAGEUP, M_PAGEDOWN, M_BUTTERFLY, M_APOSTROPHE, M_TAB, M_ENTER, M_ESCAPE, M_FN_A, M_FN_F, M_FN_TAB, M_FN_ENTER, M_FN_ESCAPE, M_FN_BUTTERFLY, M_FN_EQUALS, M_FN_LED, M_FN_ANY };
enum { QWERTY, NUMPAD, FUNCTION };

KEYMAPS(

  [QWERTY] = KEYMAP_STACKED
  (OSM(LeftGui),          Key_1, Key_2, Key_3, Key_4, Key_5, Key_LeftBracket,
   Key_Backtick, Key_Q, Key_W, Key_E, Key_R, Key_T, M(M_TAB),
   M(M_PAGEUP),   Key_A, Key_S, Key_D, Key_F, Key_G,
   M(M_PAGEDOWN), Key_Z, Key_X, Key_C, Key_V, Key_B, Key_LeftCurlyBracket,
   OSM(LeftControl), Key_Backspace, OSM(LeftShift), Key_Tab,
   OSL(FUNCTION),

   Key_RightBracket,  Key_6, Key_7, Key_8,     Key_9,         Key_0,         LockLayer(NUMPAD),
   M(M_ENTER),     Key_Y, Key_U, Key_I,     Key_O,         Key_P,         Key_Equals,
                  Key_H, Key_J, Key_K,     Key_L,         Key_Semicolon, Key_Quote,
   Key_RightCurlyBracket,  Key_N, Key_M, Key_Comma, Key_Period,    Key_Slash,     Key_Minus,
   Key_Escape, OSM(RightShift), Key_Spacebar, OSM(RightAlt),
   OSL(FUNCTION)),

  [NUMPAD] =  KEYMAP_STACKED
  (___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___,
   ___,

   ___,  ___, Key_Keypad7, Key_Keypad8,   Key_Keypad9,        Key_KeypadSubtract, ___,
   ___,                    ___, Key_Keypad4, Key_Keypad5,   Key_Keypad6,        Key_KeypadAdd,      ___,
                           ___, Key_Keypad1, Key_Keypad2,   Key_Keypad3,        Key_Equals,         ___,
   ___,                    ___, Key_Keypad0, Key_KeypadDot, Key_KeypadMultiply, Key_KeypadDivide,   Key_Enter,
   ___, ___, ___, ___,
   ___),

  [FUNCTION] =  KEYMAP_STACKED
  (___,      Key_F1,           Key_F2,      Key_F3,     Key_F4,        Key_F5,     M(M_FN_LED),
   ___,  ___,              ___, ___,        ___, ___, M(M_FN_TAB),
   Key_Home, M(M_FN_A),       ___, ___, M(M_FN_F), ___,
   Consumer_PlaySlashPause,  Key_PrintScreen,  Key_Insert,  ___,        ___, ___,  M(M_FN_ESCAPE),
   ___, Key_Delete, ___, ___,
   ___,

   M(M_FN_ANY), Key_F6,                 Key_F7,                   Key_F8,                   Key_F9,          Key_F10,          Key_F11,
   M(M_FN_ENTER),   Consumer_ScanNextTrack, Key_LeftCurlyBracket,     Key_RightCurlyBracket,    Key_LeftBracket, Key_RightBracket, M(M_FN_EQUALS),
                               Key_LeftArrow,          Key_DownArrow,            Key_UpArrow,              Key_RightArrow,  ___,                M(M_APOSTROPHE),
   M(M_FN_BUTTERFLY),          Consumer_Mute,          Consumer_VolumeDecrement, Consumer_VolumeIncrement, ___,             Key_Backslash,    Key_Pipe,
   ___, ___, Key_Enter, ___,
   ___)

	)

const macro_t *macroAction(uint8_t macroIndex, uint8_t keyState) {
  if (!keyIsPressed(keyState)) {
    return MACRO_NONE;
  }
  switch (macroIndex) {
    case M_LED: return MACRODOWN(T(LeftCurlyBracket));
    case M_ANY: return MACRODOWN(T(RightCurlyBracket));
    case M_TAB: return MACRODOWN(D(LeftShift), T(9), U(LeftShift));
    case M_ENTER: return MACRODOWN(D(LeftShift), T(0), U(LeftShift));
    case M_PAGEUP: return MACRODOWN(D(LeftControl), T(Backspace), U(LeftControl));
    case M_PAGEDOWN: return MACRODOWN(D(LeftShift), T(Home), T(Backspace), U(LeftShift));
    case M_BUTTERFLY: return MACRODOWN(D(LeftShift), T(Minus), U(LeftShift));
    case M_APOSTROPHE: return MACRODOWN(T(Minus), D(LeftShift), T(Period), U(LeftShift));
    case M_FN_EQUALS: return MACRODOWN(T(Equals), T(Equals));
    case M_FN_A: return MACRODOWN(D(LeftControl), T(LeftArrow), U(LeftControl));
    case M_FN_F: return MACRODOWN(D(LeftControl), T(RightArrow), U(LeftControl));
    case M_FN_TAB: return MACRODOWN(D(LeftShift), T(9), T(0), U(LeftShift), T(LeftArrow));
    case M_FN_ENTER: return MACRODOWN(D(LeftShift), T(9), T(0), U(LeftShift));
    case M_FN_ESCAPE: return MACRODOWN(T(LeftCurlyBracket), T(RightCurlyBracket), T(LeftArrow));
    case M_FN_BUTTERFLY: return MACRODOWN(T(Escape), T(O), T(LeftCurlyBracket), T(Enter), T(RightCurlyBracket), T(Escape), T(UpArrow), D(LeftShift), T(A), U(LeftShift), T(Enter));
    case M_FN_LED: return MACRODOWN(T(LeftBracket), T(RightBracket), T(LeftArrow));
    case M_FN_ANY: return MACRODOWN(T(LeftBracket), T(RightBracket));
  }
  return MACRO_NONE;
}

void toggleLedsOnSuspendResume(kaleidoscope::HostPowerManagement::Event event) {
  switch (event) {
  case kaleidoscope::HostPowerManagement::Suspend:
    LEDControl.paused = true;
    LEDControl.set_all_leds_to({0, 0, 0});
    LEDControl.syncLeds();
    break;
  case kaleidoscope::HostPowerManagement::Resume:
    LEDControl.paused = false;
    LEDControl.refreshAll();
    break;
  case kaleidoscope::HostPowerManagement::Sleep:
    break;
  }
}

void hostPowerManagementEventHandler(kaleidoscope::HostPowerManagement::Event event) {
  toggleLedsOnSuspendResume(event);
}

void setup() {
  Kaleidoscope.setup();
  Kaleidoscope.use(
    &BootGreetingEffect,
    &LEDOff,
    &NumPad,
    &OneShot,
    &EscapeOneShot,
    &ActiveModColorEffect,
    &Macros,
    &HostPowerManagement
  );
  NumPad.numPadLayer = NUMPAD;
  HostPowerManagement.enableWakeup();
  LEDOff.activate();
}

void loop() {
  Kaleidoscope.loop();
}
