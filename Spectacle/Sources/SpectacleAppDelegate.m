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
@property (nonatomic) NSTimer *disableShortcutsForAnHourTimer;
@property (nonatomic) NSSet *blacklistedApplications;
@property (nonatomic) NSMutableSet *disabledApplications;
@property (nonatomic) BOOL shortcutsAreDisabledForAnHour;

@end

#pragma mark -

@implementation SpectacleAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;

  [notificationCenter addObserver:self
                         selector:@selector(enableStatusItem)
                             name:kStatusItemEnabledNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(disableStatusItem)
                             name:kStatusItemDisabledNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(updateShortcutMenuItems)
                             name:kShortcutChangedNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(updateShortcutMenuItems)
                             name:kRestoreDefaultShortcutsNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(menuDidSendAction:)
                             name:NSMenuDidSendActionNotification
                           object:nil];

  NSNotificationCenter *workspaceNotificationCenter = NSWorkspace.sharedWorkspace.notificationCenter;

  [workspaceNotificationCenter addObserver:self
                                  selector:@selector(applicationDidActivate:)
                                      name:NSWorkspaceDidActivateApplicationNotification
                                    object:nil];

  [workspaceNotificationCenter addObserver:self
                                  selector:@selector(applicationDidDeactivate:)
                                      name:NSWorkspaceDidDeactivateApplicationNotification
                                    object:nil];

  [SpectacleUtilities registerDefaultsForBundle:NSBundle.mainBundle];

  self.shortcutMenuItems = @{kWindowActionMoveToCenter: _moveToCenterShortcutMenuItem,
                             kWindowActionMoveToFullscreen: _moveToFullscreenShortcutMenuItem,
                             kWindowActionMoveToLeftHalf: _moveToLeftShortcutMenuItem,
                             kWindowActionMoveToRightHalf: _moveToRightShortcutMenuItem,
                             kWindowActionMoveToTopHalf: _moveToTopShortcutMenuItem,
                             kWindowActionMoveToBottomHalf: _moveToBottomShortcutMenuItem,
                             kWindowActionMoveToUpperLeft: _moveToUpperLeftShortcutMenuItem,
                             kWindowActionMoveToLowerLeft: _moveToLowerLeftShortcutMenuItem,
                             kWindowActionMoveToUpperRight: _moveToUpperRightShortcutMenuItem,
                             kWindowActionMoveToLowerRight: _moveToLowerRightShortcutMenuItem,
                             kWindowActionMoveToNextDisplay: _moveToNextDisplayShortcutMenuItem,
                             kWindowActionMoveToPreviousDisplay: _moveToPreviousDisplayShortcutMenuItem,
                             kWindowActionMoveToNextThird: _moveToNextThirdShortcutMenuItem,
                             kWindowActionMoveToPreviousThird: _moveToPreviousThirdShortcutMenuItem,
                             kWindowActionMakeLarger: _makeLargerShortcutMenuItem,
                             kWindowActionMakeSmaller: _makeSmallerShortcutMenuItem,
                             kWindowActionUndoLastMove: _undoLastMoveShortcutMenuItem,
                             kWindowActionRedoLastMove: _redoLastMoveShortcutMenuItem};

  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;

  self.blacklistedApplications = [NSSet setWithArray:[userDefaults objectForKey:kBlacklistedApplicationsPreference]];
  self.disabledApplications = [NSMutableSet setWithArray:[userDefaults objectForKey:kDisabledApplicationsPreference]];

  self.shortcutStorage = [SpectacleShortcutUserDefaultsStorage new];
  self.shortcutManager = [[SpectacleShortcutManager alloc] initWithShortcutStorage:self.shortcutStorage];
  self.windowPositionManager = [SpectacleWindowPositionManager new];
  self.preferencesController = [[SpectaclePreferencesController alloc] initWithShortcutManager:self.shortcutManager
                                                                         windowPositionManager:self.windowPositionManager
                                                                               shortcutStorage:self.shortcutStorage];

  self.shortcutsAreDisabledForAnHour = NO;

  [self registerShortcuts];

  [self disableShortcutsIfFrontmostApplicationIsBlacklistedOrDisabled];

  BOOL automaticallyChecksForUpdates = [userDefaults boolForKey:kAutomaticUpdateCheckEnabledPreference];
  BOOL statusItemEnabled = [userDefaults boolForKey:kStatusItemEnabledPreference];

  if (statusItemEnabled) {
    [self enableStatusItem];
  }

  [SUUpdater.sharedUpdater setAutomaticallyChecksForUpdates:automaticallyChecksForUpdates];

  [self updateShortcutMenuItems];

  if (!AXIsProcessTrustedWithOptions(NULL)) {
    [[NSApplication sharedApplication] runModalForWindow:self.accessiblityAccessDialogWindow];
  }
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

