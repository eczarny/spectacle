#import <Cocoa/Cocoa.h>

@class SpectaclePreferencesController;

@interface SpectacleAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

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
@property (nonatomic) IBOutlet NSMenuItem *moveToUpperThirdRightShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToMiddleThirdRightShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLowerThirdRightShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToUpperThirdLeftShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToMiddleThirdLeftShortcutMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLowerThirdLeftShortcutMenuItem;
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
- (IBAction)moveFrontmostWindowToUpperThirdRight:(id)sender;
- (IBAction)moveFrontmostWindowToMiddleThirdRight:(id)sender;
- (IBAction)moveFrontmostWindowToLowerThirdRight:(id)sender;
- (IBAction)moveFrontmostWindowToUpperThirdLeft:(id)sender;
- (IBAction)moveFrontmostWindowToMiddleThirdLeft:(id)sender;
- (IBAction)moveFrontmostWindowToLowerThirdLeft:(id)sender;
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
