#import <Cocoa/Cocoa.h>

@class SpectacleShortcut, SpectacleShortcutManager;

@interface SpectacleShortcutValidator : NSObject

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
                  error:(NSError **)error;

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
         withValidators:(NSArray *)validators
                  error:(NSError **)error;

@end
