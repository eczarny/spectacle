#import <Foundation/Foundation.h>

#import "SpectacleShortcutValidatorProtocol.h"

@interface SpectacleRegisteredShortcutValidator : NSObject<SpectacleShortcutValidatorProtocol>

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
