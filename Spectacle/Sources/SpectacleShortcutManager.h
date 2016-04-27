#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@class SpectacleShortcut;

@protocol SpectacleShortcutStorage;

@interface SpectacleShortcutManager : NSObject

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (void)manageShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts;

- (void)updateShortcut:(SpectacleShortcut *)shortcut;
- (void)updateShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts;

- (void)clearShortcut:(SpectacleShortcut *)shortcut;

- (NSArray<SpectacleShortcut *> *)shortcuts;
- (SpectacleShortcut *)shortcutForShortcutName:(NSString *)shortcutName;

- (BOOL)doesShortcutExist:(SpectacleShortcut *)shortcut;

- (void)registerShortcuts;
- (void)unregisterShortcuts;

@end
