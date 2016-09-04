#import <Carbon/Carbon.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleShortcutKeyBindings.h"

SpecBegin(SpectacleShortcutKeyBindings)
describe(@"SpectacleShortcutKeyBindings", ^{
  it(@"should convert an empty or nil key binding to nil modifiers", ^{
    expect(SpectacleConvertShortcutKeyBindingToModifiers(nil)).to.equal(nil);
    expect(SpectacleConvertShortcutKeyBindingToModifiers(@"")).to.equal(nil);
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

  it(@"should convert an empty or nil key binding to nil key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(nil)).to.equal(nil);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"")).to.equal(nil);
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

  it(@"should convert named key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"delete")).to.equal(kVK_Delete);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"down")).to.equal(kVK_DownArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"end")).to.equal(kVK_End);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"enter")).to.equal(kVK_Return);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"escape")).to.equal(kVK_Escape);
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
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"home")).to.equal(kVK_Home);
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
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"left")).to.equal(kVK_LeftArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"pagedown")).to.equal(kVK_PageDown);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"pageup")).to.equal(kVK_PageUp);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"return")).to.equal(kVK_Return);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"right")).to.equal(kVK_RightArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"space")).to.equal(kVK_Space);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"tab")).to.equal(kVK_Tab);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"up")).to.equal(kVK_UpArrow);
  });

  it(@"should convert mixed case named key bindings to key codes", ^{
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Delete")).to.equal(kVK_Delete);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Down")).to.equal(kVK_DownArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"End")).to.equal(kVK_End);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Enter")).to.equal(kVK_Return);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Escape")).to.equal(kVK_Escape);
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
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Home")).to.equal(kVK_Home);
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
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Left")).to.equal(kVK_LeftArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"PageDown")).to.equal(kVK_PageDown);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"PageUp")).to.equal(kVK_PageUp);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Return")).to.equal(kVK_Return);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Right")).to.equal(kVK_RightArrow);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Space")).to.equal(kVK_Space);
    expect(SpectacleConvertShortcutKeyBindingToKeyCode(@"Tab")).to.equal(kVK_Tab);
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
});
SpecEnd
