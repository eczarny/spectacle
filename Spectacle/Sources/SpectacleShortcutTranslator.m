#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslator.h"

@implementation SpectacleShortcutTranslator
{
  NSDictionary<NSString *, NSDictionary *> *_specialShortcutTranslations;
}

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

+ (NSUInteger)convertCarbonModifiersToCocoa:(NSUInteger)modifiers
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

#pragma mark -

+ (NSString *)translateCocoaModifiers:(NSUInteger)modifiers
{
  NSString *modifierGlyphs = @"";

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

- (NSString *)translateKeyCode:(NSInteger)keyCode
{
  NSDictionary<NSString *, NSString *> *keyCodeTranslations = nil;
  NSString *result;

  [self buildKeyCodeConvertorDictionary];

  keyCodeTranslations = _specialShortcutTranslations[@"ShortcutTranslations"];

  result = keyCodeTranslations[[NSString stringWithFormat:@"%d", (UInt32)keyCode]];

  if (result) {
    NSDictionary<NSString *, NSNumber *> *glyphTranslations = _specialShortcutTranslations[@"ShortcutGlyphTranslations"];
    NSNumber *translatedGlyph = glyphTranslations[result];

    if (translatedGlyph) {
      result = [NSString stringWithFormat:@"%C", (UInt16)[translatedGlyph integerValue]];
    }
  } else {
    TISInputSourceRef inputSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource();
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
  if (!_specialShortcutTranslations) {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"ShortcutTranslations" ofType:@"plist"];

    _specialShortcutTranslations = [[NSDictionary alloc] initWithContentsOfFile:path];
  }
}

@end
