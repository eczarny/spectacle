#import <PreferencePanes/PreferencePanes.h>
#import "SpectacleHotKeyRecorderDelegate.h"
#import "SpectacleToggleSwitchDelegate.h"

@class SpectacleHotKeyRecorder, SpectacleToggleSwitch;

@interface SpectaclePreferencePane : NSPreferencePane<SpectacleHotKeyRecorderDelegate, SpectacleToggleSwitchDelegate> {
    id myVendedHelperController;
    NSDictionary *myHotKeyRecorders;
    IBOutlet NSTextField *mySpectacleVersionTextField;
    IBOutlet SpectacleToggleSwitch *myToggleRunningStateSwitch;
    IBOutlet NSButton *myLoginItemEnabledButton;
    IBOutlet NSButton *myAutomaticallyChecksForUpdatesButton;
    IBOutlet SpectacleHotKeyRecorder *myMoveToCenterHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToFullscreenHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToLeftHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToRightHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToTopHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToBottomHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToUpperLeftHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToLowerLeftHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToUpperRightHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToLowerRightHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToLeftDisplayHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToRightDisplayHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToTopDisplayHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myMoveToBottomDisplayHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myUndoLastMoveHotKeyRecorder;
    IBOutlet SpectacleHotKeyRecorder *myRedoLastMoveHotKeyRecorder;
}

- (void)toggleLoginItem: (id)sender;

#pragma mark -

- (void)toggleCheckForUpdates: (id)sender;

@end
