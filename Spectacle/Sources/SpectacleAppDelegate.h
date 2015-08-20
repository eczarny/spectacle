#import <Foundation/Foundation.h>

@class SpectaclePreferencesController;

@interface SpectacleAppDelegate : NSObject

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

# pragma mark -

- (IBAction)showPreferencesWindow:(id)sender;

# pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen:(id)sender;

- (IBAction)moveFrontMostWindowToCenter:(id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf:(id)sender;

- (IBAction)moveFrontMostWindowToRightHalf:(id)sender;

- (IBAction)moveFrontMostWindowToTopHalf:(id)sender;

- (IBAction)moveFrontMostWindowToBottomHalf:(id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft:(id)sender;

- (IBAction)moveFrontMostWindowToLowerLeft:(id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight:(id)sender;

- (IBAction)moveFrontMostWindowToLowerRight:(id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay:(id)sender;

- (IBAction)moveFrontMostWindowToPreviousDisplay:(id)sender;

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird:(id)sender;

- (IBAction)moveFrontMostWindowToPreviousThird:(id)sender;

#pragma mark -

- (IBAction)makeFrontMostWindowLarger:(id)sender;

- (IBAction)makeFrontMostWindowSmaller:(id)sender;

#pragma mark -

- (IBAction)undoLastWindowAction:(id)sender;

- (IBAction)redoLastWindowAction:(id)sender;

# pragma mark -

- (IBAction)restoreDefaults:(id)sender;

# pragma mark -

- (IBAction)openSystemPreferences:(id)sender;

@end
