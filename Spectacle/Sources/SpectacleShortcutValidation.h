#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@class SpectacleShortcut;
@class SpectacleShortcutManager;

@protocol SpectacleShortcutValidator;

@interface SpectacleShortcutValidation : NSObject

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                             validators:(NSArray<id<SpectacleShortcutValidator>> *)validators NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut error:(NSError **)error;

@end
