#import <Sparkle/Sparkle.h>

#import "SpectacleAppDelegate.h"
#import "SpectacleConstants.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleShortcutManager.h"
#import "SpectacleShortcutTranslator.h"
#import "SpectacleShortcutUserDefaultsStorage.h"
#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"

@interface SpectacleAppDelegate ()

@property (nonatomic) NSDictionary *shortcutMenuItems;
@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) id<SpectacleShortcutStorageProtocol> shortcutStorage;
@property (nonatomic) SpectacleShortcutManager *shortcutManager;
@property (nonatomic) SpectacleWindowPositionManager *windowPositionManager;
@property (nonatomic) SpectaclePreferencesController *preferencesController;

@end

#pragma mark -

@implementation SpectacleAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;

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

  [SpectacleUtilities registerDefaultsForBundle:NSBundle.mainBundle];

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

  self.shortcutStorage = [SpectacleShortcutUserDefaultsStorage new];
  self.shortcutManager = [[SpectacleShortcutManager alloc] initWithShortcutStorage:self.shortcutStorage];
  self.windowPositionManager = [SpectacleWindowPositionManager new];
  self.preferencesController = [[SpectaclePreferencesController alloc] initWithShortcutManager:self.shortcutManager
                                                                         windowPositionManager:self.windowPositionManager];

  [self registerShortcuts];

  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  BOOL automaticallyChecksForUpdates = [userDefaults boolForKey:SpectacleAutomaticUpdateCheckEnabledPreference];
  BOOL statusItemEnabled = [userDefaults boolForKey:SpectacleStatusItemEnabledPreference];

  if (statusItemEnabled) {
    [self enableStatusItem];
  }

  [SUUpdater.sharedUpdater setAutomaticallyChecksForUpdates:automaticallyChecksForUpdates];

  [self updateShortcutMenuItems];

  if (!AXIsProcessTrustedWithOptions(NULL)) {
    [[NSApplication sharedApplication] runModalForWindow:self.accessiblityAccessDialogWindow];
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

- (IBAction)moveFrontMostWindowToFullscreen:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionFullscreen];
}

- (IBAction)moveFrontMostWindowToCenter:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionCenter];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLeftHalf];
}

- (IBAction)moveFrontMostWindowToRightHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionRightHalf];
}

- (IBAction)moveFrontMostWindowToTopHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionTopHalf];
}

- (IBAction)moveFrontMostWindowToBottomHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionUpperLeft];
}

- (IBAction)moveFrontMostWindowToLowerLeft:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionUpperRight];
}

- (IBAction)moveFrontMostWindowToLowerRight:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLowerRight];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionNextDisplay];
}

- (IBAction)moveFrontMostWindowToPreviousDisplay:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionPreviousDisplay];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionNextThird];
}

- (IBAction)moveFrontMostWindowToPreviousThird:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionPreviousThird];
}

#pragma mark -

- (IBAction)makeFrontMostWindowLarger:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLarger];
}

- (IBAction)makeFrontMostWindowSmaller:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionSmaller];
}

#pragma mark -

- (IBAction)undoLastWindowAction:(id)sender
{
  [self.windowPositionManager undoLastWindowAction];
}

- (IBAction)redoLastWindowAction:(id)sender
{
  [self.windowPositionManager redoLastWindowAction];
}

#pragma mark -

- (IBAction)restoreDefaults:(id)sender
{
  [SpectacleUtilities displayRestoreDefaultsAlertWithConfirmationCallback:^() {
    NSArray *shortcuts = [self.shortcutStorage defaultShortcutsWithAction:^(SpectacleShortcut *shortcut) {
      SpectacleWindowAction windowAction = [self.windowPositionManager windowActionForShortcut:shortcut];

      [self.windowPositionManager moveFrontMostWindowWithWindowAction:windowAction];
    }];

    [self.shortcutManager registerShortcuts:shortcuts];

    [NSNotificationCenter.defaultCenter postNotificationName:SpectacleRestoreDefaultShortcutsNotification
                                                      object:self];
  }];
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

- (void)registerShortcuts
{
  NSArray *shortcuts = [self.shortcutStorage loadShortcutsWithAction:^(SpectacleShortcut *shortcut) {
    SpectacleWindowAction windowAction = [self.windowPositionManager windowActionForShortcut:shortcut];

    [self.windowPositionManager moveFrontMostWindowWithWindowAction:windowAction];
  }];

  [self.shortcutManager registerShortcuts:shortcuts];
}

#pragma mark -

- (void)enableStatusItem
{
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

  NSImage *statusImage = [NSBundle.mainBundle imageForResource:SpectacleStatusItemIcon];

  [statusImage setTemplate:YES];

  self.statusItem.image = statusImage;
  self.statusItem.highlightMode = YES;
  self.statusItem.toolTip = [NSString stringWithFormat:@"Spectacle %@", SpectacleUtilities.applicationVersion];

  [self.statusItem setMenu:self.statusItemMenu];
}

- (void)disableStatusItem
{
  [NSStatusBar.systemStatusBar removeStatusItem:self.statusItem];
}

#pragma mark -

- (void)updateShortcutMenuItems
{
  SpectacleShortcutTranslator *shortcutTranslator = SpectacleShortcutTranslator.sharedTranslator;

  for (NSString *shortcutName in self.shortcutMenuItems.allKeys) {
    NSMenuItem *shortcutMenuItem = self.shortcutMenuItems[shortcutName];
    SpectacleShortcut *shortcut = [self.shortcutManager registeredShortcutForName:shortcutName];

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

- (void)menuDidSendAction:(NSNotification *)notification
{
  NSMenuItem *menuItem = (notification.userInfo)[@"MenuItem"];

  if (menuItem.tag == SpectacleMenuItemActivateIgnoringOtherApps) {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}

@end
