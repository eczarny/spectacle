#import <Foundation/Foundation.h>

#import "SpectacleShortcutStorageProtocol.h"

@class SpectacleShortcut;

@interface SpectacleShortcutManager : NSObject

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorageProtocol>)shortcutStorage;

#pragma mark -

- (NSInteger)registerShortcut:(SpectacleShortcut *)shortcut;

- (void)registerShortcuts:(NSArray *)shortcuts;

#pragma mark -

- (void)unregisterShortcutForName:(NSString *)name;

- (void)unregisterShortcuts;

#pragma mark -

- (NSArray *)registeredShortcuts;

- (SpectacleShortcut *)registeredShortcutForName:(NSString *)name;

#pragma mark -

- (BOOL)isShortcutRegistered:(SpectacleShortcut *)shortcut;

@end
