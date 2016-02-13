#import <Cocoa/Cocoa.h>

@class SpectacleShortcut;
@class SpectacleShortcutManager;

@protocol SpectacleShortcutValidatorProtocol;

@interface SpectacleShortcutValidator : NSObject

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
                  error:(NSError **)error;

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
         withValidators:(NSArray<id<SpectacleShortcutValidatorProtocol>> *)validators
                  error:(NSError **)error;

@end
