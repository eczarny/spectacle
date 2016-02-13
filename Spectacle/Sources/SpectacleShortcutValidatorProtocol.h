#import <Foundation/Foundation.h>

@class SpectacleShortcut;
@class SpectacleShortcutManager;

@protocol SpectacleShortcutValidatorProtocol <NSObject>

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
