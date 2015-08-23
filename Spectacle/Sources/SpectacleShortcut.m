#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslator.h"

@implementation SpectacleShortcut

- (instancetype)initWithShortcutCode:(NSInteger)shortcutCode shortcutModifiers:(NSUInteger)shortcutModifiers
{
  if (self = [super init]) {
    _shortcutCode = shortcutCode;
    _shortcutModifiers = [SpectacleShortcutTranslator convertModifiersToCarbonIfNecessary:shortcutModifiers];
  }

  return self;
}

#pragma mark -

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

- (instancetype)initWithCoder:(NSCoder *)coder
{
  if (self = [super init]) {
    if ([coder allowsKeyedCoding]) {
      _shortcutName = [coder decodeObjectForKey:@"name"];
      _shortcutCode = [coder decodeIntegerForKey:@"keyCode"];
      _shortcutModifiers = [coder decodeIntegerForKey:@"modifiers"];
    } else {
      _shortcutName = [coder decodeObject];

      [coder decodeValueOfObjCType:@encode(NSInteger) at:&_shortcutCode];
      [coder decodeValueOfObjCType:@encode(NSUInteger) at:&_shortcutModifiers];
    }
  }

  return self;
}

#pragma clang diagnostic pop

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)coder
{
  if ([coder allowsKeyedCoding]) {
    [coder encodeObject:self.shortcutName forKey:@"name"];
    [coder encodeInteger:self.shortcutCode forKey:@"keyCode"];
    [coder encodeInteger:self.shortcutModifiers forKey:@"modifiers"];
  } else {
    [coder encodeObject:self.shortcutName];
    [coder encodeValueOfObjCType:@encode(NSInteger) at:&_shortcutCode];
    [coder encodeValueOfObjCType:@encode(NSUInteger) at:&_shortcutModifiers];
  }
}

#pragma mark -

- (id)replacementObjectForPortCoder:(NSPortCoder *)encoder
{
  if (encoder.isBycopy) {
    return self;
  }

  return [super replacementObjectForPortCoder:encoder];
}

#pragma mark -

+ (SpectacleShortcut *)clearedShortcut
{
  return [[SpectacleShortcut alloc] initWithShortcutCode:0 shortcutModifiers:0];
}

+ (SpectacleShortcut *)clearedShortcutWithName:(NSString *)name
{
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutCode:0 shortcutModifiers:0];

  shortcut.shortcutName = name;

  return shortcut;
}

#pragma mark -

- (void)triggerShortcutAction
{
  if (self.shortcutAction) {
    self.shortcutAction(self);
  }
}

#pragma mark -

- (BOOL)isClearedShortcut
{
  return (self.shortcutCode == 0) && (self.shortcutModifiers == 0);
}

#pragma mark -

- (NSString *)displayString
{
  return [SpectacleShortcutTranslator.sharedTranslator translateShortcut:self];
}

#pragma mark -

+ (BOOL)validCocoaModifiers:(NSUInteger)modifiers
{
  return ((modifiers & NSAlternateKeyMask)
          || (modifiers & NSCommandKeyMask)
          || (modifiers & NSControlKeyMask)
          || (modifiers & NSShiftKeyMask));
}

#pragma mark -

- (BOOL)isEqual:(id)object
{
  if (object == self) {
    return YES;
  }

  if (!object || ![object isKindOfClass:[self class]]) {
    return NO;
  }

  return [self isEqualToShortcut:object];
}

- (BOOL)isEqualToShortcut:(SpectacleShortcut *)shortcut
{
  if (shortcut == self) {
    return YES;
  }

  if (shortcut.shortcutCode != self.shortcutCode) {
    return NO;
  }

  if (shortcut.shortcutModifiers != self.shortcutModifiers) {
    return NO;
  }

  return YES;
}

@end
