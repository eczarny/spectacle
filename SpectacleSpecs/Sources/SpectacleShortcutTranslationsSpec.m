#import <Carbon/Carbon.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslations.h"

static SpectacleShortcut *shortcutForKeyBinding(NSString *keyBinding);

SpecBegin(SpectacleShortcutTranslations)
describe(@"SpectacleShortcutTranslations", ^{
  it(@"should translate alphanumeric key codes", ^{
    expect(SpectacleTranslateKeyCode(kVK_ANSI_A, 0)).to.equal(@"A");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_B, 0)).to.equal(@"B");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_C, 0)).to.equal(@"C");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_D, 0)).to.equal(@"D");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_E, 0)).to.equal(@"E");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_F, 0)).to.equal(@"F");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_G, 0)).to.equal(@"G");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_H, 0)).to.equal(@"H");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_I, 0)).to.equal(@"I");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_J, 0)).to.equal(@"J");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_K, 0)).to.equal(@"K");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_L, 0)).to.equal(@"L");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_M, 0)).to.equal(@"M");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_N, 0)).to.equal(@"N");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_O, 0)).to.equal(@"O");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_P, 0)).to.equal(@"P");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Q, 0)).to.equal(@"Q");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_R, 0)).to.equal(@"R");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_S, 0)).to.equal(@"S");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_T, 0)).to.equal(@"T");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_U, 0)).to.equal(@"U");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_V, 0)).to.equal(@"V");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_W, 0)).to.equal(@"W");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_X, 0)).to.equal(@"X");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Y, 0)).to.equal(@"Y");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_Z, 0)).to.equal(@"Z");

    expect(SpectacleTranslateKeyCode(kVK_ANSI_0, 0)).to.equal(@"0");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_1, 0)).to.equal(@"1");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_2, 0)).to.equal(@"2");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_3, 0)).to.equal(@"3");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_4, 0)).to.equal(@"4");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_5, 0)).to.equal(@"5");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_6, 0)).to.equal(@"6");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_7, 0)).to.equal(@"7");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_8, 0)).to.equal(@"8");
    expect(SpectacleTranslateKeyCode(kVK_ANSI_9, 0)).to.equal(@"9");
  });

  it(@"should translate special key codes", ^{
    expect(SpectacleTranslateKeyCode(kVK_F1, 0)).to.equal(@"F1");
    expect(SpectacleTranslateKeyCode(kVK_F2, 0)).to.equal(@"F2");
    expect(SpectacleTranslateKeyCode(kVK_F3, 0)).to.equal(@"F3");
    expect(SpectacleTranslateKeyCode(kVK_F4, 0)).to.equal(@"F4");
    expect(SpectacleTranslateKeyCode(kVK_F5, 0)).to.equal(@"F5");
    expect(SpectacleTranslateKeyCode(kVK_F6, 0)).to.equal(@"F6");
    expect(SpectacleTranslateKeyCode(kVK_F7, 0)).to.equal(@"F7");
    expect(SpectacleTranslateKeyCode(kVK_F8, 0)).to.equal(@"F8");
    expect(SpectacleTranslateKeyCode(kVK_F9, 0)).to.equal(@"F9");
    expect(SpectacleTranslateKeyCode(kVK_F10, 0)).to.equal(@"F10");
    expect(SpectacleTranslateKeyCode(kVK_F11, 0)).to.equal(@"F11");
    expect(SpectacleTranslateKeyCode(kVK_F12, 0)).to.equal(@"F12");
    expect(SpectacleTranslateKeyCode(kVK_F13, 0)).to.equal(@"F13");
    expect(SpectacleTranslateKeyCode(kVK_F14, 0)).to.equal(@"F14");
    expect(SpectacleTranslateKeyCode(kVK_F15, 0)).to.equal(@"F15");
    expect(SpectacleTranslateKeyCode(kVK_F16, 0)).to.equal(@"F16");
    expect(SpectacleTranslateKeyCode(kVK_F17, 0)).to.equal(@"F17");
    expect(SpectacleTranslateKeyCode(kVK_F18, 0)).to.equal(@"F18");
    expect(SpectacleTranslateKeyCode(kVK_F19, 0)).to.equal(@"F19");
    expect(SpectacleTranslateKeyCode(kVK_F20, 0)).to.equal(@"F20");

    expect(SpectacleTranslateKeyCode(kVK_Delete, 0)).to.equal(@"⌫");
    expect(SpectacleTranslateKeyCode(kVK_DownArrow, 0)).to.equal(@"↓");
    expect(SpectacleTranslateKeyCode(kVK_End, 0)).to.equal(@"↘");
    expect(SpectacleTranslateKeyCode(kVK_Escape, 0)).to.equal(@"␛");
    expect(SpectacleTranslateKeyCode(kVK_ForwardDelete, 0)).to.equal(@"⌦");
    expect(SpectacleTranslateKeyCode(kVK_Home, 0)).to.equal(@"↖");
    expect(SpectacleTranslateKeyCode(kVK_LeftArrow, 0)).to.equal(@"←");
    expect(SpectacleTranslateKeyCode(kVK_PageDown, 0)).to.equal(@"⇟");
    expect(SpectacleTranslateKeyCode(kVK_PageUp, 0)).to.equal(@"⇞");
    expect(SpectacleTranslateKeyCode(kVK_Return, 0)).to.equal(@"↩");
    expect(SpectacleTranslateKeyCode(kVK_RightArrow, 0)).to.equal(@"→");
    expect(SpectacleTranslateKeyCode(kVK_Space, 0)).to.equal(@" ");
    expect(SpectacleTranslateKeyCode(kVK_Tab, 0)).to.equal(@"⇥");
    expect(SpectacleTranslateKeyCode(kVK_UpArrow, 0)).to.equal(@"↑");
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
