#import <Carbon/Carbon.h>

#import <Cocoa/Cocoa.h>

@class SpectacleShortcutManager;

@protocol SpectacleShortcutRecorderDelegate;
@protocol SpectacleShortcutValidator;

@interface SpectacleShortcutRecorder : NSControl

- (NSString *)shortcutName;
- (void)setShortcutName:(NSString *)shortcutName;

- (SpectacleShortcut *)shortcut;
- (void)setShortcut:(SpectacleShortcut *)shortcut;

- (id<SpectacleShortcutRecorderDelegate>)delegate;
- (void)setDelegate:(id<SpectacleShortcutRecorderDelegate>)delegate;

- (void)setAdditionalShortcutValidators:(NSArray<id<SpectacleShortcutValidator>> *)additionalShortcutValidators
                        shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
