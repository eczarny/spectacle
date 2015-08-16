#import <Sparkle/Sparkle.h>

#import "SpectacleApplicationController.h"
#import "SpectacleAlertController.h"
#import "SpectacleConstants.h"
#import "SpectacleHotKeyManager.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleUtilities.h"
#import "ZKHotKeyTranslator.h"

@interface SpectacleApplicationController ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) NSDictionary *hotKeyMenuItems;
@property (nonatomic) SpectaclePreferencesController *preferencesController;
@property (nonatomic) SpectacleAlertController * alertController;

@end

#pragma mark -

@implementation SpectacleApplicationController

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;

  [SpectacleUtilities registerDefaultsForBundle:NSBundle.mainBundle];

  _preferencesController = [SpectaclePreferencesController new];

  _alertController = [SpectacleAlertController new];
    
  _hotKeyMenuItems = @{SpectacleWindowActionMoveToCenter: _moveToCenterHotKeyMenuItem,
                       SpectacleWindowActionMoveToFullscreen: _moveToFullscreenHotKeyMenuItem,
                       SpectacleWindowActionMoveToLeftHalf: _moveToLeftHotKeyMenuItem,
                       SpectacleWindowActionMoveToRightHalf: _moveToRightHotKeyMenuItem,
                       SpectacleWindowActionMoveToTopHalf: _moveToTopHotKeyMenuItem,
                       SpectacleWindowActionMoveToBottomHalf: _moveToBottomHotKeyMenuItem,
                       SpectacleWindowActionMoveToUpperLeft: _moveToUpperLeftHotKeyMenuItem,
                       SpectacleWindowActionMoveToLowerLeft: _moveToLowerLeftHotKeyMenuItem,
                       SpectacleWindowActionMoveToUpperRight: _moveToUpperRightHotKeyMenuItem,
                       SpectacleWindowActionMoveToLowerRight: _moveToLowerRightHotKeyMenuItem,
                       SpectacleWindowActionMoveToNextDisplay: _moveToNextDisplayHotKeyMenuItem,
                       SpectacleWindowActionMoveToPreviousDisplay: _moveToPreviousDisplayHotKeyMenuItem,
                       SpectacleWindowActionMoveToNextThird: _moveToNextThirdHotKeyMenuItem,
                       SpectacleWindowActionMoveToPreviousThird: _moveToPreviousThirdHotKeyMenuItem,
                       SpectacleWindowActionMakeLarger: _makeLargerHotKeyMenuItem,
                       SpectacleWindowActionMakeSmaller: _makeSmallerHotKeyMenuItem,
                       SpectacleWindowActionUndoLastMove: _undoLastMoveHotKeyMenuItem,
                       SpectacleWindowActionRedoLastMove: _redoLastMoveHotKeyMenuItem};

  [self registerHotKeys];

  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  BOOL automaticallyChecksForUpdates = [userDefaults boolForKey:SpectacleAutomaticUpdateCheckEnabledPreference];
  BOOL statusItemEnabled = [userDefaults boolForKey:SpectacleStatusItemEnabledPreference];

  if (statusItemEnabled) {
    [self createStatusItem];
  }

  [notificationCenter addObserver:self
                         selector:@selector(enableStatusItem)
                             name:SpectacleStatusItemEnabledNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(disableStatusItem)
                             name:SpectacleStatusItemDisabledNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(updateHotKeyMenuItems)
                             name:SpectacleHotKeyChangedNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(updateHotKeyMenuItems)
                             name:SpectacleRestoreDefaultHotKeysNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(menuDidSendAction:)
                             name:NSMenuDidSendActionNotification
                           object:nil];

  [notificationCenter addObserver: self
                         selector: @selector(showAlertPanel:)
                             name: SpectacleShowAlertNotification
                           object: nil];

    
  [SUUpdater.sharedUpdater setAutomaticallyChecksForUpdates:automaticallyChecksForUpdates];

  [self updateHotKeyMenuItems];

  switch (SpectacleUtilities.spectacleTrust) {
    case SpectacleIsNotTrusted:
      [[NSApplication sharedApplication] runModalForWindow:_accessiblityAccessDialogWindow];

      break;
    default:
      break;
  }

  [userDefaults removeObjectForKey:SpectacleBlacklistedWindowRectsPreference];
}

