#import <Foundation/Foundation.h>

@class SpectacleShortcut;

@interface SpectacleShortcutValidator : NSObject

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut error:(NSError **)error;

+ (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut withValidators:(NSArray *)validators error:(NSError **)error;

@end
