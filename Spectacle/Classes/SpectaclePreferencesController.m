#import "SpectaclePreferencesController.h"

#import "SpectacleConstants.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHotKeyValidator.h"
#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"
#import "ZKHotKeyRecorder.h"

@interface SpectaclePreferencesController ()

@property (nonatomic, weak) SpectacleHotKeyManager *hotKeyManager;
@property (nonatomic) NSDictionary *hotKeyRecorders;

@end

#pragma mark -

@implementation SpectaclePreferencesController

- (instancetype)init
{
  if ((self = [super initWithWindowNibName:SpectaclePreferencesWindowNibName])) {
    _hotKeyManager = SpectacleHotKeyManager.sharedManager;
  }
  
  return self;
}

#pragma mark -

- (void)windowDidLoad
{
  NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
  NSInteger loginItemEnabledState = NSOffState;
  BOOL isStatusItemEnabled = [NSUserDefaults.standardUserDefaults boolForKey:SpectacleStatusItemEnabledPreference];
  
  _hotKeyRecorders = @{SpectacleWindowActionMoveToCenter: _moveToCenterHotKeyRecorder,
                       SpectacleWindowActionMoveToFullscreen: _moveToFullscreenHotKeyRecorder,
                       SpectacleWindowActionMoveToLeftHalf: _moveToLeftHotKeyRecorder,
                       SpectacleWindowActionMoveToRightHalf: _moveToRightHotKeyRecorder,
                       SpectacleWindowActionMoveToTopHalf: _moveToTopHotKeyRecorder,
                       SpectacleWindowActionMoveToBottomHalf: _moveToBottomHotKeyRecorder,
                       SpectacleWindowActionMoveToUpperLeft: _moveToUpperLeftHotKeyRecorder,
                       SpectacleWindowActionMoveToLowerLeft: _moveToLowerLeftHotKeyRecorder,
                       SpectacleWindowActionMoveToUpperRight: _moveToUpperRightHotKeyRecorder,
                       SpectacleWindowActionMoveToLowerRight: _moveToLowerRightHotKeyRecorder,
                       SpectacleWindowActionMoveToNextDisplay: _moveToNextDisplayHotKeyRecorder,
                       SpectacleWindowActionMoveToPreviousDisplay: _moveToPreviousDisplayHotKeyRecorder,
                       SpectacleWindowActionMoveToNextThird: _moveToNextThirdHotKeyRecorder,
                       SpectacleWindowActionMoveToPreviousThird: _moveToPreviousThirdHotKeyRecorder,
                       SpectacleWindowActionMakeLarger: _makeLargerHotKeyRecorder,
                       SpectacleWindowActionMakeSmaller: _makeSmallerHotKeyRecorder,
                       SpectacleWindowActionUndoLastMove: _undoLastMoveHotKeyRecorder,
                       SpectacleWindowActionRedoLastMove: _redoLastMoveHotKeyRecorder};
  
  [self loadRegisteredHotKeys];

  [notificationCenter addObserver:self
                         selector:@selector(loadRegisteredHotKeys)
                             name:SpectacleRestoreDefaultHotKeysNotification
                           object:nil];

  if ([SpectacleUtilities isLoginItemEnabledForBundle:NSBundle.mainBundle]) {
    loginItemEnabledState = NSOnState;
  }
  
  _loginItemEnabled.state = loginItemEnabledState;
  
  [_statusItemEnabled selectItemWithTag:isStatusItemEnabled ? 0 : 1];

  [self.window setTitle:[NSString stringWithFormat:@"Spectacle %@", SpectacleUtilities.applicationVersion]];
}

#pragma mark -

- (void)toggleWindow:(id)sender
{
  if (self.window.isKeyWindow) {
    [self hideWindow:sender];
  } else {
    [self showWindow:sender];
  }
}

#pragma mark -

- (void)hideWindow:(id)sender
{
  [self close];
}

