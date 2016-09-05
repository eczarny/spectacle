#import <Carbon/Carbon.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutKeyBindings.h"

static SpectacleShortcut *shortcutForKeyBinding(NSString *keyBinding);

SpecBegin(SpectacleShortcutKeyBindings)
describe(@"SpectacleShortcutKeyBindings", ^{
  it(@"should convert an empty or nil key binding to nil modifiers", ^{
    expect(SpectacleConvertShortcutKeyBindingToModifiers(nil)).to.equal(nil);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"")).to.equal(nil);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@" ")).to.equal(nil);
  });

  it(@"should convert key bindings to modifiers", ^{
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"cmd+c")).to.equal(cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"shift+cmd+c")).to.equal(shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"alt+shift+cmd+c")).to.equal(optionKey | shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"ctrl+alt+shift+cmd+c")).to.equal(controlKey | optionKey | shiftKey | cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"command+c")).to.equal(cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"shift+command+c")).to.equal(shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"option+shift+command+c")).to.equal(optionKey | shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"control+option+shift+command+c")).to.equal(controlKey | optionKey | shiftKey | cmdKey);
  });

  it(@"should convert mixed case key bindings to modifiers", ^{
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"Cmd+C")).to.equal(cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"Shift+Cmd+C")).to.equal(shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"Alt+Shift+Cmd+C")).to.equal(optionKey | shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"Ctrl+Alt+Shift+Cmd+C")).to.equal(controlKey | optionKey | shiftKey | cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"COMMAND+C")).to.equal(cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"SHIFT+COMMAND+C")).to.equal(shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"OPTION+SHIFT+COMMAND+C")).to.equal(optionKey | shiftKey |cmdKey);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"CONTROL+OPTION+SHIFT+COMMAND+C")).to.equal(controlKey | optionKey | shiftKey | cmdKey);
  });

  it(@"should convert key bindings with whitespace to modifiers", ^{
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@" alt  +   shift    +     cmd    +c")).to.equal(optionKey | shiftKey |cmdKey);
  });

  it(@"should convert an empty or nil key binding to nil key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(nil)).to.equal(nil);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"")).to.equal(nil);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@" ")).to.equal(nil);
  });

  it(@"should convert lowercase alphabetical key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"a")).to.equal(kVK_ANSI_A);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"b")).to.equal(kVK_ANSI_B);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"c")).to.equal(kVK_ANSI_C);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"d")).to.equal(kVK_ANSI_D);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"e")).to.equal(kVK_ANSI_E);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f")).to.equal(kVK_ANSI_F);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"g")).to.equal(kVK_ANSI_G);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"h")).to.equal(kVK_ANSI_H);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"i")).to.equal(kVK_ANSI_I);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"j")).to.equal(kVK_ANSI_J);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"k")).to.equal(kVK_ANSI_K);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"l")).to.equal(kVK_ANSI_L);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"m")).to.equal(kVK_ANSI_M);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"n")).to.equal(kVK_ANSI_N);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"o")).to.equal(kVK_ANSI_O);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"p")).to.equal(kVK_ANSI_P);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"q")).to.equal(kVK_ANSI_Q);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"r")).to.equal(kVK_ANSI_R);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"s")).to.equal(kVK_ANSI_S);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"t")).to.equal(kVK_ANSI_T);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"u")).to.equal(kVK_ANSI_U);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"v")).to.equal(kVK_ANSI_V);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"w")).to.equal(kVK_ANSI_W);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"x")).to.equal(kVK_ANSI_X);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"y")).to.equal(kVK_ANSI_Y);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"z")).to.equal(kVK_ANSI_Z);
  });

  it(@"should convert uppercase alphabetical key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"A")).to.equal(kVK_ANSI_A);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"B")).to.equal(kVK_ANSI_B);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"C")).to.equal(kVK_ANSI_C);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"D")).to.equal(kVK_ANSI_D);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"E")).to.equal(kVK_ANSI_E);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F")).to.equal(kVK_ANSI_F);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"G")).to.equal(kVK_ANSI_G);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"H")).to.equal(kVK_ANSI_H);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"I")).to.equal(kVK_ANSI_I);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"J")).to.equal(kVK_ANSI_J);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"K")).to.equal(kVK_ANSI_K);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"L")).to.equal(kVK_ANSI_L);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"M")).to.equal(kVK_ANSI_M);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"N")).to.equal(kVK_ANSI_N);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"O")).to.equal(kVK_ANSI_O);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"P")).to.equal(kVK_ANSI_P);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Q")).to.equal(kVK_ANSI_Q);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"R")).to.equal(kVK_ANSI_R);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"S")).to.equal(kVK_ANSI_S);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"T")).to.equal(kVK_ANSI_T);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"U")).to.equal(kVK_ANSI_U);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"V")).to.equal(kVK_ANSI_V);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"W")).to.equal(kVK_ANSI_W);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"X")).to.equal(kVK_ANSI_X);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Y")).to.equal(kVK_ANSI_Y);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Z")).to.equal(kVK_ANSI_Z);
  });

  it(@"should convert numeric key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"0")).to.equal(kVK_ANSI_0);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"1")).to.equal(kVK_ANSI_1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"2")).to.equal(kVK_ANSI_2);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"3")).to.equal(kVK_ANSI_3);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"4")).to.equal(kVK_ANSI_4);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"5")).to.equal(kVK_ANSI_5);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"6")).to.equal(kVK_ANSI_6);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"7")).to.equal(kVK_ANSI_7);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"8")).to.equal(kVK_ANSI_8);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"9")).to.equal(kVK_ANSI_9);
  });

  it(@"should convert alphabetical key bindings with modifiers to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"cmd+a")).to.equal(kVK_ANSI_A);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift+cmd+b")).to.equal(kVK_ANSI_B);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"alt+shift+cmd+c")).to.equal(kVK_ANSI_C);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"ctrl+alt+shift+cmd+d")).to.equal(kVK_ANSI_D);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"command+e")).to.equal(kVK_ANSI_E);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift+command+f")).to.equal(kVK_ANSI_F);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"option+shift+command+g")).to.equal(kVK_ANSI_G);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"control+option+shift+command+h")).to.equal(kVK_ANSI_H);
  });

  it(@"should convert alphanumeric key bindings with whitespace to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@" cmd  +   a    ")).to.equal(kVK_ANSI_A);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@" shift  +   cmd    +     0      ")).to.equal(kVK_ANSI_0);
  });

  it(@"should convert named key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f1")).to.equal(kVK_F1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f2")).to.equal(kVK_F2);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f3")).to.equal(kVK_F3);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f4")).to.equal(kVK_F4);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f5")).to.equal(kVK_F5);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f6")).to.equal(kVK_F6);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f7")).to.equal(kVK_F7);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f8")).to.equal(kVK_F8);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f9")).to.equal(kVK_F9);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f10")).to.equal(kVK_F10);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f11")).to.equal(kVK_F11);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f12")).to.equal(kVK_F12);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f13")).to.equal(kVK_F13);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f14")).to.equal(kVK_F14);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f15")).to.equal(kVK_F15);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f16")).to.equal(kVK_F16);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f17")).to.equal(kVK_F17);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f18")).to.equal(kVK_F18);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f19")).to.equal(kVK_F19);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"f20")).to.equal(kVK_F20);

    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypaddecimal")).to.equal(kVK_ANSI_KeypadDecimal);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypadmultiply")).to.equal(kVK_ANSI_KeypadMultiply);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypadplus")).to.equal(kVK_ANSI_KeypadPlus);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypadclear")).to.equal(kVK_ANSI_KeypadClear);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypaddivide")).to.equal(kVK_ANSI_KeypadDivide);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypadenter")).to.equal(kVK_ANSI_KeypadEnter);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypadminus")).to.equal(kVK_ANSI_KeypadMinus);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypadequals")).to.equal(kVK_ANSI_KeypadEquals);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad0")).to.equal(kVK_ANSI_Keypad0);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad1")).to.equal(kVK_ANSI_Keypad1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad2")).to.equal(kVK_ANSI_Keypad2);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad3")).to.equal(kVK_ANSI_Keypad3);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad4")).to.equal(kVK_ANSI_Keypad4);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad5")).to.equal(kVK_ANSI_Keypad5);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad6")).to.equal(kVK_ANSI_Keypad6);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad7")).to.equal(kVK_ANSI_Keypad7);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad8")).to.equal(kVK_ANSI_Keypad8);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"keypad9")).to.equal(kVK_ANSI_Keypad9);

    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"return")).to.equal(kVK_Return);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"tab")).to.equal(kVK_Tab);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"space")).to.equal(kVK_Space);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"delete")).to.equal(kVK_Delete);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"escape")).to.equal(kVK_Escape);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"command")).to.equal(kVK_Command);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift")).to.equal(kVK_Shift);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"capslock")).to.equal(kVK_CapsLock);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"option")).to.equal(kVK_Option);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"control")).to.equal(kVK_Control);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"rightshift")).to.equal(kVK_RightShift);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"rightoption")).to.equal(kVK_RightOption);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"rightcontrol")).to.equal(kVK_RightControl);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"function")).to.equal(kVK_Function);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"volumeup")).to.equal(kVK_VolumeUp);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"volumedown")).to.equal(kVK_VolumeDown);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"mute")).to.equal(kVK_Mute);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"help")).to.equal(kVK_Help);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"home")).to.equal(kVK_Home);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"pageup")).to.equal(kVK_PageUp);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"forwarddelete")).to.equal(kVK_ForwardDelete);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"end")).to.equal(kVK_End);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"pagedown")).to.equal(kVK_PageDown);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"left")).to.equal(kVK_LeftArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"right")).to.equal(kVK_RightArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"down")).to.equal(kVK_DownArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"up")).to.equal(kVK_UpArrow);
  });

  it(@"should convert mixed case named key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F1")).to.equal(kVK_F1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F2")).to.equal(kVK_F2);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F3")).to.equal(kVK_F3);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F4")).to.equal(kVK_F4);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F5")).to.equal(kVK_F5);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F6")).to.equal(kVK_F6);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F7")).to.equal(kVK_F7);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F8")).to.equal(kVK_F8);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F9")).to.equal(kVK_F9);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F10")).to.equal(kVK_F10);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F11")).to.equal(kVK_F11);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F12")).to.equal(kVK_F12);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F13")).to.equal(kVK_F13);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F14")).to.equal(kVK_F14);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F15")).to.equal(kVK_F15);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F16")).to.equal(kVK_F16);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F17")).to.equal(kVK_F17);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F18")).to.equal(kVK_F18);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F19")).to.equal(kVK_F19);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"F20")).to.equal(kVK_F20);

    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadDecimal")).to.equal(kVK_ANSI_KeypadDecimal);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadMultiply")).to.equal(kVK_ANSI_KeypadMultiply);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadPlus")).to.equal(kVK_ANSI_KeypadPlus);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadClear")).to.equal(kVK_ANSI_KeypadClear);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadDivide")).to.equal(kVK_ANSI_KeypadDivide);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadEnter")).to.equal(kVK_ANSI_KeypadEnter);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadMinus")).to.equal(kVK_ANSI_KeypadMinus);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"KeypadEquals")).to.equal(kVK_ANSI_KeypadEquals);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad0")).to.equal(kVK_ANSI_Keypad0);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad1")).to.equal(kVK_ANSI_Keypad1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad2")).to.equal(kVK_ANSI_Keypad2);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad3")).to.equal(kVK_ANSI_Keypad3);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad4")).to.equal(kVK_ANSI_Keypad4);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad5")).to.equal(kVK_ANSI_Keypad5);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad6")).to.equal(kVK_ANSI_Keypad6);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad7")).to.equal(kVK_ANSI_Keypad7);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad8")).to.equal(kVK_ANSI_Keypad8);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Keypad9")).to.equal(kVK_ANSI_Keypad9);

    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Return")).to.equal(kVK_Return);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Tab")).to.equal(kVK_Tab);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Space")).to.equal(kVK_Space);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Delete")).to.equal(kVK_Delete);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Escape")).to.equal(kVK_Escape);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Command")).to.equal(kVK_Command);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Shift")).to.equal(kVK_Shift);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"CapsLock")).to.equal(kVK_CapsLock);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Option")).to.equal(kVK_Option);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Control")).to.equal(kVK_Control);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"RightShift")).to.equal(kVK_RightShift);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"RightOption")).to.equal(kVK_RightOption);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"RightControl")).to.equal(kVK_RightControl);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Function")).to.equal(kVK_Function);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"VolumeUp")).to.equal(kVK_VolumeUp);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"VolumeDown")).to.equal(kVK_VolumeDown);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Mute")).to.equal(kVK_Mute);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Help")).to.equal(kVK_Help);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Home")).to.equal(kVK_Home);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"PageUp")).to.equal(kVK_PageUp);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"ForwardDelete")).to.equal(kVK_ForwardDelete);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"End")).to.equal(kVK_End);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"PageDown")).to.equal(kVK_PageDown);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Left")).to.equal(kVK_LeftArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Right")).to.equal(kVK_RightArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Down")).to.equal(kVK_DownArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Up")).to.equal(kVK_UpArrow);
  });

  it(@"should convert named key bindings with modifiers to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"cmd+up")).to.equal(kVK_UpArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift+cmd+down")).to.equal(kVK_DownArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"alt+shift+cmd+left")).to.equal(kVK_LeftArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"ctrl+alt+shift+cmd+right")).to.equal(kVK_RightArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"command+space")).to.equal(kVK_Space);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift+command+f1")).to.equal(kVK_F1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"option+shift+command+keypad0")).to.equal(kVK_ANSI_Keypad0);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"control+option+shift+command+escape")).to.equal(kVK_Escape);
  });

  it(@"should convert mixed case named key bindings with modifiers to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"cmd+Up")).to.equal(kVK_UpArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift+cmd+Down")).to.equal(kVK_DownArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"alt+shift+cmd+left")).to.equal(kVK_LeftArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"ctrl+alt+shift+cmd+Right")).to.equal(kVK_RightArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"command+SPACE")).to.equal(kVK_Space);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"shift+command+F1")).to.equal(kVK_F1);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"option+shift+command+KEYPAD0")).to.equal(kVK_ANSI_Keypad0);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"control+option+shift+command+ESCAPE")).to.equal(kVK_Escape);
  });

  it(@"should convert empty shortcuts to nil key bindings", ^{
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(nil))).to.equal(nil);
  });

  it(@"should convert shortcuts to key bindings", ^{
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+c"))).to.equal(@"alt+cmd+c");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+f"))).to.equal(@"alt+cmd+f");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+left"))).to.equal(@"alt+cmd+left");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+right"))).to.equal(@"alt+cmd+right");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+up"))).to.equal(@"alt+cmd+up");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+down"))).to.equal(@"alt+cmd+down");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+cmd+left"))).to.equal(@"ctrl+cmd+left");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+shift+cmd+left"))).to.equal(@"ctrl+shift+cmd+left");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+cmd+right"))).to.equal(@"ctrl+cmd+right");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+shift+cmd+right"))).to.equal(@"ctrl+shift+cmd+right");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+alt+cmd+right"))).to.equal(@"ctrl+alt+cmd+right");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+alt+cmd+left"))).to.equal(@"ctrl+alt+cmd+left");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+alt+right"))).to.equal(@"ctrl+alt+right");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+alt+left"))).to.equal(@"ctrl+alt+left");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+alt+shift+right"))).to.equal(@"ctrl+alt+shift+right");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"ctrl+alt+shift+left"))).to.equal(@"ctrl+alt+shift+left");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+cmd+z"))).to.equal(@"alt+cmd+z");
    expect(SpectacleConvertShortcutToKeyBinding(shortcutForKeyBinding(@"alt+shift+cmd+z"))).to.equal(@"alt+shift+cmd+z");
  });
});
SpecEnd

static SpectacleShortcut *shortcutForKeyBinding(NSString *keyBinding)
{
  return [[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:keyBinding];
}
