#import <Cocoa/Cocoa.h>

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
    _shortcutName = [coder decodeObjectForKey:@"name"];
    _shortcutCode = [coder decodeIntegerForKey:@"keyCode"];
    _shortcutModifiers = [coder decodeIntegerForKey:@"modifiers"];
  }
  return self;
}

#pragma clang diagnostic pop

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:_shortcutName forKey:@"name"];
  [coder encodeInteger:_shortcutCode forKey:@"keyCode"];
  [coder encodeInteger:_shortcutModifiers forKey:@"modifiers"];
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

- (SpectacleWindowAction *)windowAction
{
  NSString *name = _shortcutName;
  SpectacleWindowAction *windowAction = kSpectacleWindowActionNone;

  if ([name isEqualToString:@"MoveToCenter"]) {
    windowAction = kSpectacleWindowActionCenter;
  } else if ([name isEqualToString:@"MoveToFullscreen"]) {
    windowAction = kSpectacleWindowActionFullscreen;
  } else if ([name isEqualToString:@"MoveToLeftHalf"]) {
    windowAction = kSpectacleWindowActionLeftHalf;
  } else if ([name isEqualToString:@"MoveToRightHalf"]) {
    windowAction = kSpectacleWindowActionRightHalf;
  } else if ([name isEqualToString:@"MoveToTopHalf"]) {
    windowAction = kSpectacleWindowActionTopHalf;
  } else if ([name isEqualToString:@"MoveToBottomHalf"]) {
    windowAction = kSpectacleWindowActionBottomHalf;
  } else if ([name isEqualToString:@"MoveToUpperLeft"]) {
    windowAction = kSpectacleWindowActionUpperLeft;
  } else if ([name isEqualToString:@"MoveToLowerLeft"]) {
    windowAction = kSpectacleWindowActionLowerLeft;
  } else if ([name isEqualToString:@"MoveToUpperRight"]) {
    windowAction = kSpectacleWindowActionUpperRight;
  } else if ([name isEqualToString:@"MoveToLowerRight"]) {
    windowAction = kSpectacleWindowActionLowerRight;
  } else if ([name isEqualToString:@"MoveToNextDisplay"]) {
    windowAction = kSpectacleWindowActionNextDisplay;
  } else if ([name isEqualToString:@"MoveToPreviousDisplay"]) {
    windowAction = kSpectacleWindowActionPreviousDisplay;
  } else if ([name isEqualToString:@"MoveToNextThird"]) {
    windowAction = kSpectacleWindowActionNextThird;
  } else if ([name isEqualToString:@"MoveToPreviousThird"]) {
    windowAction = kSpectacleWindowActionPreviousThird;
  } else if ([name isEqualToString:@"MakeLarger"]) {
    windowAction = kSpectacleWindowActionLarger;
  } else if ([name isEqualToString:@"MakeSmaller"]) {
    windowAction = kSpectacleWindowActionSmaller;
  } else if ([name isEqualToString:@"UndoLastMove"]) {
    windowAction = kSpectacleWindowActionUndo;
  } else if ([name isEqualToString:@"RedoLastMove"]) {
    windowAction = kSpectacleWindowActionRedo;
  }

  return windowAction;
}

#pragma mark -

- (void)triggerShortcutAction
{
  if (_shortcutAction) {
    _shortcutAction(self);
  }
}

#pragma mark -

- (BOOL)isClearedShortcut
{
  return (_shortcutCode == 0) && (_shortcutModifiers == 0);
}

#pragma mark -

- (NSString *)displayString
{
  return [[SpectacleShortcutTranslator sharedTranslator] translateShortcut:self];
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
  if (shortcut.shortcutCode != _shortcutCode) {
    return NO;
  }
  if (shortcut.shortcutModifiers != _shortcutModifiers) {
    return NO;
  }
  return YES;
}

@end
