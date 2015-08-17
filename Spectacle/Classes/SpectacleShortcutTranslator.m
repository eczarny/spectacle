#import "SpectacleShortcutTranslator.h"

#import "SpectacleConstants.h"
#import "SpectacleShortcut.h"

enum {
  SpectacleShortcutAlternateGlyph = 0x2325,
  SpectacleShortcutCommandGlyph = 0x2318,
  SpectacleShortcutControlGlyph = 0x2303,
  SpectacleShortcutDeleteLeftGlyph = 0x232B,
  SpectacleShortcutDeleteRightGlyph = 0x2326,
  SpectacleShortcutDownArrowGlyph = 0x2193,
  SpectacleShortcutLeftArrowGlyph = 0x2190,
  SpectacleShortcutPageDownGlyph = 0x21DF,
  SpectacleShortcutPageUpGlyph = 0x21DE,
  SpectacleShortcutReturnGlyph = 0x21A9,
  SpectacleShortcutRightArrowGlyph = 0x2192,
  SpectacleShortcutShiftGlyph = 0x21E7,
  SpectacleShortcutTabLeftGlyph = 0x21E4,
  SpectacleShortcutTabRightGlyph = 0x21E5,
  SpectacleShortcutUpArrowGlyph = 0x2191
};

enum {
  SpectacleShortcutAlternateCarbonKeyMask = 1 << 11,
  SpectacleShortcutCommandCarbonKeyMask = 1 << 8,
  SpectacleShortcutControlCarbonKeyMask = 1 << 12,
  SpectacleShortcutShiftCarbonKeyMask = 1 << 9,
  SpectacleShortcutFunctionCarbonKeyMask = 1 << 17
};

@interface SpectacleShortcutTranslator ()

@property (nonatomic) NSDictionary *specialShortcutTranslations;

@end

#pragma mark -

@implementation SpectacleShortcutTranslator

+ (SpectacleShortcutTranslator *)sharedTranslator
{
  static SpectacleShortcutTranslator *sharedInstance = nil;
  static dispatch_once_t predicate;

  dispatch_once(&predicate, ^{
    sharedInstance = [self new];
  });

  return sharedInstance;
}

#pragma mark -

+ (NSUInteger)convertModifiersToCarbonIfNecessary:(NSUInteger)modifiers
{
  if ([SpectacleShortcut validCocoaModifiers:modifiers]) {
    modifiers = [self convertCocoaModifiersToCarbon:modifiers];
  }

  return modifiers;
}

+ (NSUInteger)convertModifiersToCocoaIfNecessary:(NSUInteger)modifiers
{
  if (![SpectacleShortcut validCocoaModifiers:modifiers]) {
    modifiers = [self convertCarbonModifiersToCocoa:modifiers];
  }

  return modifiers;
}

#pragma mark -

+ (NSUInteger)convertCocoaModifiersToCarbon:(NSUInteger)modifiers
{
  NSUInteger convertedModifiers = 0;

  if (modifiers & NSControlKeyMask) {
    convertedModifiers |= SpectacleShortcutControlCarbonKeyMask;
  }

  if (modifiers & NSAlternateKeyMask) {
    convertedModifiers |= SpectacleShortcutAlternateCarbonKeyMask;
  }

  if (modifiers & NSShiftKeyMask) {
    convertedModifiers |= SpectacleShortcutShiftCarbonKeyMask;
  }

  if (modifiers & NSCommandKeyMask) {
    convertedModifiers |= SpectacleShortcutCommandCarbonKeyMask;
  }

  if (modifiers & NSFunctionKeyMask) {
    convertedModifiers |= SpectacleShortcutFunctionCarbonKeyMask;
  }

  return convertedModifiers;
}

