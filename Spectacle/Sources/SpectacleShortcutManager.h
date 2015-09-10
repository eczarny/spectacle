#import <Foundation/Foundation.h>

#import "SpectacleShortcutStorageProtocol.h"

@class SpectacleShortcut;

@interface SpectacleShortcutManager : NSObject

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorageProtocol>)shortcutStorage NS_DESIGNATED_INITIALIZER;

#pragma mark -

- (void)registerShortcut:(SpectacleShortcut *)shortcut;

- (void)unregisterShortcutForName:(NSString *)name;

- (void)registerShortcuts:(NSArray *)shortcuts;

- (void)unregisterShortcuts;

#pragma mark -

- (NSArray *)registeredShortcuts;

- (SpectacleShortcut *)registeredShortcutForName:(NSString *)name;

#pragma mark -

- (BOOL)isShortcutRegistered:(SpectacleShortcut *)shortcut;

#pragma mark -

- (void)enableShortcuts;

- (void)disableShortcuts;

@end
