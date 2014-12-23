#import "SpectaclePreferencesController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHotKeyValidator.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"
#import "ZKHotKeyRecorder.h"

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
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
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
        _tagWindow1Recorder,                  SpectacleWindowActionTagWindow1,
        _goToWindow1Recorder,                 SpectacleWindowActionGoToWindow1,
        _tagWindow2Recorder,                  SpectacleWindowActionTagWindow2,
        _goToWindow2Recorder,                 SpectacleWindowActionGoToWindow2,
        _tagWindow3Recorder,                  SpectacleWindowActionTagWindow3,
        _goToWindow3Recorder,                 SpectacleWindowActionGoToWindow3,
        _tagWindow4Recorder,                  SpectacleWindowActionTagWindow4,
        _goToWindow4Recorder,                 SpectacleWindowActionGoToWindow4,
        _tagWindow5Recorder,                  SpectacleWindowActionTagWindow5,
        _goToWindow5Recorder,                 SpectacleWindowActionGoToWindow5, nil];
    
    [self loadRegisteredHotKeys];

    [notificationCenter addObserver: self
                           selector: @selector(loadRegisteredHotKeys)
                               name: SpectacleRestoreDefaultHotKeysNotification
                             object: nil];

    if ([SpectacleUtilities isLoginItemEnabledForBundle: NSBundle.mainBundle]) {
        loginItemEnabledState = NSOnState;
    }
    
    _loginItemEnabled.state = loginItemEnabledState;
    
    [_statusItemEnabled selectItemWithTag: isStatusItemEnabled ? 0 : 1];

    [self.window setTitle: [NSString stringWithFormat: @"Spectacle %@", SpectacleUtilities.applicationVersion]];
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

    [NSNotificationCenter.defaultCenter postNotificationName: SpectacleHotKeyChangedNotification object: self];
}

- (void)hotKeyRecorder: (ZKHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZKHotKey *)hotKey {
    [_hotKeyManager unregisterHotKeyForName: hotKey.hotKeyName];

    [NSNotificationCenter.defaultCenter postNotificationName: SpectacleHotKeyChangedNotification object: self];
}

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender {
    NSBundle *applicationBundle = NSBundle.mainBundle;
    
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
