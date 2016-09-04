#import <Foundation/Foundation.h>

@class SpectacleShortcut;
@class SpectacleShortcutManager;

@protocol SpectacleShortcutValidator;

@interface SpectacleShortcutValidation : NSObject

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
                  error:(NSError **)error;

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut
        shortcutManager:(SpectacleShortcutManager *)shortcutManager
         withValidators:(NSArray<id<SpectacleShortcutValidator>> *)validators
                  error:(NSError **)error;

@end
