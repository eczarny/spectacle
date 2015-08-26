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
@property (nonatomic) NSMutableSet *disabledApplications;

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

  NSString *blacklistedApplicationsPath = [NSBundle.mainBundle pathForResource:SpectacleBlacklistedApplicationsPropertyListFile
                                                                        ofType:SpectaclePropertyListFileExtension];

  NSSet *blacklistedApplications = [NSSet setWithArray:[NSArray arrayWithContentsOfFile:blacklistedApplicationsPath]];

  self.windowPositionManager = [[SpectacleWindowPositionManager alloc] initWithBlacklistedApplications:blacklistedApplications];

  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;

  NSArray *disabledApplicationsArray = [userDefaults objectForKey:SpectacleDisabledApplicationsPreference];

  self.disabledApplications = [NSMutableSet setWithArray:disabledApplicationsArray];

  self.preferencesController = [[SpectaclePreferencesController alloc] initWithShortcutManager:self.shortcutManager
                                                                         windowPositionManager:self.windowPositionManager
                                                                               shortcutStorage:self.shortcutStorage
                                                                          disabledApplications:self.disabledApplications];

  [self registerShortcuts];

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
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionFullscreen
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToCenter:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionCenter
                                             disabledApplications:self.disabledApplications];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLeftHalf
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToRightHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionRightHalf
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToTopHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionTopHalf
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToBottomHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionBottomHalf
                                             disabledApplications:self.disabledApplications];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionUpperLeft
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToLowerLeft:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLowerLeft
                                             disabledApplications:self.disabledApplications];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionUpperRight
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToLowerRight:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLowerRight
                                             disabledApplications:self.disabledApplications];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionNextDisplay
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToPreviousDisplay:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionPreviousDisplay
                                             disabledApplications:self.disabledApplications];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionNextThird
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)moveFrontMostWindowToPreviousThird:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionPreviousThird
                                             disabledApplications:self.disabledApplications];
}

#pragma mark -

- (IBAction)makeFrontMostWindowLarger:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionLarger
                                             disabledApplications:self.disabledApplications];
}

- (IBAction)makeFrontMostWindowSmaller:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithWindowAction:SpectacleWindowActionSmaller
                                             disabledApplications:self.disabledApplications];
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

  switch (self.disableShortcutsForAnHourMenuItem.state) {
    case NSOnState:
      [self.shortcutManager enableShortcuts];

      [self.disableShortcutsForAnHourTimer invalidate];

      newMenuItemState = NSOffState;
      break;
    case NSOffState:
      [self.shortcutManager disableShortcuts];

      SEL selector = @selector(disableOrEnableShortcutsForAnHour:);

      self.disableShortcutsForAnHourTimer = [NSTimer scheduledTimerWithTimeInterval:3600
                                                                             target:self
                                                                           selector:selector
                                                                           userInfo:nil
                                                                            repeats:NO];

      newMenuItemState = NSOnState;

      break;
    default:
      break;
  }

  self.disableShortcutsForAnHourMenuItem.state = newMenuItemState;
}

- (IBAction)disableOrEnableShortcutsForApplication:(id)sender
{
  NSString *frontmostApplicationBundleIdentifier = NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier;
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;

  if ([self.disabledApplications containsObject:frontmostApplicationBundleIdentifier]) {
    [self.disabledApplications removeObject:frontmostApplicationBundleIdentifier];

    self.disableShortcutsForApplicationMenuItem.state = NSOffState;
  } else {
    [self.disabledApplications addObject:frontmostApplicationBundleIdentifier];

    self.disableShortcutsForApplicationMenuItem.state = NSOnState;
  }

  [userDefaults setObject:[self.disabledApplications allObjects] forKey:SpectacleDisabledApplicationsPreference];
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

    [self.windowPositionManager moveFrontMostWindowWithWindowAction:windowAction
                                               disabledApplications:self.disabledApplications];
  }];

  [self.shortcutManager registerShortcuts:shortcuts];
}

#pragma mark -

- (void)enableStatusItem
{
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

  NSImage *statusImage = [NSBundle.mainBundle imageForResource:SpectacleStatusItemIcon];

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

- (void)menuWillOpen:(NSMenu *)menu
{
  NSString *frontmostApplicationLocalizedName = NSWorkspace.sharedWorkspace.frontmostApplication.localizedName;
  NSString *frontmostApplicationBundleIdentifier = NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier;

  self.disableShortcutsForApplicationMenuItem.hidden = NO;

  if (!frontmostApplicationLocalizedName) {
    self.disableShortcutsForApplicationMenuItem.hidden = YES;
  } else {
    self.disableShortcutsForApplicationMenuItem.title = [@"for " stringByAppendingString:frontmostApplicationLocalizedName];
  }

  if ([self.disabledApplications containsObject:frontmostApplicationBundleIdentifier]) {
    self.disableShortcutsForApplicationMenuItem.state = NSOnState;
  } else {
    self.disableShortcutsForApplicationMenuItem.state = NSOffState;
  }
}

- (void)menuDidSendAction:(NSNotification *)notification
{
  NSMenuItem *menuItem = (notification.userInfo)[@"MenuItem"];

  if (menuItem.tag == SpectacleMenuItemActivateIgnoringOtherApps) {
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
  }
}

@end
