#import <Cocoa/Cocoa.h>

#import "SpectacleShortcutRecorderDelegate.h"

@class SpectacleAppDelegate;
@class SpectacleShortcutManager;
@class SpectacleShortcutRecorder;
@class SpectacleWindowPositionManager;

@protocol SpectacleShortcutStorage;

@interface SpectaclePreferencesController : NSWindowController <SpectacleShortcutRecorderDelegate>

@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToCenterShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToFullscreenShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToLeftShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToRightShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToTopShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToBottomShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToUpperLeftShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToLowerLeftShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToUpperRightShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToLowerRightShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToNextDisplayShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToPreviousDisplayShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToNextThirdShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToPreviousThirdShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *makeLargerShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *makeSmallerShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *undoLastMoveShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *redoLastMoveShortcutRecorder;

@property (nonatomic) IBOutlet NSView *footerView;
@property (nonatomic) IBOutlet NSView *shortcutModifierLegendFooterView;
@property (nonatomic) IBOutlet NSView *optionsFooterView;

@property (nonatomic) IBOutlet NSButton *loginItemEnabled;
@property (nonatomic) IBOutlet NSPopUpButton *statusItemEnabled;

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                  windowPositionManager:(SpectacleWindowPositionManager *)windowPositionManager
                        shortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage;

- (IBAction)swapFooterViews:(id)sender;

- (IBAction)restoreDefaults:(id)sender;

- (IBAction)toggleLoginItem:(id)sender;
- (IBAction)toggleStatusItem:(id)sender;

@end
