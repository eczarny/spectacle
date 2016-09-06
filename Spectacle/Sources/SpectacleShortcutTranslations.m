#import "SpectacleShortcutTranslations.h"

#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

#import "SpectacleShortcut.h"

typedef NS_ENUM(unichar, SpectacleUnicodeGlyph)
{
  SpectacleUnicodeGlyphCapsLock       = 0x21EA, // ⇪
  SpectacleUnicodeGlyphClear          = 0x2327, // ⌧
  SpectacleUnicodeGlyphCommand        = 0x2318, // ⌘
  SpectacleUnicodeGlyphControl        = 0x2303, // ⌃
  SpectacleUnicodeGlyphDelete         = 0x232B, // ⌫
  SpectacleUnicodeGlyphDownArrow      = 0x2193, // ↓
  SpectacleUnicodeGlyphEnd            = 0x2198, // ↘
  SpectacleUnicodeGlyphEnter          = 0x2324, // ⌤
  SpectacleUnicodeGlyphEscape         = 0x238B, // ⎋
  SpectacleUnicodeGlyphForwardDelete  = 0x2326, // ⌦
  SpectacleUnicodeGlyphHome           = 0x2196, // ↖
  SpectacleUnicodeGlyphLeftArrow      = 0x2190, // ←
  SpectacleUnicodeGlyphOption         = 0x2325, // ⌥
  SpectacleUnicodeGlyphPageDown       = 0x21DF, // ⇟
  SpectacleUnicodeGlyphPageUp         = 0x21DE, // ⇞
  SpectacleUnicodeGlyphReturn         = 0x21A9, // ↩
  SpectacleUnicodeGlyphRightArrow     = 0x2192, // →
  SpectacleUnicodeGlyphShift          = 0x21E7, // ⇧
  SpectacleUnicodeGlyphSpace          = 0x2423, // ␣
  SpectacleUnicodeGlyphTab            = 0x21E5, // ⇥
  SpectacleUnicodeGlyphUpArrow        = 0x2191, // ↑
};

static NSDictionary<NSNumber *, NSString *> *layoutIndependentKeyCodeTranslations(void);
static NSString *glyphForUnicodeChar(unichar unicodeChar);

NSString *SpectacleTranslateKeyCode(NSInteger keyCode)
{
  NSString *translatedLayoutIndependentKeyCode = layoutIndependentKeyCodeTranslations()[@(keyCode)];
  if (translatedLayoutIndependentKeyCode) {
    return translatedLayoutIndependentKeyCode;
  }
  TISInputSourceRef inputSource = TISCopyCurrentKeyboardLayoutInputSource();
  if (!inputSource) {
    return @"?";
  }
  CFDataRef layoutData = (CFDataRef)TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData);
  CFRelease(inputSource);
  if (!layoutData) {
    inputSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource();
    if (!inputSource) {
      return @"?";
    }
    layoutData = (CFDataRef)TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData);
    CFRelease(inputSource);
    if (!layoutData) {
      return @"?";
    }
  }
  const UCKeyboardLayout *keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
  UInt32 deadKeyState = 0;
  UniCharCount maximumStringLength = 4;
  UniCharCount actualStringLength = 0;
  UniChar unicodeString[maximumStringLength];
  OSStatus err = UCKeyTranslate(keyboardLayout,
                                keyCode,
                                kUCKeyActionDisplay,
                                0,
                                LMGetKbdType(),
                                kUCKeyTranslateNoDeadKeysBit,
                                &deadKeyState,
                                maximumStringLength,
                                &actualStringLength,
                                unicodeString);
  if (err != noErr) {
    return @"?";
  }
  return [[NSString stringWithCharacters:unicodeString length:actualStringLength] uppercaseString];
}

