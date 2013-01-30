#import <Cocoa/Cocoa.h>
#import <ZeroKit/ZeroKit.h>

@class SpectacleHotKeyManager, SpectacleApplicationController;

@interface SpectaclePreferencesController : NSWindowController<ZKHotKeyRecorderDelegate> {
    SpectacleApplicationController *myApplicationController;
    SpectacleHotKeyManager *myHotKeyManager;
    NSDictionary *myHotKeyRecorders;
    IBOutlet ZKHotKeyRecorder *myMoveToCenterHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToFullscreenHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToLeftHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToRightHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToTopHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToBottomHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToUpperLeftHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToLowerLeftHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToUpperRightHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToLowerRightHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToNextDisplayHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToPreviousDisplayHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToNextThirdHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myMoveToPreviousThirdHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myUndoLastMoveHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *myRedoLastMoveHotKeyRecorder;
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
