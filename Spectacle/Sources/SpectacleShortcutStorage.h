#import <Foundation/Foundation.h>

#import "SpectacleShortcut.h"

@protocol SpectacleShortcutStorage <NSObject>

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action;

- (NSArray<SpectacleShortcut *> *)defaultShortcutsWithAction:(SpectacleShortcutAction)action;

- (void)storeShortcuts: (NSArray<SpectacleShortcut *> *)shortcuts;

@end
