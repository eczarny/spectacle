#import <Foundation/Foundation.h>

#import "SpectacleShortcut.h"

@protocol SpectacleShortcutStorageProtocol <NSObject>

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action;

- (NSArray<SpectacleShortcut *> *)defaultShortcutsWithAction:(SpectacleShortcutAction)action;

#pragma mark -

- (void)storeShortcuts: (NSArray<SpectacleShortcut *> *)shortcuts;

@end
