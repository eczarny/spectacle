#import <Cocoa/Cocoa.h>
#import <ZeroKit/ZeroKit.h>

@class SpectacleHotKeyManager, SpectacleApplicationController;

@interface SpectaclePreferencesController : NSWindowController<ZKHotKeyRecorderDelegate> {
    SpectacleHotKeyManager *hotKeyManager;
    NSDictionary *hotKeyRecorders;
    IBOutlet ZKHotKeyRecorder *moveToCenterHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToFullscreenHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToLeftHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToRightHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToTopHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToBottomHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToUpperLeftHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToLowerLeftHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToUpperRightHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToLowerRightHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToNextDisplayHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToPreviousDisplayHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToNextThirdHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *moveToPreviousThirdHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *makeLargerHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *makeSmallerHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *undoLastMoveHotKeyRecorder;
    IBOutlet ZKHotKeyRecorder *redoLastMoveHotKeyRecorder;
    IBOutlet NSButton *loginItemEnabled;
    IBOutlet NSPopUpButton *statusItemEnabled;
}

- (IBAction)toggleWindow: (id)sender;

#pragma mark -

- (IBAction)hideWindow: (id)sender;

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender;

- (IBAction)toggleStatusItem: (id)sender;

@end
