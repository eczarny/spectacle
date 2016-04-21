#import <Cocoa/Cocoa.h>

@class SpectacleShortcutManager;

@protocol SpectacleShortcutRecorderDelegate;
@protocol SpectacleShortcutValidator;

@interface SpectacleShortcutRecorderCell : NSCell

@property (nonatomic) SpectacleShortcutRecorder *shortcutRecorder;
@property (nonatomic) NSString *shortcutName;
@property (nonatomic) SpectacleShortcut *shortcut;
@property (nonatomic, weak) id<SpectacleShortcutRecorderDelegate> delegate;
@property (nonatomic) NSArray<id<SpectacleShortcutValidator>> *additionalShortcutValidators;
@property (nonatomic) SpectacleShortcutManager *shortcutManager;

- (BOOL)resignFirstResponder;

- (BOOL)performKeyEquivalent:(NSEvent *)event;

- (void)flagsChanged:(NSEvent *)event;

@end