NSString *SpectacleTranslateModifiers(NSUInteger modifiers)
{
  NSString *modifierGlyphs = @"";
  modifiers = SpectacleConvertModifiersToCocoaIfNecessary(modifiers);
  if (modifiers & NSControlKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)kControlUnicode];
  }
  if (modifiers & NSAlternateKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)kOptionUnicode];
  }
  if (modifiers & NSShiftKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)kShiftUnicode];
  }
  if (modifiers & NSCommandKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)kCommandUnicode];
  }
  return modifierGlyphs;
}

NSString *SpectacleTranslateShortcut(SpectacleShortcut *shortcut)
{
  return [NSString stringWithFormat:@"%@%@",
          SpectacleTranslateModifiers(shortcut.shortcutModifiers),
          SpectacleTranslateKeyCode(shortcut.shortcutKeyCode)];
}

NSUInteger SpectacleConvertCocoaModifiersToCarbon(NSUInteger modifiers)
{
  NSUInteger convertedModifiers = 0;
  if (modifiers & NSControlKeyMask) {
    convertedModifiers |= controlKey;
  }
  if (modifiers & NSAlternateKeyMask) {
    convertedModifiers |= optionKey;
  }
  if (modifiers & NSShiftKeyMask) {
    convertedModifiers |= shiftKey;
  }
  if (modifiers & NSCommandKeyMask) {
    convertedModifiers |= cmdKey;
  }
  return convertedModifiers;
}

NSUInteger SpectacleConvertCarbonModifiersToCocoa(NSUInteger modifiers)
{
  NSUInteger convertedModifiers = 0;
  if (modifiers & controlKey) {
    convertedModifiers |= NSControlKeyMask;
  }
  if (modifiers & optionKey) {
    convertedModifiers |= NSAlternateKeyMask;
  }
  if (modifiers & shiftKey) {
    convertedModifiers |= NSShiftKeyMask;
  }
  if (modifiers & cmdKey) {
    convertedModifiers |= NSCommandKeyMask;
  }
  return convertedModifiers;
}

NSUInteger SpectacleConvertModifiersToCarbonIfNecessary(NSUInteger modifiers)
{
  if ([SpectacleShortcut validCocoaModifiers:modifiers]) {
    modifiers = SpectacleConvertCocoaModifiersToCarbon(modifiers);
  }
  return modifiers;
}

NSUInteger SpectacleConvertModifiersToCocoaIfNecessary(NSUInteger modifiers)
{
  if (![SpectacleShortcut validCocoaModifiers:modifiers]) {
    modifiers = SpectacleConvertCarbonModifiersToCocoa(modifiers);
  }
  return modifiers;
}

