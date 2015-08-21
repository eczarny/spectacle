#import <Foundation/Foundation.h>

#import "SpectacleShortcut.h"

@protocol SpectacleShortcutStorageProtocol<NSObject>

- (NSArray *)loadShortcutsWithAction:(SpectacleShortcutAction)action;

- (NSArray *)defaultShortcutsWithAction:(SpectacleShortcutAction)action;

#pragma mark -

- (void)storeShortcuts: (NSArray *)shortcuts;

@end
