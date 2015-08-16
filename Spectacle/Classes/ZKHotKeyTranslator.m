#import "ZKHotKeyTranslator.h"

#import "SpectacleConstants.h"
#import "ZKHotKey.h"

enum {
  ZKHotKeyAlternateGlyph   = 0x2325,
  ZKHotKeyCommandGlyph   = 0x2318,
  ZKHotKeyControlGlyph   = 0x2303,
  ZKHotKeyDeleteLeftGlyph  = 0x232B,
  ZKHotKeyDeleteRightGlyph = 0x2326,
  ZKHotKeyDownArrowGlyph   = 0x2193,
  ZKHotKeyLeftArrowGlyph   = 0x2190,
  ZKHotKeyPageDownGlyph  = 0x21DF,
  ZKHotKeyPageUpGlyph    = 0x21DE,
  ZKHotKeyReturnGlyph    = 0x21A9,
  ZKHotKeyRightArrowGlyph  = 0x2192,
  ZKHotKeyShiftGlyph     = 0x21E7,
  ZKHotKeyTabLeftGlyph   = 0x21E4,
  ZKHotKeyTabRightGlyph  = 0x21E5,
  ZKHotKeyUpArrowGlyph   = 0x2191
};

enum {
  ZKHotKeyAlternateCarbonKeyMask = 1 << 11,
  ZKHotKeyCommandCarbonKeyMask   = 1 << 8,
  ZKHotKeyControlCarbonKeyMask   = 1 << 12,
  ZKHotKeyShiftCarbonKeyMask   = 1 << 9,
  ZKHotKeyFunctionCarbonKeyMask  = 1 << 17
};

@interface ZKHotKeyTranslator ()

@property (nonatomic) NSDictionary *specialHotKeyTranslations;

@end

#pragma mark -

@implementation ZKHotKeyTranslator

- (instancetype)init
{
  if ((self = [super init])) {
    _specialHotKeyTranslations = nil;
  }
  
  return self;
}

#pragma mark -

+ (ZKHotKeyTranslator *)sharedTranslator
{
  static ZKHotKeyTranslator *sharedInstance = nil;
  static dispatch_once_t predicate;
  
  dispatch_once(&predicate, ^{
    sharedInstance = [self new];
  });
  
  return sharedInstance;
}

#pragma mark -

+ (NSUInteger)convertModifiersToCarbonIfNecessary:(NSUInteger)modifiers
{
  if ([ZKHotKey validCocoaModifiers:modifiers]) {
    modifiers = [self convertCocoaModifiersToCarbon:modifiers];
  }
  
  return modifiers;
}

+ (NSUInteger)convertModifiersToCocoaIfNecessary:(NSUInteger)modifiers
{
  if (![ZKHotKey validCocoaModifiers:modifiers]) {
    modifiers = [self convertCarbonModifiersToCocoa:modifiers];
  }

  return modifiers;
}

#pragma mark -

+ (NSUInteger)convertCocoaModifiersToCarbon:(NSUInteger)modifiers
{
  NSUInteger convertedModifiers = 0;

  if (modifiers & NSControlKeyMask) {
    convertedModifiers |= ZKHotKeyControlCarbonKeyMask;
  }

  if (modifiers & NSAlternateKeyMask) {
    convertedModifiers |= ZKHotKeyAlternateCarbonKeyMask;
  }

  if (modifiers & NSShiftKeyMask) {
    convertedModifiers |= ZKHotKeyShiftCarbonKeyMask;
  }

  if (modifiers & NSCommandKeyMask) {
    convertedModifiers |= ZKHotKeyCommandCarbonKeyMask;
  }

  if (modifiers & NSFunctionKeyMask) {
    convertedModifiers |= ZKHotKeyFunctionCarbonKeyMask;
  }

  return convertedModifiers;
}

+ (NSUInteger)convertCarbonModifiersToCocoa:(NSUInteger)modifiers
{
  NSUInteger convertedModifiers = 0;

  if (modifiers & ZKHotKeyControlCarbonKeyMask) {
    convertedModifiers |= NSControlKeyMask;
  }

  if (modifiers & ZKHotKeyAlternateCarbonKeyMask) {
    convertedModifiers |= NSAlternateKeyMask;
  }

  if (modifiers & ZKHotKeyShiftCarbonKeyMask) {
    convertedModifiers |= NSShiftKeyMask;
  }

  if (modifiers & ZKHotKeyCommandCarbonKeyMask) {
    convertedModifiers |= NSCommandKeyMask;
  }

  if (modifiers & ZKHotKeyFunctionCarbonKeyMask) {
    convertedModifiers |= NSFunctionKeyMask;
  }

  return convertedModifiers;
}

#pragma mark -

+ (NSString *)translateCocoaModifiers:(NSUInteger)modifiers
{
  NSString *modifierGlyphs = @"";
  
  if (modifiers & NSControlKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)ZKHotKeyControlGlyph];
  }
  
  if (modifiers & NSAlternateKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)ZKHotKeyAlternateGlyph];
  }
  
  if (modifiers & NSShiftKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)ZKHotKeyShiftGlyph];
  }
  
  if (modifiers & NSCommandKeyMask) {
    modifierGlyphs = [modifierGlyphs stringByAppendingFormat:@"%C", (UInt16)ZKHotKeyCommandGlyph];
  }

  return modifierGlyphs;
}

- (NSString *)translateKeyCode:(NSInteger)keyCode
{
  NSDictionary *keyCodeTranslations = nil;
  NSString *result;
  
  [self buildKeyCodeConvertorDictionary];
  
  keyCodeTranslations = _specialHotKeyTranslations[SpectacleHotKeyTranslationsKey];
  
  result = keyCodeTranslations[[NSString stringWithFormat:@"%d", (UInt32)keyCode]];
  
  if (result) {
    NSDictionary *glyphTranslations = _specialHotKeyTranslations[SpectacleHotKeyGlyphTranslationsKey];
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

- (NSString *)translateHotKey:(ZKHotKey *)hotKey
{
  NSUInteger modifiers = [ZKHotKeyTranslator convertCarbonModifiersToCocoa:[hotKey hotKeyModifiers]];
  
  return [NSString stringWithFormat:@"%@%@", [ZKHotKeyTranslator translateCocoaModifiers:modifiers], [self translateKeyCode:hotKey.hotKeyCode]];
}

#pragma mark -

- (void)buildKeyCodeConvertorDictionary
{
  if (!_specialHotKeyTranslations) {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:SpectacleHotKeyTranslationsPropertyListFile
                                      ofType:SpectaclePropertyListFileExtension];
    
    _specialHotKeyTranslations = [[NSDictionary alloc] initWithContentsOfFile:path];
  }
}

@end
