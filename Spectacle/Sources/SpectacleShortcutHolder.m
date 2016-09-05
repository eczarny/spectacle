#import "SpectacleShortcutHolder.h"

#import "SpectacleShortcut.h"

@implementation SpectacleShortcutHolder

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
{
  return [self initWithShortcutID:shortcutID shortcut:nil shortcutRef:nil];
}

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
                          shortcut:(SpectacleShortcut *)shortcut
{
  return [self initWithShortcutID:shortcutID shortcut:shortcut shortcutRef:nil];
}

- (instancetype)initWithShortcutID:(EventHotKeyID)shortcutID
                          shortcut:(SpectacleShortcut *)shortcut
                       shortcutRef:(EventHotKeyRef)shortcutRef
{
  if (self = [super init]) {
    _shortcutID = shortcutID;
    _shortcut = shortcut;
    _shortcutRef = shortcutRef;
  }
  return self;
}

- (instancetype)copyWithShortcut:(SpectacleShortcut *)shortcut
{
  return [[SpectacleShortcutHolder alloc] initWithShortcutID:_shortcutID
                                                    shortcut:shortcut
                                                 shortcutRef:_shortcutRef];
}

- (instancetype)copyWithShortcutRef:(EventHotKeyRef)shortcutRef
{
  return [[SpectacleShortcutHolder alloc] initWithShortcutID:_shortcutID
                                                    shortcut:_shortcut
                                                 shortcutRef:shortcutRef];
}

- (instancetype)copyWithClearedShortcut
{
  SpectacleShortcut *clearedShortcut = [[SpectacleShortcut alloc] initWithShortcutName:_shortcut.shortcutName
                                                                       shortcutKeyCode:-1
                                                                     shortcutModifiers:0];
  return [[SpectacleShortcutHolder alloc] initWithShortcutID:_shortcutID
                                                    shortcut:clearedShortcut
                                                 shortcutRef:nil];
}

@end
