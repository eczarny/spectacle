#import <Carbon/Carbon.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslations.h"

static SpectacleShortcut *shortcutForKeyBinding(NSString *keyBinding);

SpecBegin(SpectacleShortcutTranslations)
describe(@"SpectacleShortcutTranslations", ^{
  it(@"should translate alphanumeric key codes", ^{
    expect(SpectacleTranslateKeyCode(kVK_ANSI_A)).to.equal(@"A");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_B)).to.equal(@"B");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_C)).to.equal(@"C");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_D)).to.equal(@"D");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_E)).to.equal(@"E");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_F)).to.equal(@"F");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_G)).to.equal(@"G");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_H)).to.equal(@"H");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_I)).to.equal(@"I");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_J)).to.equal(@"J");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_K)).to.equal(@"K");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_L)).to.equal(@"L");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_M)).to.equal(@"M");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_N)).to.equal(@"N");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_O)).to.equal(@"O");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_P)).to.equal(@"P");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Q)).to.equal(@"Q");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_R)).to.equal(@"R");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_S)).to.equal(@"S");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_T)).to.equal(@"T");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_U)).to.equal(@"U");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_V)).to.equal(@"V");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_W)).to.equal(@"W");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_X)).to.equal(@"X");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Y)).to.equal(@"Y");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Z)).to.equal(@"Z");

    expect(SpectacleTranslateKeyCode(kVK_ANSI_0)).to.equal(@"0");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_1)).to.equal(@"1");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_2)).to.equal(@"2");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_3)).to.equal(@"3");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_4)).to.equal(@"4");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_5)).to.equal(@"5");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_6)).to.equal(@"6");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_7)).to.equal(@"7");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_8)).to.equal(@"8");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_9)).to.equal(@"9");
  });

  it(@"should translate keyboard layout independent key codes", ^{
    expect(SpectacleTranslateKeyCode(kVK_F1)).to.equal(@"F1");
    expect(SpectacleTranslateKeyCode(kVK_F2)).to.equal(@"F2");
    expect(SpectacleTranslateKeyCode(kVK_F3)).to.equal(@"F3");
    expect(SpectacleTranslateKeyCode(kVK_F4)).to.equal(@"F4");
    expect(SpectacleTranslateKeyCode(kVK_F5)).to.equal(@"F5");
    expect(SpectacleTranslateKeyCode(kVK_F6)).to.equal(@"F6");
    expect(SpectacleTranslateKeyCode(kVK_F7)).to.equal(@"F7");
    expect(SpectacleTranslateKeyCode(kVK_F8)).to.equal(@"F8");
    expect(SpectacleTranslateKeyCode(kVK_F9)).to.equal(@"F9");
    expect(SpectacleTranslateKeyCode(kVK_F10)).to.equal(@"F10");
    expect(SpectacleTranslateKeyCode(kVK_F11)).to.equal(@"F11");
    expect(SpectacleTranslateKeyCode(kVK_F12)).to.equal(@"F12");
    expect(SpectacleTranslateKeyCode(kVK_F13)).to.equal(@"F13");
    expect(SpectacleTranslateKeyCode(kVK_F14)).to.equal(@"F14");
    expect(SpectacleTranslateKeyCode(kVK_F15)).to.equal(@"F15");
    expect(SpectacleTranslateKeyCode(kVK_F16)).to.equal(@"F16");
    expect(SpectacleTranslateKeyCode(kVK_F17)).to.equal(@"F17");
    expect(SpectacleTranslateKeyCode(kVK_F18)).to.equal(@"F18");
    expect(SpectacleTranslateKeyCode(kVK_F19)).to.equal(@"F19");
    expect(SpectacleTranslateKeyCode(kVK_F20)).to.equal(@"F20");

    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadDecimal)).to.equal(@".");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadMultiply)).to.equal(@"*");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadPlus)).to.equal(@"+");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadClear)).to.equal(@"⌧");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadDivide)).to.equal(@"/");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadEnter)).to.equal(@"⌤");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadMinus)).to.equal(@"-");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_KeypadEquals)).to.equal(@"=");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad0)).to.equal(@"0");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad1)).to.equal(@"1");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad2)).to.equal(@"2");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad3)).to.equal(@"3");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad4)).to.equal(@"4");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad5)).to.equal(@"5");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad6)).to.equal(@"6");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad7)).to.equal(@"7");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad8)).to.equal(@"8");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Keypad9)).to.equal(@"9");

    expect(SpectacleTranslateKeyCode(kVK_Return)).to.equal(@"↩");
    expect(SpectacleTranslateKeyCode(kVK_Tab)).to.equal(@"⇥");
    expect(SpectacleTranslateKeyCode(kVK_Space)).to.equal(@"␣");
    expect(SpectacleTranslateKeyCode(kVK_Delete)).to.equal(@"⌫");
    expect(SpectacleTranslateKeyCode(kVK_Escape)).to.equal(@"⎋");
    expect(SpectacleTranslateKeyCode(kVK_Command)).to.equal(@"⌘");
    expect(SpectacleTranslateKeyCode(kVK_Shift)).to.equal(@"⇧");
    expect(SpectacleTranslateKeyCode(kVK_CapsLock)).to.equal(@"⇪");
    expect(SpectacleTranslateKeyCode(kVK_Option)).to.equal(@"⌥");
    expect(SpectacleTranslateKeyCode(kVK_Control)).to.equal(@"⌃");
    expect(SpectacleTranslateKeyCode(kVK_RightShift)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_RightOption)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_RightControl)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_Function)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_VolumeUp)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_VolumeDown)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_Mute)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_Help)).to.equal(@"");
    expect(SpectacleTranslateKeyCode(kVK_Home)).to.equal(@"↖");
    expect(SpectacleTranslateKeyCode(kVK_PageUp)).to.equal(@"⇞");
    expect(SpectacleTranslateKeyCode(kVK_ForwardDelete)).to.equal(@"⌦");
    expect(SpectacleTranslateKeyCode(kVK_End)).to.equal(@"↘");
    expect(SpectacleTranslateKeyCode(kVK_PageDown)).to.equal(@"⇟");
    expect(SpectacleTranslateKeyCode(kVK_LeftArrow)).to.equal(@"←");
    expect(SpectacleTranslateKeyCode(kVK_RightArrow)).to.equal(@"→");
    expect(SpectacleTranslateKeyCode(kVK_DownArrow)).to.equal(@"↓");
    expect(SpectacleTranslateKeyCode(kVK_UpArrow)).to.equal(@"↑");
  });

  it(@"should translate empty modifiers", ^{
    expect(SpectacleTranslateModifiers(0)).to.equal(@"");
  });

  it(@"should translate modifiers", ^{
    expect(SpectacleTranslateModifiers(NSControlKeyMask)).to.equal(@"⌃");
    expect(SpectacleTranslateModifiers(NSAlternateKeyMask)).to.equal(@"⌥");
    expect(SpectacleTranslateModifiers(NSShiftKeyMask)).to.equal(@"⇧");
    expect(SpectacleTranslateModifiers(NSCommandKeyMask)).to.equal(@"⌘");

  });

  it(@"should translate shortcuts", ^{
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+c"))).to.equal(@"⌥⌘C");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+f"))).to.equal(@"⌥⌘F");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+left"))).to.equal(@"⌥⌘←");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+right"))).to.equal(@"⌥⌘→");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+up"))).to.equal(@"⌥⌘↑");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+down"))).to.equal(@"⌥⌘↓");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+command+left"))).to.equal(@"⌃⌘←");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+shift+command+left"))).to.equal(@"⌃⇧⌘←");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+command+right"))).to.equal(@"⌃⌘→");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+shift+command+right"))).to.equal(@"⌃⇧⌘→");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+option+command+right"))).to.equal(@"⌃⌥⌘→");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+option+command+left"))).to.equal(@"⌃⌥⌘←");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+option+right"))).to.equal(@"⌃⌥→");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+option+left"))).to.equal(@"⌃⌥←");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+option+shift+right"))).to.equal(@"⌃⌥⇧→");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"control+option+shift+left"))).to.equal(@"⌃⌥⇧←");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+command+z"))).to.equal(@"⌥⌘Z");
    expect(SpectacleTranslateShortcut(shortcutForKeyBinding(@"option+shift+command+z"))).to.equal(@"⌥⇧⌘Z");
  });

  it(@"should convert empty modifiers", ^{
    expect(SpectacleConvertCocoaModifiersToCarbon(0)).to.equal(0);
    expect(SpectacleConvertCarbonModifiersToCocoa(0)).to.equal(0);
  });

  it(@"should convert invalid modifiers", ^{
    expect(SpectacleConvertCocoaModifiersToCarbon(42)).to.equal(0);
    expect(SpectacleConvertCarbonModifiersToCocoa(42)).to.equal(0);
  });

  it(@"should convert Cocoa modifiers to Carbon modifiers", ^{
    expect(SpectacleConvertCocoaModifiersToCarbon(NSControlKeyMask)).to.equal(controlKey);
    expect(SpectacleConvertCocoaModifiersToCarbon(NSAlternateKeyMask)).to.equal(optionKey);
    expect(SpectacleConvertCocoaModifiersToCarbon(NSShiftKeyMask)).to.equal(shiftKey);
    expect(SpectacleConvertCocoaModifiersToCarbon(NSCommandKeyMask)).to.equal(cmdKey);
  });

  it(@"should convert Carbon modifiers to Cocoa modifiers", ^{
    expect(SpectacleConvertCarbonModifiersToCocoa(controlKey)).to.equal(NSControlKeyMask);
    expect(SpectacleConvertCarbonModifiersToCocoa(optionKey)).to.equal(NSAlternateKeyMask);
    expect(SpectacleConvertCarbonModifiersToCocoa(shiftKey)).to.equal(NSShiftKeyMask);
    expect(SpectacleConvertCarbonModifiersToCocoa(cmdKey)).to.equal(NSCommandKeyMask);
  });

  it(@"should convert modifiers to Carbon modifiers if necessary", ^{
    expect(SpectacleConvertModifiersToCarbonIfNecessary(controlKey)).to.equal(controlKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(optionKey)).to.equal(optionKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(shiftKey)).to.equal(shiftKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(cmdKey)).to.equal(cmdKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(NSControlKeyMask)).to.equal(controlKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(NSAlternateKeyMask)).to.equal(optionKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(NSShiftKeyMask)).to.equal(shiftKey);
    expect(SpectacleConvertModifiersToCarbonIfNecessary(NSCommandKeyMask)).to.equal(cmdKey);
  });

  it(@"should convert modifiers to Cocoa modifiers if necessary", ^{
    expect(SpectacleConvertModifiersToCocoaIfNecessary(NSControlKeyMask)).to.equal(NSControlKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(NSAlternateKeyMask)).to.equal(NSAlternateKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(NSShiftKeyMask)).to.equal(NSShiftKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(NSCommandKeyMask)).to.equal(NSCommandKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(controlKey)).to.equal(NSControlKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(optionKey)).to.equal(NSAlternateKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(shiftKey)).to.equal(NSShiftKeyMask);
    expect(SpectacleConvertModifiersToCocoaIfNecessary(cmdKey)).to.equal(NSCommandKeyMask);
  });
});
SpecEnd

static SpectacleShortcut *shortcutForKeyBinding(NSString *keyBinding)
{
  return [[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:keyBinding];
}
