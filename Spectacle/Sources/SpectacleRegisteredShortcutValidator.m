#import "SpectacleRegisteredShortcutValidator.h"

#import "SpectacleShortcutManager.h"

@implementation SpectacleRegisteredShortcutValidator

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut shortcutManager:(SpectacleShortcutManager *)shortcutManager
{
  return ![shortcutManager doesShortcutExist:shortcut];
}

@end
