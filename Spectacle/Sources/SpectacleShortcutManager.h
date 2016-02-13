#import <Foundation/Foundation.h>

#import "SpectacleShortcutStorageProtocol.h"

@class SpectacleShortcut;

@interface SpectacleShortcutManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorageProtocol>)shortcutStorage NS_DESIGNATED_INITIALIZER;

#pragma mark -

- (void)registerShortcut:(SpectacleShortcut *)shortcut;

- (void)unregisterShortcutForName:(NSString *)name;

- (void)registerShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts;

- (void)unregisterShortcuts;

#pragma mark -

- (NSArray<SpectacleShortcut *> *)registeredShortcuts;

- (SpectacleShortcut *)registeredShortcutForName:(NSString *)name;

#pragma mark -

- (BOOL)isShortcutRegistered:(SpectacleShortcut *)shortcut;

#pragma mark -

- (void)enableShortcuts;

- (void)disableShortcuts;

@end
