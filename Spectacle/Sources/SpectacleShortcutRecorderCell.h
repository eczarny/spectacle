#import <Cocoa/Cocoa.h>

@class SpectacleShortcutManager;

@protocol SpectacleShortcutRecorderDelegate;
@protocol SpectacleShortcutValidator;

@interface SpectacleShortcutRecorderCell : NSCell

@property (nonatomic, strong) SpectacleShortcutRecorder *shortcutRecorder;
@property (nonatomic, copy) NSString *shortcutName;
@property (nonatomic, strong) SpectacleShortcut *shortcut;
@property (nonatomic, weak) id<SpectacleShortcutRecorderDelegate> delegate;
@property (nonatomic, copy) NSArray<id<SpectacleShortcutValidator>> *additionalShortcutValidators;
@property (nonatomic, strong) SpectacleShortcutManager *shortcutManager;

- (BOOL)resignFirstResponder;

- (BOOL)performKeyEquivalent:(NSEvent *)event;

- (void)flagsChanged:(NSEvent *)event;

@end
