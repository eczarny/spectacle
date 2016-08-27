#import <Cocoa/Cocoa.h>

@class SpectaclePreferencesController;

@interface SpectacleAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (nonatomic, strong) IBOutlet NSMenu *statusItemMenu;
@property (nonatomic, strong) IBOutlet NSWindow *accessiblityAccessDialogWindow;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToCenterShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToFullscreenShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToLeftShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToRightShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToTopShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToBottomShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToUpperLeftShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToLowerLeftShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToUpperRightShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToLowerRightShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToNextDisplayShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToPreviousDisplayShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToNextThirdShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *moveToPreviousThirdShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *makeLargerShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *makeSmallerShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *undoLastMoveShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *redoLastMoveShortcutMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *disableShortcutsForAnHourMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *disableShortcutsForApplicationMenuItem;

- (IBAction)showPreferencesWindow:(id)sender;

- (IBAction)moveFrontmostWindowToFullscreen:(id)sender;
- (IBAction)moveFrontmostWindowToCenter:(id)sender;
- (IBAction)moveFrontmostWindowToLeftHalf:(id)sender;
- (IBAction)moveFrontmostWindowToRightHalf:(id)sender;
- (IBAction)moveFrontmostWindowToTopHalf:(id)sender;
- (IBAction)moveFrontmostWindowToBottomHalf:(id)sender;
- (IBAction)moveFrontmostWindowToUpperLeft:(id)sender;
- (IBAction)moveFrontmostWindowToLowerLeft:(id)sender;
- (IBAction)moveFrontmostWindowToUpperRight:(id)sender;
- (IBAction)moveFrontmostWindowToLowerRight:(id)sender;
- (IBAction)moveFrontmostWindowToNextDisplay:(id)sender;
- (IBAction)moveFrontmostWindowToPreviousDisplay:(id)sender;
- (IBAction)moveFrontmostWindowToNextThird:(id)sender;
- (IBAction)moveFrontmostWindowToPreviousThird:(id)sender;
- (IBAction)makeFrontmostWindowLarger:(id)sender;
- (IBAction)makeFrontmostWindowSmaller:(id)sender;
- (IBAction)undoLastWindowAction:(id)sender;
- (IBAction)redoLastWindowAction:(id)sender;
- (IBAction)disableOrEnableShortcutsForAnHour:(id)sender;
- (IBAction)disableOrEnableShortcutsForApplication:(id)sender;

- (IBAction)openSystemPreferences:(id)sender;

@end
