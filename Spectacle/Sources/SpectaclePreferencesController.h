#import <Cocoa/Cocoa.h>

#import "SpectacleShortcutRecorderDelegate.h"
#import "SpectacleShortcutStorageProtocol.h"

@class SpectacleAppDelegate;
@class SpectacleShortcutManager;
@class SpectacleShortcutRecorder;
@class SpectacleWindowPositionManager;

@interface SpectaclePreferencesController : NSWindowController<SpectacleShortcutRecorderDelegate>

@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToCenterShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *moveToFullscreenShortcutRecorder;
@property (nonatomic) IBOutlet SpectacleShortcutRecorder *setDimensionsShortcutRecorder;
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

#pragma mark -

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                  windowPositionManager:(SpectacleWindowPositionManager *)windowPositionManager
                        shortcutStorage:(id<SpectacleShortcutStorageProtocol>)shortcutStorage;

#pragma mark -

- (IBAction)swapFooterViews:(id)sender;

#pragma mark -

- (IBAction)restoreDefaults:(id)sender;

#pragma mark -

- (IBAction)toggleLoginItem:(id)sender;

- (IBAction)toggleStatusItem:(id)sender;

@end
