#import <Foundation/Foundation.h>

@class SpectacleShortcut;
@class SpectacleShortcutManager;

@protocol SpectacleShortcutValidator <NSObject>

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