#pragma mark -

- (void)hotKeyRecorder:(ZKHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey:(ZKHotKey *)hotKey
{
  SpectacleWindowPositionManager *windowPositionManager = SpectacleWindowPositionManager.sharedManager;
  
  [hotKey setHotKeyAction:^(ZKHotKey *hotKey) {
    [windowPositionManager moveFrontMostWindowWithAction:[windowPositionManager windowActionForHotKey:hotKey]];
  }];
  
  [_hotKeyManager registerHotKey:hotKey];

  [NSNotificationCenter.defaultCenter postNotificationName:SpectacleHotKeyChangedNotification object:self];
}

- (void)hotKeyRecorder:(ZKHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey:(ZKHotKey *)hotKey
{
  [_hotKeyManager unregisterHotKeyForName:hotKey.hotKeyName];

  [NSNotificationCenter.defaultCenter postNotificationName:SpectacleHotKeyChangedNotification object:self];
}

#pragma mark -

- (IBAction)toggleLoginItem:(id)sender
{
  NSBundle *applicationBundle = NSBundle.mainBundle;
  
  if (_loginItemEnabled.state == NSOnState) {
    [SpectacleUtilities enableLoginItemForBundle:applicationBundle];
  } else {
    [SpectacleUtilities disableLoginItemForBundle:applicationBundle];
  }
}

- (IBAction)toggleStatusItem:(id)sender
{
  NSString *notificationName = SpectacleStatusItemEnabledNotification;
  BOOL isStatusItemEnabled = YES;
  __block BOOL statusItemStateChanged = YES;
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  
  if ([userDefaults boolForKey:SpectacleStatusItemEnabledPreference] == ([[sender selectedItem] tag] == 0)) {
    return;
  }
  
  if ([sender selectedItem].tag != 0) {
    notificationName = SpectacleStatusItemDisabledNotification;
    isStatusItemEnabled = NO;
    
    if (![userDefaults boolForKey:SpectacleBackgroundAlertSuppressedPreference]) {
      [SpectacleUtilities displayRunningInBackgroundAlertWithCallback:^(BOOL isConfirmed, BOOL isSuppressed) {
        if (!isConfirmed) {
          statusItemStateChanged = NO;
          
          [sender selectItemWithTag:0];
        }
        
        [userDefaults setBool:isSuppressed forKey:SpectacleBackgroundAlertSuppressedPreference];
      }];
    }
  }
  
  if (statusItemStateChanged) {
    [NSNotificationCenter.defaultCenter postNotificationName:notificationName object:self];
    
    [userDefaults setBool:isStatusItemEnabled forKey:SpectacleStatusItemEnabledPreference];
  }
}

#pragma mark -

- (void)loadRegisteredHotKeys
{
  SpectacleHotKeyValidator *hotKeyValidator = [SpectacleHotKeyValidator new];
  
  for (NSString *hotKeyName in _hotKeyRecorders.allKeys) {
    ZKHotKeyRecorder *hotKeyRecorder = _hotKeyRecorders[hotKeyName];
    ZKHotKey *hotKey = [_hotKeyManager registeredHotKeyForName:hotKeyName];
    
    hotKeyRecorder.hotKeyName = hotKeyName;
    
    if (hotKey) {
      hotKeyRecorder.hotKey = hotKey;
    }
    
    hotKeyRecorder.delegate = self;
    
    hotKeyRecorder.additionalHotKeyValidators = @[hotKeyValidator];
  }
  
  
  [self enableHotKeyRecorders:YES];
}

#pragma mark -

- (void)enableHotKeyRecorders:(BOOL)enabled
{
  for (ZKHotKeyRecorder *hotKeyRecorder in _hotKeyRecorders.allValues) {
    if (!enabled) {
      hotKeyRecorder.hotKey = nil;
    }
    
    hotKeyRecorder.enabled = enabled;
  }
}

@end
