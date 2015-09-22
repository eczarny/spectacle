#import <Cocoa/Cocoa.h>

@class SpectaclePreferencesController;

@interface SpectacleAppDelegate : NSObject<NSApplicationDelegate, NSMenuDelegate>

@property (nonatomic) IBOutlet NSMenu *statusItemMenu;
@property (nonatomic) IBOutlet NSWindow *accessiblityAccessDialogWindow;
@property (nonatomic) IBOutlet NSMenuItem *moveToCenterShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToFullscreenShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLeftShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToRightShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToTopShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToBottomShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToUpperLeftShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLowerLeftShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToUpperRightShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLowerRightShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToNextDisplayShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToPreviousDisplayShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToNextThirdShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToPreviousThirdShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *makeLargerShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *makeSmallerShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *undoLastMoveShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *redoLastMoveShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *disableShortcutsForAnHourMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *disableShortcutsForApplicationMenuItem;

# pragma mark -

- (IBAction)showPreferencesWindow:(id)sender;

# pragma mark -

- (IBAction)moveFrontmostWindowToFullscreen:(id)sender;

- (IBAction)moveFrontmostWindowToCenter:(id)sender;

#pragma mark -

- (IBAction)moveFrontmostWindowToLeftHalf:(id)sender;

- (IBAction)moveFrontmostWindowToRightHalf:(id)sender;

- (IBAction)moveFrontmostWindowToTopHalf:(id)sender;

- (IBAction)moveFrontmostWindowToBottomHalf:(id)sender;

#pragma mark -

- (IBAction)moveFrontmostWindowToUpperLeft:(id)sender;

- (IBAction)moveFrontmostWindowToLowerLeft:(id)sender;

#pragma mark -

- (IBAction)moveFrontmostWindowToUpperRight:(id)sender;

- (IBAction)moveFrontmostWindowToLowerRight:(id)sender;

#pragma mark -

- (IBAction)moveFrontmostWindowToNextDisplay:(id)sender;

- (IBAction)moveFrontmostWindowToPreviousDisplay:(id)sender;

#pragma mark -

- (IBAction)moveFrontmostWindowToNextThird:(id)sender;

- (IBAction)moveFrontmostWindowToPreviousThird:(id)sender;

#pragma mark -

- (IBAction)makeFrontmostWindowLarger:(id)sender;

- (IBAction)makeFrontmostWindowSmaller:(id)sender;

#pragma mark -

- (IBAction)undoLastWindowAction:(id)sender;

- (IBAction)redoLastWindowAction:(id)sender;

#pragma mark -

- (IBAction)disableOrEnableShortcutsForAnHour:(id)sender;

- (IBAction)disableOrEnableShortcutsForApplication:(id)sender;

# pragma mark -

- (IBAction)openSystemPreferences:(id)sender;

@end
