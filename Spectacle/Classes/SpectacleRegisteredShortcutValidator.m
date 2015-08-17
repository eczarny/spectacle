#import "SpectacleRegisteredShortcutValidator.h"

#import "SpectacleShortcutManager.h"

@implementation SpectacleRegisteredShortcutValidator

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
{
  return ![SpectacleShortcutManager.sharedManager isShortcutRegistered:shortcut];
}

@end