+ (NSUInteger)convertCarbonModifiersToCocoa:(NSUInteger)modifiers
{
  NSUInteger convertedModifiers = 0;

  if (modifiers & SpectacleShortcutControlCarbonKeyMask) {
    convertedModifiers |= NSControlKeyMask;
  }

  if (modifiers & SpectacleShortcutAlternateCarbonKeyMask) {
    convertedModifiers |= NSAlternateKeyMask;
  }

  if (modifiers & SpectacleShortcutShiftCarbonKeyMask) {
    convertedModifiers |= NSShiftKeyMask;
  }

  if (modifiers & SpectacleShortcutCommandCarbonKeyMask) {
    convertedModifiers |= NSCommandKeyMask;
  }

  if (modifiers & SpectacleShortcutFunctionCarbonKeyMask) {
    convertedModifiers |= NSFunctionKeyMask;
  }

  return convertedModifiers;
}

#pragma mark -

+ (NSString *)translateCocoaModifiers:(NSUInteger)modifiers
{
  NSString *modifierGlyphs = @"";

  if (modifiers & NSControlKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)SpectacleShortcutControlGlyph];
  }

  if (modifiers & NSAlternateKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)SpectacleShortcutAlternateGlyph];
  }

  if (modifiers & NSShiftKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)SpectacleShortcutShiftGlyph];
  }

  if (modifiers & NSCommandKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)SpectacleShortcutCommandGlyph];
  }

  return modifierGlyphs;
}

- (NSString *)translateKeyCode:(NSInteger)keyCode
{
  NSDictionary *keyCodeTranslations = nil;
  NSString *result;

  [self buildKeyCodeConvertorDictionary];

  keyCodeTranslations = self.specialShortcutTranslations[SpectacleShortcutTranslationsKey];

  result = keyCodeTranslations[[NSString stringWithFormat:@"%d", (UInt32)keyCode]];

  if (result) {
    NSDictionary *glyphTranslations = self.specialShortcutTranslations[SpectacleShortcutGlyphTranslationsKey];
    id translatedGlyph = glyphTranslations[result];

    if (translatedGlyph) {
      result = [NSString stringWithFormat:@"%C", (UInt16)[translatedGlyph integerValue]];
    }
  } else {
    TISInputSourceRef inputSource = TISCopyCurrentKeyboardInputSource();
    CFDataRef layoutData = (CFDataRef)TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData);
    const UCKeyboardLayout *keyboardLayout = nil;
    UInt32 keysDown = 0;
    UniCharCount length = 4;
    UniCharCount actualLength = 0;
    UniChar chars[4];

    if (inputSource != NULL) {
      CFRelease(inputSource);
    }

    if (layoutData == NULL) {
      NSLog(@"Unable to determine keyboard layout.");

      return @"?";
    }

    keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);

    OSStatus err = UCKeyTranslate(keyboardLayout,
                                  keyCode,
                                  kUCKeyActionDisplay,
                                  0,
                                  LMGetKbdType(),
                                  kUCKeyTranslateNoDeadKeysBit,
                                  &keysDown,
                                  length,
                                  &actualLength,
                                  chars);

    if (err) {
      NSLog(@"There was a problem translating the key code.");

      return @"?";
    }

    result = [[NSString stringWithCharacters:chars length:1] uppercaseString];
  }

  return result;
}

#pragma mark -

- (NSString *)translateShortcut:(SpectacleShortcut *)shortcut
{
  NSUInteger modifiers = [SpectacleShortcutTranslator convertCarbonModifiersToCocoa:[shortcut shortcutModifiers]];

  return [NSString stringWithFormat:@"%@%@", [SpectacleShortcutTranslator translateCocoaModifiers:modifiers], [self translateKeyCode:shortcut.shortcutCode]];
}

#pragma mark -

- (void)buildKeyCodeConvertorDictionary
{
  if (!self.specialShortcutTranslations) {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:SpectacleShortcutTranslationsPropertyListFile
                                      ofType:SpectaclePropertyListFileExtension];

    self.specialShortcutTranslations = [[NSDictionary alloc] initWithContentsOfFile:path];
  }
}

@end
