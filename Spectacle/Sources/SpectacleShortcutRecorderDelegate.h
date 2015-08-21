#import <Foundation/Foundation.h>

@class SpectacleShortcut, SpectacleShortcutRecorder;

@protocol SpectacleShortcutRecorderDelegate<NSObject>

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
   didReceiveNewShortcut:(SpectacleShortcut *)shortcut;

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
didClearExistingShortcut:(SpectacleShortcut *)shortcut;

@end