- (IBAction)disableOrEnableShortcutsForAnHour:(id)sender
{
  NSInteger newMenuItemState = NSMixedState;

  if (self.shortcutsAreDisabledForAnHour) {
    self.shortcutsAreDisabledForAnHour = NO;

    [self.disableShortcutsForAnHourTimer invalidate];

    [self enableShortcutsIfPermitted];

    newMenuItemState = NSOffState;
  } else {
    self.shortcutsAreDisabledForAnHour = YES;

    self.disableShortcutsForAnHourTimer = [NSTimer scheduledTimerWithTimeInterval:3600
                                                                           target:self
                                                                         selector:@selector(disableOrEnableShortcutsForAnHour:)
                                                                         userInfo:nil
                                                                          repeats:NO];

    [self.shortcutManager disableShortcuts];

    newMenuItemState = NSOnState;
  }

  self.disableShortcutsForAnHourMenuItem.state = newMenuItemState;
}

- (IBAction)disableOrEnableShortcutsForApplication:(id)sender
{
  NSRunningApplication *frontmostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;

  if ([self.disabledApplications containsObject:frontmostApplication.bundleIdentifier]) {
    [self.disabledApplications removeObject:frontmostApplication.bundleIdentifier];

    [self enableShortcutsIfPermitted];

    self.disableShortcutsForApplicationMenuItem.state = NSOffState;
  } else {
    [self.disabledApplications addObject:frontmostApplication.bundleIdentifier];

    [self.shortcutManager disableShortcuts];

    self.disableShortcutsForApplicationMenuItem.state = NSOnState;
  }

  [NSUserDefaults.standardUserDefaults setObject:self.disabledApplications.allObjects
                                          forKey:kDisabledApplicationsPreference];
}

#pragma mark -

- (IBAction)openSystemPreferences:(id)sender
{
  NSURL *preferencePaneURL = [NSURL fileURLWithPath:[SpectacleUtilities pathForPreferencePaneNamed:kSecurityPreferencePaneName]];
  NSBundle *applicationBundle = NSBundle.mainBundle;
  NSURL *scriptURL = [applicationBundle URLForResource:kSecurityAndPrivacyPreferencesScriptName
                                         withExtension:kAppleScriptFileExtension];

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

  NSImage *statusImage = [NSBundle.mainBundle imageForResource:kStatusItemIcon];

  [statusImage setTemplate:YES];

  self.statusItem.highlightMode = YES;
  self.statusItem.image = statusImage;
  self.statusItem.menu = self.statusItemMenu;
  self.statusItem.toolTip = [@"Spectacle " stringByAppendingString:SpectacleUtilities.applicationVersion];
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

- (void)enableShortcutsIfPermitted
{
  NSRunningApplication *frontmostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;

  // Do not enable shortcuts if they should remain disabled for an hour.
  if (self.shortcutsAreDisabledForAnHour) return;

  // Do not enable shortcuts if the application is blacklisted or disabled.
  if ([self.blacklistedApplications containsObject:frontmostApplication.bundleIdentifier]
      || [self.disabledApplications containsObject:frontmostApplication.bundleIdentifier]) {
    return;
  }

  [self.shortcutManager enableShortcuts];
}

- (void)disableShortcutsIfFrontmostApplicationIsBlacklistedOrDisabled
{
  NSRunningApplication *frontmostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;

  // Do not disable shortcuts if the application is not blacklisted or disabled.
  if (![self.blacklistedApplications containsObject:frontmostApplication.bundleIdentifier]
      && ![self.disabledApplications containsObject:frontmostApplication.bundleIdentifier]) {
    return;
  }

  [self.shortcutManager disableShortcuts];
}

#pragma mark -

- (void)applicationDidActivate:(NSNotification *)notification
{
  NSRunningApplication *application = notification.userInfo[NSWorkspaceApplicationKey];

  if ([self.blacklistedApplications containsObject:application.bundleIdentifier]
      || [self.disabledApplications containsObject:application.bundleIdentifier]) {
    [self.shortcutManager disableShortcuts];
  }
}

- (void)applicationDidDeactivate:(NSNotification *)notification
{
  NSRunningApplication *application = notification.userInfo[NSWorkspaceApplicationKey];

  if ([self.blacklistedApplications containsObject:application.bundleIdentifier]
      || [self.disabledApplications containsObject:application.bundleIdentifier]) {
    [self enableShortcutsIfPermitted];
  }
}

#pragma mark -

- (void)menuWillOpen:(NSMenu *)menu
{
  NSRunningApplication *frontmostApplication = NSWorkspace.sharedWorkspace.frontmostApplication;

  self.disableShortcutsForApplicationMenuItem.hidden = NO;

  if ([self.blacklistedApplications containsObject:frontmostApplication.bundleIdentifier]) {
    self.disableShortcutsForApplicationMenuItem.hidden = YES;
  } else {
    self.disableShortcutsForApplicationMenuItem.title =
      [NSString stringWithFormat:NSLocalizedString(@"MenuItemTitleDisableShortcutsForApplication", @"The menu item title that displays the application to disable shortcuts for"), frontmostApplication.localizedName];
  }

  if ([self.disabledApplications containsObject:frontmostApplication.bundleIdentifier]) {
    self.disableShortcutsForApplicationMenuItem.state = NSOnState;
  } else {
    self.disableShortcutsForApplicationMenuItem.state = NSOffState;
  }
}

- (void)menuDidSendAction:(NSNotification *)notification
{
  NSMenuItem *menuItem = notification.userInfo[@"MenuItem"];

  if (menuItem.tag == kMenuItemActivateIgnoringOtherApps) {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}

@end
