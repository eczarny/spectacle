#import <Carbon/Carbon.h>

#import <Cocoa/Cocoa.h>

#import "SpectacleShortcutRecorderDelegate.h"

@class SpectacleShortcutManager;

@protocol SpectacleShortcutValidatorProtocol;

@interface SpectacleShortcutRecorder : NSControl

- (NSString *)shortcutName;

- (void)setShortcutName:(NSString *)shortcutName;

#pragma mark -

- (SpectacleShortcut *)shortcut;

- (void)setShortcut:(SpectacleShortcut *)shortcut;

#pragma mark -

- (id<SpectacleShortcutRecorderDelegate>)delegate;

- (void)setDelegate:(id<SpectacleShortcutRecorderDelegate>)delegate;

#pragma mark -

- (void)setAdditionalShortcutValidators:(NSArray<id<SpectacleShortcutValidatorProtocol>> *)additionalShortcutValidators
                        shortcutManager:(SpectacleShortcutManager *)shortcutManager;

@end
