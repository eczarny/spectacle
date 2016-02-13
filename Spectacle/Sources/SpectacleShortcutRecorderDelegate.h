#import <Foundation/Foundation.h>

@class SpectacleShortcut;
@class SpectacleShortcutRecorder;

@protocol SpectacleShortcutRecorderDelegate <NSObject>

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
   didReceiveNewShortcut:(SpectacleShortcut *)shortcut;

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
didClearExistingShortcut:(SpectacleShortcut *)shortcut;

@end