static NSDictionary<NSNumber *, NSString *> *layoutIndependentKeyCodeTranslations(void)
{
  static dispatch_once_t onceToken;
  static NSDictionary<NSNumber *, NSString *> *translations;
  dispatch_once(&onceToken, ^{
    translations = @{
                     @(kVK_F1):                  @"F1",
                     @(kVK_F2):                  @"F2",
                     @(kVK_F3):                  @"F3",
                     @(kVK_F4):                  @"F4",
                     @(kVK_F5):                  @"F5",
                     @(kVK_F6):                  @"F6",
                     @(kVK_F7):                  @"F7",
                     @(kVK_F8):                  @"F8",
                     @(kVK_F9):                  @"F9",
                     @(kVK_F10):                 @"F10",
                     @(kVK_F11):                 @"F11",
                     @(kVK_F12):                 @"F12",
                     @(kVK_F13):                 @"F13",
                     @(kVK_F14):                 @"F14",
                     @(kVK_F15):                 @"F15",
                     @(kVK_F16):                 @"F16",
                     @(kVK_F17):                 @"F17",
                     @(kVK_F18):                 @"F18",
                     @(kVK_F19):                 @"F19",
                     @(kVK_F20):                 @"F20",

                     @(kVK_ANSI_KeypadDecimal):  @".",
                     @(kVK_ANSI_KeypadMultiply): @"*",
                     @(kVK_ANSI_KeypadPlus):     @"+",
                     @(kVK_ANSI_KeypadClear):    glyphForUnicodeChar(SpectacleUnicodeGlyphClear),
                     @(kVK_ANSI_KeypadDivide):   @"/",
                     @(kVK_ANSI_KeypadEnter):    glyphForUnicodeChar(SpectacleUnicodeGlyphEnter),
                     @(kVK_ANSI_KeypadMinus):    @"-",
                     @(kVK_ANSI_KeypadEquals):   @"=",
                     @(kVK_ANSI_Keypad0):        @"0",
                     @(kVK_ANSI_Keypad1):        @"1",
                     @(kVK_ANSI_Keypad2):        @"2",
                     @(kVK_ANSI_Keypad3):        @"3",
                     @(kVK_ANSI_Keypad4):        @"4",
                     @(kVK_ANSI_Keypad5):        @"5",
                     @(kVK_ANSI_Keypad6):        @"6",
                     @(kVK_ANSI_Keypad7):        @"7",
                     @(kVK_ANSI_Keypad8):        @"8",
                     @(kVK_ANSI_Keypad9):        @"9",

                     @(kVK_Return):              glyphForUnicodeChar(SpectacleUnicodeGlyphReturn),
                     @(kVK_Tab):                 glyphForUnicodeChar(SpectacleUnicodeGlyphTab),
                     @(kVK_Space):               glyphForUnicodeChar(SpectacleUnicodeGlyphSpace),
                     @(kVK_Delete):              glyphForUnicodeChar(SpectacleUnicodeGlyphDelete),
                     @(kVK_Escape):              glyphForUnicodeChar(SpectacleUnicodeGlyphEscape),
                     @(kVK_Command):             glyphForUnicodeChar(SpectacleUnicodeGlyphCommand),
                     @(kVK_Shift):               glyphForUnicodeChar(SpectacleUnicodeGlyphShift),
                     @(kVK_CapsLock):            glyphForUnicodeChar(SpectacleUnicodeGlyphCapsLock),
                     @(kVK_Option):              glyphForUnicodeChar(SpectacleUnicodeGlyphOption),
                     @(kVK_Control):             glyphForUnicodeChar(SpectacleUnicodeGlyphControl),
                     @(kVK_RightShift):          @"",
                     @(kVK_RightOption):         @"",
                     @(kVK_RightControl):        @"",
                     @(kVK_Function):            @"",
                     @(kVK_VolumeUp):            @"",
                     @(kVK_VolumeDown):          @"",
                     @(kVK_Mute):                @"",
                     @(kVK_Help):                @"",
                     @(kVK_Home):                glyphForUnicodeChar(SpectacleUnicodeGlyphHome),
                     @(kVK_PageUp):              glyphForUnicodeChar(SpectacleUnicodeGlyphPageUp),
                     @(kVK_ForwardDelete):       glyphForUnicodeChar(SpectacleUnicodeGlyphForwardDelete),
                     @(kVK_End):                 glyphForUnicodeChar(SpectacleUnicodeGlyphEnd),
                     @(kVK_PageDown):            glyphForUnicodeChar(SpectacleUnicodeGlyphPageDown),
                     @(kVK_LeftArrow):           glyphForUnicodeChar(SpectacleUnicodeGlyphLeftArrow),
                     @(kVK_RightArrow):          glyphForUnicodeChar(SpectacleUnicodeGlyphRightArrow),
                     @(kVK_DownArrow):           glyphForUnicodeChar(SpectacleUnicodeGlyphDownArrow),
                     @(kVK_UpArrow):             glyphForUnicodeChar(SpectacleUnicodeGlyphUpArrow),
                     };
  });
  return translations;
}

static NSString *glyphForUnicodeChar(unichar unicodeChar)
{
  return [NSString stringWithFormat: @"%C", unicodeChar];
}
