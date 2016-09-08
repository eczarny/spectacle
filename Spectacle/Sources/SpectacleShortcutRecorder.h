#import <Cocoa/Cocoa.h>

@class SpectacleShortcut;
@class SpectacleShortcutValidation;

@protocol SpectacleShortcutRecorderDelegate;

@interface SpectacleShortcutRecorder : NSView

@property (nonatomic, copy) NSString *shortcutName;
@property (nonatomic, strong) SpectacleShortcut *shortcut;
@property (nonatomic, strong) SpectacleShortcutValidation *shortcutValidation;
@property (nonatomic, weak) id<SpectacleShortcutRecorderDelegate> delegate;

@end
