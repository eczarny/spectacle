#import <Foundation/Foundation.h>

@class SpectacleShortcut, SpectacleShortcutManager;

@protocol SpectacleShortcutValidatorProtocol<NSObject>

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
