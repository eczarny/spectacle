#import <Cocoa/Cocoa.h>

@class SpectacleHotKeyManager, SpectacleApplicationController;

@interface SpectaclePreferencesController : NSWindowController<ZeroKitHotKeyRecorderDelegate> {
    SpectacleApplicationController *myApplicationController;
    SpectacleHotKeyManager *myHotKeyManager;
    NSDictionary *myHotKeyRecorders;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToCenterHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToFullscreenHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLeftHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToRightHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToTopHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToBottomHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToUpperLeftHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLowerLeftHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToUpperRightHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLowerRightHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLeftDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToRightDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToTopDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToBottomDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToNextThirdHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToPreviousThirdHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myUndoLastMoveHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myRedoLastMoveHotKeyRecorder;
    IBOutlet NSButton *myLoginItemEnabled;
    IBOutlet NSPopUpButton *myStatusItemEnabled;
}

- (id)initWithApplicationController: (SpectacleApplicationController *)applicationController;

#pragma mark -

- (IBAction)toggleWindow: (id)sender;

#pragma mark -

- (IBAction)hideWindow: (id)sender;

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender;

- (IBAction)toggleStatusItem: (id)sender;

@end