#pragma mark -

- (BOOL)applicationShouldHandleReopen:(NSApplication *)application hasVisibleWindows:(BOOL)visibleWindows
{
  [self showPreferencesWindow:self];

  return YES;
}

#pragma mark -

- (IBAction)showPreferencesWindow:(id)sender
{
  [_preferencesController showWindow:sender];
}

#pragma mark -

- (IBAction)openSystemPreferences:(id)sender
{
  NSURL *preferencePaneURL = [NSURL fileURLWithPath:[SpectacleUtilities pathForPreferencePaneNamed:SpectacleSecurityPreferencePaneName]];
  NSBundle *applicationBundle = NSBundle.mainBundle;
  NSURL *scriptURL = [applicationBundle URLForResource:SpectacleSecurityAndPrivacyPreferencesScriptName
                                         withExtension:SpectacleAppleScriptFileExtension];

  [NSApplication.sharedApplication stopModal];

  [_accessiblityAccessDialogWindow orderOut:self];

  if (![[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:nil] executeAndReturnError:nil]) {
    [NSWorkspace.sharedWorkspace openURL:preferencePaneURL];
  }
}

#pragma mark -

- (IBAction)restoreDefaults:(id)sender
{
  [SpectacleUtilities displayRestoreDefaultsAlertWithCallback:^(BOOL isConfirmed) {
    if (isConfirmed) {
      [SpectacleUtilities restoreDefaultHotKeys];

      [NSNotificationCenter.defaultCenter postNotificationName:SpectacleRestoreDefaultHotKeysNotification
                                                        object:self];
    }
  }];
}

#pragma mark -

- (void)createStatusItem
{
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  
  NSImage *statusImage = [NSBundle.mainBundle imageForResource:SpectacleStatusItemIcon];
  
  [statusImage setTemplate:YES];
  
  _statusItem.image = statusImage;
  _statusItem.highlightMode = YES;
  _statusItem.toolTip = [NSString stringWithFormat:@"Spectacle %@", SpectacleUtilities.applicationVersion];

  [_statusItem setMenu:_statusItemMenu];
}

- (void)destroyStatusItem
{
  [NSStatusBar.systemStatusBar removeStatusItem:_statusItem];
}

#pragma mark -

- (void)updateHotKeyMenuItems
{
  SpectacleHotKeyManager *hotKeyManager = SpectacleHotKeyManager.sharedManager;
  ZKHotKeyTranslator *hotKeyTranslator = ZKHotKeyTranslator.sharedTranslator;

  for (NSString *hotKeyName in _hotKeyMenuItems.allKeys) {
    NSMenuItem *hotKeyMenuItem = _hotKeyMenuItems[hotKeyName];
    ZKHotKey *hotKey = [hotKeyManager registeredHotKeyForName:hotKeyName];

    if (hotKey) {
      hotKeyMenuItem.keyEquivalent = [[hotKeyTranslator translateKeyCode:hotKey.hotKeyCode] lowercaseString];
      hotKeyMenuItem.keyEquivalentModifierMask = [ZKHotKeyTranslator convertModifiersToCocoaIfNecessary:hotKey.hotKeyModifiers];
    } else {
      hotKeyMenuItem.keyEquivalent = @"";
      hotKeyMenuItem.keyEquivalentModifierMask = 0;
    }
  }
}

#pragma mark -

- (void)enableStatusItem
{
  [self createStatusItem];
}

- (void)disableStatusItem
{
  [self destroyStatusItem];
}

#pragma mark -

- (void)menuDidSendAction:(NSNotification *)notification
{
  NSMenuItem *menuItem = (notification.userInfo)[@"MenuItem"];

  if (menuItem.tag == SpectacleMenuItemActivateIgnoringOtherApps) {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}


#pragma mark - DivideAlertController

- (void)showAlertPanel:(NSNotification *)notification {
    [_alertController close];
    
    NSDictionary *userInfo = [notification userInfo];
    NSInteger type = [[userInfo valueForKey:@"type"] integerValue];
    
    _alertController.windowType = type;
    [_alertController showWindow:self];
    
    _alertController.window.level = NSFloatingWindowLevel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:0.5];
            [_alertController close];
        });
    });
}

@end
