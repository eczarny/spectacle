#import <Sparkle/Sparkle.h>

#import "SpectacleApplicationController.h"
#import "SpectacleConstants.h"
#import "SpectacleShortcutManager.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleShortcutTranslator.h"
#import "SpectacleUtilities.h"

@interface SpectacleApplicationController ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) NSDictionary *shortcutMenuItems;
@property (nonatomic) SpectaclePreferencesController *preferencesController;

@end

#pragma mark -

@implementation SpectacleApplicationController

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;

  [SpectacleUtilities registerDefaultsForBundle:NSBundle.mainBundle];

  self.preferencesController = [SpectaclePreferencesController new];

  self.shortcutMenuItems = @{SpectacleWindowActionMoveToCenter: _moveToCenterShortcutMenuItem,
                             SpectacleWindowActionMoveToFullscreen: _moveToFullscreenShortcutMenuItem,
                             SpectacleWindowActionMoveToLeftHalf: _moveToLeftShortcutMenuItem,
                             SpectacleWindowActionMoveToRightHalf: _moveToRightShortcutMenuItem,
                             SpectacleWindowActionMoveToTopHalf: _moveToTopShortcutMenuItem,
                             SpectacleWindowActionMoveToBottomHalf: _moveToBottomShortcutMenuItem,
                             SpectacleWindowActionMoveToUpperLeft: _moveToUpperLeftShortcutMenuItem,
                             SpectacleWindowActionMoveToLowerLeft: _moveToLowerLeftShortcutMenuItem,
                             SpectacleWindowActionMoveToUpperRight: _moveToUpperRightShortcutMenuItem,
                             SpectacleWindowActionMoveToLowerRight: _moveToLowerRightShortcutMenuItem,
                             SpectacleWindowActionMoveToNextDisplay: _moveToNextDisplayShortcutMenuItem,
                             SpectacleWindowActionMoveToPreviousDisplay: _moveToPreviousDisplayShortcutMenuItem,
                             SpectacleWindowActionMoveToNextThird: _moveToNextThirdShortcutMenuItem,
                             SpectacleWindowActionMoveToPreviousThird: _moveToPreviousThirdShortcutMenuItem,
                             SpectacleWindowActionMakeLarger: _makeLargerShortcutMenuItem,
                             SpectacleWindowActionMakeSmaller: _makeSmallerShortcutMenuItem,
                             SpectacleWindowActionUndoLastMove: _undoLastMoveShortcutMenuItem,
                             SpectacleWindowActionRedoLastMove: _redoLastMoveShortcutMenuItem};

  [self registerShortcuts];

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
                         selector:@selector(updateShortcutMenuItems)
                             name:SpectacleShortcutChangedNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(updateShortcutMenuItems)
                             name:SpectacleRestoreDefaultShortcutsNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(menuDidSendAction:)
                             name:NSMenuDidSendActionNotification
                           object:nil];

  [SUUpdater.sharedUpdater setAutomaticallyChecksForUpdates:automaticallyChecksForUpdates];

  [self updateShortcutMenuItems];

  switch (SpectacleUtilities.spectacleTrust) {
    case SpectacleIsNotTrusted:
      [[NSApplication sharedApplication] runModalForWindow:self.accessiblityAccessDialogWindow];

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
  [self.preferencesController showWindow:sender];
}

#pragma mark -

- (IBAction)openSystemPreferences:(id)sender
{
  NSURL *preferencePaneURL = [NSURL fileURLWithPath:[SpectacleUtilities pathForPreferencePaneNamed:SpectacleSecurityPreferencePaneName]];
  NSBundle *applicationBundle = NSBundle.mainBundle;
  NSURL *scriptURL = [applicationBundle URLForResource:SpectacleSecurityAndPrivacyPreferencesScriptName
                                         withExtension:SpectacleAppleScriptFileExtension];

  [NSApplication.sharedApplication stopModal];

  [self.accessiblityAccessDialogWindow orderOut:self];

  if (![[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:nil] executeAndReturnError:nil]) {
    [NSWorkspace.sharedWorkspace openURL:preferencePaneURL];
  }
}

#pragma mark -

- (IBAction)restoreDefaults:(id)sender
{
  [SpectacleUtilities displayRestoreDefaultsAlertWithCallback:^(BOOL isConfirmed) {
    if (isConfirmed) {
      [SpectacleUtilities restoreDefaultShortcuts];

      [NSNotificationCenter.defaultCenter postNotificationName:SpectacleRestoreDefaultShortcutsNotification
                                                        object:self];
    }
  }];
}

#pragma mark -

- (void)createStatusItem
{
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

  NSImage *statusImage = [NSBundle.mainBundle imageForResource:SpectacleStatusItemIcon];

  [statusImage setTemplate:YES];

  self.statusItem.image = statusImage;
  self.statusItem.highlightMode = YES;
  self.statusItem.toolTip = [NSString stringWithFormat:@"Spectacle %@", SpectacleUtilities.applicationVersion];

  [self.statusItem setMenu:self.statusItemMenu];
}

- (void)destroyStatusItem
{
  [NSStatusBar.systemStatusBar removeStatusItem:self.statusItem];
}

#pragma mark -

- (void)updateShortcutMenuItems
{
  SpectacleShortcutManager *shortcutManager = SpectacleShortcutManager.sharedManager;
  SpectacleShortcutTranslator *shortcutTranslator = SpectacleShortcutTranslator.sharedTranslator;

  for (NSString *shortcutName in self.shortcutMenuItems.allKeys) {
    NSMenuItem *shortcutMenuItem = self.shortcutMenuItems[shortcutName];
    SpectacleShortcut *shortcut = [shortcutManager registeredShortcutForName:shortcutName];

    if (shortcut) {
      shortcutMenuItem.keyEquivalent = [[shortcutTranslator translateKeyCode:shortcut.shortcutCode] lowercaseString];
      shortcutMenuItem.keyEquivalentModifierMask = [SpectacleShortcutTranslator convertModifiersToCocoaIfNecessary:shortcut.shortcutModifiers];
    } else {
      shortcutMenuItem.keyEquivalent = @"";
      shortcutMenuItem.keyEquivalentModifierMask = 0;
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

@end
