#import "SpectacleConstants.h"
#import "SpectacleLoginItemHelper.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleRegisteredShortcutValidator.h"
#import "SpectacleShortcut.h"
#import "SpectacleShortcutManager.h"
#import "SpectacleShortcutRecorder.h"
#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"

@interface SpectaclePreferencesController ()

@property (nonatomic, weak) SpectacleShortcutManager *shortcutManager;
@property (nonatomic) NSDictionary *shortcutRecorders;

@end

#pragma mark -

@implementation SpectaclePreferencesController

- (instancetype)init
{
  if ((self = [super initWithWindowNibName:SpectaclePreferencesWindowNibName])) {
    _shortcutManager = SpectacleShortcutManager.sharedManager;
  }
  
  return self;
}

#pragma mark -

- (void)windowDidLoad
{
  NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
  NSInteger loginItemEnabledState = NSOffState;
  BOOL isStatusItemEnabled = [NSUserDefaults.standardUserDefaults boolForKey:SpectacleStatusItemEnabledPreference];

  self.shortcutRecorders = @{SpectacleWindowActionMoveToCenter: _moveToCenterShortcutRecorder,
                             SpectacleWindowActionMoveToFullscreen: _moveToFullscreenShortcutRecorder,
                             SpectacleWindowActionMoveToLeftHalf: _moveToLeftShortcutRecorder,
                             SpectacleWindowActionMoveToRightHalf: _moveToRightShortcutRecorder,
                             SpectacleWindowActionMoveToTopHalf: _moveToTopShortcutRecorder,
                             SpectacleWindowActionMoveToBottomHalf: _moveToBottomShortcutRecorder,
                             SpectacleWindowActionMoveToUpperLeft: _moveToUpperLeftShortcutRecorder,
                             SpectacleWindowActionMoveToLowerLeft: _moveToLowerLeftShortcutRecorder,
                             SpectacleWindowActionMoveToUpperRight: _moveToUpperRightShortcutRecorder,
                             SpectacleWindowActionMoveToLowerRight: _moveToLowerRightShortcutRecorder,
                             SpectacleWindowActionMoveToNextDisplay: _moveToNextDisplayShortcutRecorder,
                             SpectacleWindowActionMoveToPreviousDisplay: _moveToPreviousDisplayShortcutRecorder,
                             SpectacleWindowActionMoveToNextThird: _moveToNextThirdShortcutRecorder,
                             SpectacleWindowActionMoveToPreviousThird: _moveToPreviousThirdShortcutRecorder,
                             SpectacleWindowActionMakeLarger: _makeLargerShortcutRecorder,
                             SpectacleWindowActionMakeSmaller: _makeSmallerShortcutRecorder,
                             SpectacleWindowActionUndoLastMove: _undoLastMoveShortcutRecorder,
                             SpectacleWindowActionRedoLastMove: _redoLastMoveShortcutRecorder};
  
  [self loadRegisteredShortcuts];

  [notificationCenter addObserver:self
                         selector:@selector(loadRegisteredShortcuts)
                             name:SpectacleRestoreDefaultShortcutsNotification
                           object:nil];

  if ([SpectacleLoginItemHelper isLoginItemEnabledForBundle:NSBundle.mainBundle]) {
    loginItemEnabledState = NSOnState;
  }
  
  self.loginItemEnabled.state = loginItemEnabledState;
  
  [self.statusItemEnabled selectItemWithTag:isStatusItemEnabled ? 0 : 1];

  [self.window setTitle:[NSString stringWithFormat:@"Spectacle %@", SpectacleUtilities.applicationVersion]];
}

#pragma mark -

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder didReceiveNewShortcut:(SpectacleShortcut *)shortcut
{
  SpectacleWindowPositionManager *windowPositionManager = SpectacleWindowPositionManager.sharedManager;
  
  [shortcut setShortcutAction:^(SpectacleShortcut *shortcut) {
    [windowPositionManager moveFrontMostWindowWithWindowAction:[windowPositionManager windowActionForShortcut:shortcut]];
  }];

  [self.shortcutManager registerShortcut:shortcut];

  [NSNotificationCenter.defaultCenter postNotificationName:SpectacleShortcutChangedNotification object:self];
}

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder didClearExistingShortcut:(SpectacleShortcut *)shortcut
{
  [self.shortcutManager unregisterShortcutForName:shortcut.shortcutName];

  [NSNotificationCenter.defaultCenter postNotificationName:SpectacleShortcutChangedNotification object:self];
}

#pragma mark -

- (IBAction)toggleLoginItem:(id)sender
{
  NSBundle *applicationBundle = NSBundle.mainBundle;
  
  if (self.loginItemEnabled.state == NSOnState) {
    [SpectacleLoginItemHelper enableLoginItemForBundle:applicationBundle];
  } else {
    [SpectacleLoginItemHelper disableLoginItemForBundle:applicationBundle];
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

- (void)loadRegisteredShortcuts
{
  SpectacleRegisteredShortcutValidator *shortcutValidator = [SpectacleRegisteredShortcutValidator new];

  for (NSString *shortcutName in self.shortcutRecorders.allKeys) {
    SpectacleShortcutRecorder *shortcutRecorder = self.shortcutRecorders[shortcutName];
    SpectacleShortcut *shortcut = [self.shortcutManager registeredShortcutForName:shortcutName];
    
    shortcutRecorder.shortcutName = shortcutName;
    
    if (shortcut) {
      shortcutRecorder.shortcut = shortcut;
    }
    
    shortcutRecorder.delegate = self;
    
    shortcutRecorder.additionalShortcutValidators = @[shortcutValidator];
  }
  
  
  [self enableShortcutRecorders:YES];
}

#pragma mark -

- (void)enableShortcutRecorders:(BOOL)enabled
{
  for (SpectacleShortcutRecorder *shortcutRecorder in self.shortcutRecorders.allValues) {
    if (!enabled) {
      shortcutRecorder.shortcut = nil;
    }
    
    shortcutRecorder.enabled = enabled;
  }
}

@end
