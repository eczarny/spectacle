#import <Cocoa/Cocoa.h>

@class SpectacleShortcut;
@class SpectacleShortcutManager;

@protocol SpectacleShortcutRecorderDelegate;
@protocol SpectacleShortcutValidator;

@interface SpectacleShortcutRecorder : NSView

@property (nonatomic, copy) NSString *shortcutName;
@property (nonatomic, strong) SpectacleShortcut *shortcut;
@property (nonatomic, weak) id<SpectacleShortcutRecorderDelegate> delegate;

- (void)setAdditionalShortcutValidators:(NSArray<id<SpectacleShortcutValidator>> *)additionalShortcutValidators
                        shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
