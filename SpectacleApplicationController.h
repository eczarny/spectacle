#import <Foundation/Foundation.h>
#import "SpectacleWindowActionController.h"

@class SpectaclePreferencesController;

@interface SpectacleApplicationController : SpectacleWindowActionController

@property (nonatomic) IBOutlet NSMenu *statusItemMenu;
@property (nonatomic) IBOutlet NSWindow *accessiblityAccessDialogWindow;
@property (nonatomic) IBOutlet NSMenuItem *toggleHotKeysMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToCenterHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToFullscreenHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLeftHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToRightHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToTopHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToBottomHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToUpperLeftHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLowerLeftHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToUpperRightHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToLowerRightHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToNextDisplayHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToPreviousDisplayHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToNextThirdHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *moveToPreviousThirdHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *makeLargerHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *makeSmallerHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *undoLastMoveHotKeyMenuItem;
@property (nonatomic) IBOutlet NSMenuItem *redoLastMoveHotKeyMenuItem;

# pragma mark -

- (IBAction)showPreferencesWindow: (id)sender;

# pragma mark -

- (IBAction)openSystemPreferences: (id)sender;

# pragma mark -

- (IBAction)restoreDefaults: (id)sender;

@end
