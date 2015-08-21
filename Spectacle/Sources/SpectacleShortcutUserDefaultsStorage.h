#import <Foundation/Foundation.h>

#import "SpectacleShortcutStorageProtocol.h"

@interface SpectacleShortcutUserDefaultsStorage : NSObject<SpectacleShortcutStorageProtocol>

- (NSArray *)loadShortcutsWithAction:(SpectacleShortcutAction)action;

- (NSArray *)defaultShortcutsWithAction:(SpectacleShortcutAction)action;

#pragma mark -

- (void)storeShortcuts: (NSArray *)shortcuts;

@end
