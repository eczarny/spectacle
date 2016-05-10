#import <Cocoa/Cocoa.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutTranslator.h"

@implementation SpectacleShortcut

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                        shortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers
{
  return [self initWithShortcutName:shortcutName
                       shortcutCode:shortcutCode
                  shortcutModifiers:shortcutModifiers
                     shortcutAction:nil];
}

- (instancetype)initWithShortcutName:(NSString *)shortcutName
                        shortcutCode:(NSInteger)shortcutCode
                   shortcutModifiers:(NSUInteger)shortcutModifiers
                      shortcutAction:(SpectacleShortcutAction)shortcutAction
{
  if (self = [super init]) {
    _shortcutName = shortcutName;
    _shortcutCode = shortcutCode;
    _shortcutModifiers = [SpectacleShortcutTranslator convertModifiersToCarbonIfNecessary:shortcutModifiers];
    _shortcutAction = shortcutAction;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  return [self initWithShortcutName:[coder decodeObjectForKey:@"name"]
                       shortcutCode:[coder decodeIntegerForKey:@"keyCode"]
                  shortcutModifiers:[coder decodeIntegerForKey:@"modifiers"]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:_shortcutName forKey:@"name"];
  [coder encodeInteger:_shortcutCode forKey:@"keyCode"];
  [coder encodeInteger:_shortcutModifiers forKey:@"modifiers"];
}

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
  } else if ([name isEqualToString:@"MoveToUpperThirdRight"]) {
      windowAction = kSpectacleWindowActionUpperThirdRight;
  } else if ([name isEqualToString:@"MoveToMiddleThirdRight"]) {
      windowAction = kSpectacleWindowActionMiddleThirdRight;
  } else if ([name isEqualToString:@"MoveToLowerThirdRight"]) {
      windowAction = kSpectacleWindowActionLowerThirdRight;
  } else if ([name isEqualToString:@"MoveToUpperThirdLeft"]) {
      windowAction = kSpectacleWindowActionUpperThirdLeft;
  } else if ([name isEqualToString:@"MoveToMiddleThirdLeft"]) {
      windowAction = kSpectacleWindowActionMiddleThirdLeft;
  } else if ([name isEqualToString:@"MoveToLowerThirdLeft"]) {
      windowAction = kSpectacleWindowActionLowerThirdLeft;
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

- (instancetype)copyWithShortcutAction:(SpectacleShortcutAction)shortcutAction
{
  return [[SpectacleShortcut alloc] initWithShortcutName:_shortcutName
                                            shortcutCode:_shortcutCode
                                       shortcutModifiers:_shortcutModifiers
                                          shortcutAction:shortcutAction];
}

- (void)triggerShortcutAction
{
  if (_shortcutAction) {
    _shortcutAction(self);
  }
}

- (BOOL)isClearedShortcut
{
  return (_shortcutCode == 0) && (_shortcutModifiers == 0);
}

- (NSString *)displayString
{
  return [[SpectacleShortcutTranslator sharedTranslator] translateShortcut:self];
}

+ (BOOL)validCocoaModifiers:(NSUInteger)modifiers
{
  return ((modifiers & NSAlternateKeyMask)
          || (modifiers & NSCommandKeyMask)
          || (modifiers & NSControlKeyMask)
          || (modifiers & NSShiftKeyMask));
}

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
