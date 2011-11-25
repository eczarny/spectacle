#import <Foundation/Foundation.h>

@class SpectacleHotKeyManager, SpectacleApplicationController;

@interface SpectacleHotKeyPreferencePane : NSObject<ZeroKitPreferencePaneProtocol, ZeroKitHotKeyRecorderDelegate> {
    SpectacleHotKeyManager *myHotKeyManager;
    NSDictionary *myHotKeyRecorders;
    IBOutlet SpectacleApplicationController *myApplicationController;
    IBOutlet NSView *myView;
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

- (NSString *)name;

#pragma mark -

- (NSImage *)icon;

#pragma mark -

- (NSString *)toolTip;

#pragma mark -

- (NSView *)view;

@end
