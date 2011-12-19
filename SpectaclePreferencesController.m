#import "SpectaclePreferencesController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHotKeyValidator.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectaclePreferencesController (SpectaclePreferencesControllerPrivate)

- (void)loadRegisteredHotKeys;

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled;

@end

#pragma mark -

@implementation SpectaclePreferencesController

- (id)initWithApplicationController: (SpectacleApplicationController *)applicationController {
    if ((self = [super initWithWindowNibName: SpectaclePreferencesWindowNibName])) {
        myApplicationController = applicationController;
        myHotKeyManager = [SpectacleHotKeyManager sharedManager];
    }
    
    return self;
}

#pragma mark -

- (void)windowDidLoad {
    NSInteger loginItemEnabledState = NSOffState;
    BOOL isStatusItemEnabled = [[NSUserDefaults standardUserDefaults] boolForKey: SpectacleStatusItemEnabledPreference];
    
    myHotKeyRecorders = [[NSDictionary alloc] initWithObjectsAndKeys:
        myMoveToCenterHotKeyRecorder,        SpectacleWindowActionMoveToCenter,
        myMoveToFullscreenHotKeyRecorder,    SpectacleWindowActionMoveToFullscreen,
        myMoveToLeftHotKeyRecorder,          SpectacleWindowActionMoveToLeftHalf,
        myMoveToRightHotKeyRecorder,         SpectacleWindowActionMoveToRightHalf,
        myMoveToTopHotKeyRecorder,           SpectacleWindowActionMoveToTopHalf,
        myMoveToBottomHotKeyRecorder,        SpectacleWindowActionMoveToBottomHalf,
        myMoveToUpperLeftHotKeyRecorder,     SpectacleWindowActionMoveToUpperLeft,
        myMoveToLowerLeftHotKeyRecorder,     SpectacleWindowActionMoveToLowerLeft,
        myMoveToUpperRightHotKeyRecorder,    SpectacleWindowActionMoveToUpperRight,
        myMoveToLowerRightHotKeyRecorder,    SpectacleWindowActionMoveToLowerRight,
        myMoveToLeftDisplayHotKeyRecorder,   SpectacleWindowActionMoveToLeftDisplay,
        myMoveToRightDisplayHotKeyRecorder,  SpectacleWindowActionMoveToRightDisplay,
        myMoveToTopDisplayHotKeyRecorder,    SpectacleWindowActionMoveToTopDisplay,
        myMoveToBottomDisplayHotKeyRecorder, SpectacleWindowActionMoveToBottomDisplay,
        myMoveToNextThirdHotKeyRecorder,     SpectacleWindowActionMoveToNextThird,
        myMoveToPreviousThirdHotKeyRecorder, SpectacleWindowActionMoveToPreviousThird,
        myUndoLastMoveHotKeyRecorder,        SpectacleWindowActionUndoLastMove,
        myRedoLastMoveHotKeyRecorder,        SpectacleWindowActionRedoLastMove, nil];
    
    [self loadRegisteredHotKeys];
    
    if ([SpectacleUtilities isLoginItemEnabledForBundle: [SpectacleUtilities applicationBundle]]) {
        loginItemEnabledState = NSOnState;
    }
    
    [myLoginItemEnabled setState: loginItemEnabledState];
    
    [myStatusItemEnabled selectItemWithTag: isStatusItemEnabled ? 0 : 1];
}

#pragma mark -

- (void)toggleWindow: (id)sender {
    if ([[self window] isKeyWindow]) {
        [self hideWindow: sender];
    } else {
        [self showWindow: sender];
    }
}

#pragma mark -

- (void)hideWindow: (id)sender {
    [self close];
}

#pragma mark -

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (ZeroKitHotKey *)hotKey {
    [hotKey setHotKeyAction: [SpectacleUtilities actionForHotKeyWithName: [hotKey hotKeyName] target: myApplicationController]];
    
    [myHotKeyManager registerHotKey: hotKey];
}

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZeroKitHotKey *)hotKey {
    [myHotKeyManager unregisterHotKeyForName: [hotKey hotKeyName]];
}

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender {
    NSBundle *applicationBundle = [SpectacleUtilities applicationBundle];
    
    if ([myLoginItemEnabled state] == NSOnState) {
        [SpectacleUtilities enableLoginItemForBundle: applicationBundle];
    } else{
        [SpectacleUtilities disableLoginItemForBundle: applicationBundle];
    }
}

- (IBAction)toggleStatusItem: (id)sender {
    NSString *notificationName = SpectacleStatusItemEnabledNotification;
    BOOL isStatusItemEnabled = YES;
    __block BOOL statusItemStateChanged = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey: SpectacleStatusItemEnabledPreference] == ([[sender selectedItem] tag] == 0)) {
        return;
    }
    
    if ([[sender selectedItem] tag] != 0) {
        notificationName = SpectacleStatusItemDisabledNotification;
        isStatusItemEnabled = NO;
        
        if (![userDefaults boolForKey: SpectacleBackgroundAlertSuppressedPreference]) {
            [SpectacleUtilities displayRunningInBackgroundAlertWithCallback: ^(BOOL isConfirmed, BOOL isSuppressed) {
                if (!isConfirmed) {
                    statusItemStateChanged = NO;
                    
                    [sender selectItemWithTag: 0];
                }
                
                [userDefaults setBool: isSuppressed forKey: SpectacleBackgroundAlertSuppressedPreference];
            }];
        }
    }
    
    if (statusItemStateChanged) {
        [[NSNotificationCenter defaultCenter] postNotificationName: notificationName object: self];
        
        [userDefaults setBool: isStatusItemEnabled forKey: SpectacleStatusItemEnabledPreference];
    }
}

@end

#pragma mark -

@implementation SpectaclePreferencesController (SpectaclePreferencesControllerPrivate)

- (void)loadRegisteredHotKeys {
    SpectacleHotKeyValidator *hotKeyValidator = [[SpectacleHotKeyValidator alloc] init];
    
    for (NSString *hotKeyName in [myHotKeyRecorders allKeys]) {
        ZeroKitHotKeyRecorder *hotKeyRecorder = [myHotKeyRecorders objectForKey: hotKeyName];
        ZeroKitHotKey *hotKey = [myHotKeyManager registeredHotKeyForName: hotKeyName];
        
        [hotKeyRecorder setHotKeyName: hotKeyName];
        
        if (hotKey) {
            [hotKeyRecorder setHotKey: hotKey];
        }
        
        [hotKeyRecorder setDelegate: self];
        
        [hotKeyRecorder setAdditionalHotKeyValidators: [NSArray arrayWithObject: hotKeyValidator]];
    }
    
    [hotKeyValidator release];
    
    [self enableHotKeyRecorders: YES];
}

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled {
    for (ZeroKitHotKeyRecorder *hotKeyRecorder in [myHotKeyRecorders allValues]) {
        if (!enabled) {
            [hotKeyRecorder setHotKey: nil];
        }
        
        [hotKeyRecorder setEnabled: enabled];
    }
}

@end
