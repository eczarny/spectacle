#import "SpectaclePreferencesController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHotKeyValidator.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectaclePreferencesController ()

@property (nonatomic, weak) SpectacleHotKeyManager *hotKeyManager;
@property (nonatomic) NSDictionary *hotKeyRecorders;

@end

#pragma mark -

@implementation SpectaclePreferencesController

- (id)init {
    if ((self = [super initWithWindowNibName: SpectaclePreferencesWindowNibName])) {
        _hotKeyManager = SpectacleHotKeyManager.sharedManager;
    }
    
    return self;
}

#pragma mark -

- (void)windowDidLoad {
    NSInteger loginItemEnabledState = NSOffState;
    BOOL isStatusItemEnabled = [NSUserDefaults.standardUserDefaults boolForKey: SpectacleStatusItemEnabledPreference];
    
    _hotKeyRecorders = [[NSDictionary alloc] initWithObjectsAndKeys:
        _moveToCenterHotKeyRecorder,          SpectacleWindowActionMoveToCenter,
        _moveToFullscreenHotKeyRecorder,      SpectacleWindowActionMoveToFullscreen,
        _moveToLeftHotKeyRecorder,            SpectacleWindowActionMoveToLeftHalf,
        _moveToRightHotKeyRecorder,           SpectacleWindowActionMoveToRightHalf,
        _moveToTopHotKeyRecorder,             SpectacleWindowActionMoveToTopHalf,
        _moveToBottomHotKeyRecorder,          SpectacleWindowActionMoveToBottomHalf,
        _moveToUpperLeftHotKeyRecorder,       SpectacleWindowActionMoveToUpperLeft,
        _moveToLowerLeftHotKeyRecorder,       SpectacleWindowActionMoveToLowerLeft,
        _moveToUpperRightHotKeyRecorder,      SpectacleWindowActionMoveToUpperRight,
        _moveToLowerRightHotKeyRecorder,      SpectacleWindowActionMoveToLowerRight,
        _moveToNextDisplayHotKeyRecorder,     SpectacleWindowActionMoveToNextDisplay,
        _moveToPreviousDisplayHotKeyRecorder, SpectacleWindowActionMoveToPreviousDisplay,
        _moveToNextThirdHotKeyRecorder,       SpectacleWindowActionMoveToNextThird,
        _moveToPreviousThirdHotKeyRecorder,   SpectacleWindowActionMoveToPreviousThird,
        _makeLargerHotKeyRecorder,            SpectacleWindowActionMakeLarger,
        _makeSmallerHotKeyRecorder,           SpectacleWindowActionMakeSmaller,
        _undoLastMoveHotKeyRecorder,          SpectacleWindowActionUndoLastMove,
        _redoLastMoveHotKeyRecorder,          SpectacleWindowActionRedoLastMove,
        _makeLargerVerticalHotKeyRecorder,    SpectacleWindowActionMakeLargerVertical,
        _makeSmallerVerticalHotKeyRecorder,   SpectacleWindowActionMakeSmallerVertical, nil];
    
    [self loadRegisteredHotKeys];
    
    if ([SpectacleUtilities isLoginItemEnabledForBundle: SpectacleUtilities.applicationBundle]) {
        loginItemEnabledState = NSOnState;
    }
    
    _loginItemEnabled.state = loginItemEnabledState;
    
    [_statusItemEnabled selectItemWithTag: isStatusItemEnabled ? 0 : 1];

    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];

    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString *bundleName = infoDictionary[@"CFBundleShortVersionString"];

    [self.versionNumberLabel setStringValue:[NSString stringWithFormat:@"%@ (%@)", bundleName, build]];
}

#pragma mark -

- (void)toggleWindow: (id)sender {
    if (self.window.isKeyWindow) {
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
    SpectacleWindowPositionManager *windowPositionManager = SpectacleWindowPositionManager.sharedManager;
    
    [hotKey setHotKeyAction: ^(ZKHotKey *hotKey) {
        [windowPositionManager moveFrontMostWindowWithAction: [windowPositionManager windowActionForHotKey: hotKey]];
    }];
    
    [_hotKeyManager registerHotKey: hotKey];
}

- (void)hotKeyRecorder: (ZKHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZKHotKey *)hotKey {
    [_hotKeyManager unregisterHotKeyForName: hotKey.hotKeyName];
}

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender {
    NSBundle *applicationBundle = SpectacleUtilities.applicationBundle;
    
    if (_loginItemEnabled.state == NSOnState) {
        [SpectacleUtilities enableLoginItemForBundle: applicationBundle];
    } else{
        [SpectacleUtilities disableLoginItemForBundle: applicationBundle];
    }
}

- (IBAction)toggleStatusItem: (id)sender {
    NSString *notificationName = SpectacleStatusItemEnabledNotification;
    BOOL isStatusItemEnabled = YES;
    __block BOOL statusItemStateChanged = YES;
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    
    if ([userDefaults boolForKey: SpectacleStatusItemEnabledPreference] == ([[sender selectedItem] tag] == 0)) {
        return;
    }
    
    if ([sender selectedItem].tag != 0) {
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
        [NSNotificationCenter.defaultCenter postNotificationName: notificationName object: self];
        
        [userDefaults setBool: isStatusItemEnabled forKey: SpectacleStatusItemEnabledPreference];
    }
}

#pragma mark -

- (void)loadRegisteredHotKeys {
    SpectacleHotKeyValidator *hotKeyValidator = [SpectacleHotKeyValidator new];
    
    for (NSString *hotKeyName in _hotKeyRecorders.allKeys) {
        ZKHotKeyRecorder *hotKeyRecorder = _hotKeyRecorders[hotKeyName];
        ZKHotKey *hotKey = [_hotKeyManager registeredHotKeyForName: hotKeyName];
        
        hotKeyRecorder.hotKeyName = hotKeyName;
        
        if (hotKey) {
            hotKeyRecorder.hotKey = hotKey;
        }
        
        hotKeyRecorder.delegate = self;
        
        hotKeyRecorder.additionalHotKeyValidators = @[hotKeyValidator];
    }
    
    
    [self enableHotKeyRecorders: YES];
}

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled {
    for (ZKHotKeyRecorder *hotKeyRecorder in _hotKeyRecorders.allValues) {
        if (!enabled) {
            hotKeyRecorder.hotKey = nil;
        }
        
        hotKeyRecorder.enabled = enabled;
    }
}

@end
