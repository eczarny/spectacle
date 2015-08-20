#import <Foundation/Foundation.h>

@class SpectacleShortcut;

@protocol SpectacleShortcutValidatorProtocol<NSObject>

- (BOOL)isShortcutValid:(SpectacleShortcut *)shortcut;

@end
