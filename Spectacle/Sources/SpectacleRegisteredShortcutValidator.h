#import <Foundation/Foundation.h>

#import "SpectacleShortcutValidatorProtocol.h"

@class SpectacleShortcut;

@interface SpectacleRegisteredShortcutValidator : NSObject<SpectacleShortcutValidatorProtocol>

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut;

@end
