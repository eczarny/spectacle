#import <Foundation/Foundation.h>

@class SpectacleShortcut;

@protocol SpectacleShortcutStorage;

@interface SpectacleShortcutManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage NS_DESIGNATED_INITIALIZER;

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
