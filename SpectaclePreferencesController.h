#import <Cocoa/Cocoa.h>
#import <ZeroKit/ZeroKit.h>

@class SpectacleHotKeyManager, SpectacleApplicationController;

@interface SpectaclePreferencesController : NSWindowController<ZKHotKeyRecorderDelegate>

@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToCenterHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToFullscreenHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToLeftHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToRightHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToTopHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToBottomHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToUpperLeftHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToLowerLeftHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToUpperRightHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToLowerRightHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToNextDisplayHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToPreviousDisplayHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToNextThirdHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *moveToPreviousThirdHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *makeLargerHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *makeSmallerHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *undoLastMoveHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *redoLastMoveHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *makeLargerVerticalHotKeyRecorder;
@property (nonatomic) IBOutlet ZKHotKeyRecorder *makeSmallerVerticalHotKeyRecorder;
@property (nonatomic) IBOutlet NSButton *loginItemEnabled;
@property (nonatomic) IBOutlet NSPopUpButton *statusItemEnabled;

#pragma mark -

- (IBAction)toggleWindow: (id)sender;

#pragma mark -

- (IBAction)hideWindow: (id)sender;

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender;

- (IBAction)toggleStatusItem: (id)sender;

@end
