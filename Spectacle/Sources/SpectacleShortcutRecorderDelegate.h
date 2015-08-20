#import <Foundation/Foundation.h>

@class SpectacleShortcutRecorder, SpectacleShortcut;

@protocol SpectacleShortcutRecorderDelegate<NSObject>

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder didReceiveNewShortcut:(SpectacleShortcut *)shortcut;

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder didClearExistingShortcut:(SpectacleShortcut *)shortcut;

@end
