#import <PreferencePanes/PreferencePanes.h>
#import "SpectacleToggleSwitchDelegate.h"

@class SpectacleToggleSwitch;

@interface SpectaclePreferencePane : NSPreferencePane<ZeroKitHotKeyRecorderDelegate, SpectacleToggleSwitchDelegate> {
    id myVendedHelperController;
    NSDictionary *myHotKeyRecorders;
    IBOutlet NSTextField *mySpectacleVersionTextField;
    IBOutlet SpectacleToggleSwitch *myToggleRunningStateSwitch;
    IBOutlet NSTextField *myArtworkCreditTextField;
    IBOutlet NSButton *myLoginItemEnabledButton;
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
    IBOutlet ZeroKitHotKeyRecorder *myUndoLastMoveHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myRedoLastMoveHotKeyRecorder;
}

- (void)toggleLoginItem: (id)sender;

#pragma mark -

- (void)toggleCheckForUpdates: (id)sender;

@end
