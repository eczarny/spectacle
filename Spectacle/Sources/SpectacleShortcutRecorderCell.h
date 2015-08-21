#import <Cocoa/Cocoa.h>

#import "SpectacleShortcutRecorderDelegate.h"

@class SpectacleShortcutManager;

@interface SpectacleShortcutRecorderCell : NSCell

@property (nonatomic) SpectacleShortcutRecorder *shortcutRecorder;
@property (nonatomic) NSString *shortcutName;
@property (nonatomic) SpectacleShortcut *shortcut;
@property (nonatomic, assign) id<SpectacleShortcutRecorderDelegate> delegate;
@property (nonatomic) NSArray *additionalShortcutValidators;
@property (nonatomic) SpectacleShortcutManager *shortcutManager;

#pragma mark -

- (BOOL)resignFirstResponder;

#pragma mark -

- (BOOL)performKeyEquivalent:(NSEvent *)event;

- (void)flagsChanged:(NSEvent *)event;

@end
