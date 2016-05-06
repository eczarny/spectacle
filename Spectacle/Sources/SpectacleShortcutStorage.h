#import <Foundation/Foundation.h>

#import "SpectacleShortcut.h"

@protocol SpectacleShortcutStorage <NSObject>

- (NSArray<SpectacleShortcut *> *)loadShortcutsWithAction:(SpectacleShortcutAction)action;

- (void)storeShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts;

@end
