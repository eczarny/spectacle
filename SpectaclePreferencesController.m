#import "SpectaclePreferencesController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHotKeyValidator.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectaclePreferencesController (SpectaclePreferencesControllerPrivate)

- (void)loadRegisteredHotKeys;

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled;

@end

#pragma mark -

@implementation SpectaclePreferencesController

- (id)init {
    if ((self = [super initWithWindowNibName: SpectaclePreferencesWindowNibName])) {
        hotKeyManager = [SpectacleHotKeyManager sharedManager];
    }
    
    return self;
}

#pragma mark -

- (void)windowDidLoad {
    NSInteger loginItemEnabledState = NSOffState;
    BOOL isStatusItemEnabled = [[NSUserDefaults standardUserDefaults] boolForKey: SpectacleStatusItemEnabledPreference];
    
    hotKeyRecorders = [[NSDictionary alloc] initWithObjectsAndKeys:
        moveToCenterHotKeyRecorder,          SpectacleWindowActionMoveToCenter,
        moveToFullscreenHotKeyRecorder,      SpectacleWindowActionMoveToFullscreen,
        moveToLeftHotKeyRecorder,            SpectacleWindowActionMoveToLeftHalf,
        moveToRightHotKeyRecorder,           SpectacleWindowActionMoveToRightHalf,
        moveToTopHotKeyRecorder,             SpectacleWindowActionMoveToTopHalf,
        moveToBottomHotKeyRecorder,          SpectacleWindowActionMoveToBottomHalf,
        moveToUpperLeftHotKeyRecorder,       SpectacleWindowActionMoveToUpperLeft,
        moveToLowerLeftHotKeyRecorder,       SpectacleWindowActionMoveToLowerLeft,
        moveToUpperRightHotKeyRecorder,      SpectacleWindowActionMoveToUpperRight,
        moveToLowerRightHotKeyRecorder,      SpectacleWindowActionMoveToLowerRight,
        moveToNextDisplayHotKeyRecorder,     SpectacleWindowActionMoveToNextDisplay,
        moveToPreviousDisplayHotKeyRecorder, SpectacleWindowActionMoveToPreviousDisplay,
        moveToNextThirdHotKeyRecorder,       SpectacleWindowActionMoveToNextThird,
        moveToPreviousThirdHotKeyRecorder,   SpectacleWindowActionMoveToPreviousThird,
        makeLargerHotKeyRecorder,            SpectacleWindowActionMakeLarger,
        makeSmallerHotKeyRecorder,           SpectacleWindowActionMakeSmaller,
        undoLastMoveHotKeyRecorder,          SpectacleWindowActionUndoLastMove,
        redoLastMoveHotKeyRecorder,          SpectacleWindowActionRedoLastMove, nil];
    
    [self loadRegisteredHotKeys];
    
    if ([SpectacleUtilities isLoginItemEnabledForBundle: [SpectacleUtilities applicationBundle]]) {
        loginItemEnabledState = NSOnState;
    }
    
    [loginItemEnabled setState: loginItemEnabledState];
    
    [statusItemEnabled selectItemWithTag: isStatusItemEnabled ? 0 : 1];
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

- (void)hotKeyRecorder: (ZKHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (ZKHotKey *)hotKey {
    SpectacleWindowPositionManager *windowPositionManager = [SpectacleWindowPositionManager sharedManager];
    
    [hotKey setHotKeyAction: ^(ZKHotKey *hotKey) {
        [windowPositionManager moveFrontMostWindowWithAction: [windowPositionManager windowActionForHotKey: hotKey]];
    }];
    
    [hotKeyManager registerHotKey: hotKey];
}

- (void)hotKeyRecorder: (ZKHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZKHotKey *)hotKey {
    [hotKeyManager unregisterHotKeyForName: [hotKey hotKeyName]];
}

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender {
    NSBundle *applicationBundle = [SpectacleUtilities applicationBundle];
    
    if ([loginItemEnabled state] == NSOnState) {
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
    SpectacleHotKeyValidator *hotKeyValidator = [SpectacleHotKeyValidator new];
    
    for (NSString *hotKeyName in [hotKeyRecorders allKeys]) {
        ZKHotKeyRecorder *hotKeyRecorder = hotKeyRecorders[hotKeyName];
        ZKHotKey *hotKey = [hotKeyManager registeredHotKeyForName: hotKeyName];
        
        [hotKeyRecorder setHotKeyName: hotKeyName];
        
        if (hotKey) {
            [hotKeyRecorder setHotKey: hotKey];
        }
        
        [hotKeyRecorder setDelegate: self];
        
        [hotKeyRecorder setAdditionalHotKeyValidators: @[hotKeyValidator]];
    }
    
    
    [self enableHotKeyRecorders: YES];
}

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled {
    for (ZKHotKeyRecorder *hotKeyRecorder in [hotKeyRecorders allValues]) {
        if (!enabled) {
            [hotKeyRecorder setHotKey: nil];
        }
        
        [hotKeyRecorder setEnabled: enabled];
    }
}

@end
