#import <Cocoa/Cocoa.h>

#import "SpectacleShortcutRecorderDelegate.h"

@class SpectacleAppDelegate;
@class SpectacleShortcutManager;
@class SpectacleShortcutRecorder;
@class SpectacleWindowPositionManager;

@protocol SpectacleShortcutStorage;

@interface SpectaclePreferencesController : NSWindowController <SpectacleShortcutRecorderDelegate>

@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToCenterShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToFullscreenShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToLeftShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToRightShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToTopShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToBottomShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToUpperLeftShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToLowerLeftShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToUpperRightShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToLowerRightShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToNextDisplayShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToPreviousDisplayShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToNextThirdShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *moveToPreviousThirdShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *makeLargerShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *makeSmallerShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *undoLastMoveShortcutRecorder;
@property (nonatomic, strong) IBOutlet SpectacleShortcutRecorder *redoLastMoveShortcutRecorder;

@property (nonatomic, strong) IBOutlet NSView *footerView;
@property (nonatomic, strong) IBOutlet NSView *shortcutModifierLegendFooterView;
@property (nonatomic, strong) IBOutlet NSView *optionsFooterView;

@property (nonatomic, strong) IBOutlet NSButton *loginItemEnabled;
@property (nonatomic, strong) IBOutlet NSPopUpButton *statusItemEnabled;

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                  windowPositionManager:(SpectacleWindowPositionManager *)windowPositionManager
                        shortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage;

- (void)loadRegisteredShortcuts;

- (IBAction)swapFooterViews:(id)sender;

- (IBAction)restoreDefaults:(id)sender;

- (IBAction)toggleLoginItem:(id)sender;
- (IBAction)toggleStatusItem:(id)sender;

@end
