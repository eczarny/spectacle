#import <Sparkle/Sparkle.h>

#import "SpectacleApplicationController.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"
#import "ZKHotKeyTranslator.h"

@interface SpectacleApplicationController ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) NSDictionary *hotKeyMenuItems;
@property (nonatomic) SpectaclePreferencesController *preferencesController;

@end

#pragma mark -

@implementation SpectacleApplicationController

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;

    [SpectacleUtilities registerDefaultsForBundle: NSBundle.mainBundle];

    _preferencesController = [SpectaclePreferencesController new];

    _hotKeyMenuItems = [[NSDictionary alloc] initWithObjectsAndKeys:
        _toggleHotKeysMenuItem,               SpectacleWindowActionToggleHotKeys,
        _moveToCenterHotKeyMenuItem,          SpectacleWindowActionMoveToCenter,
        _moveToFullscreenHotKeyMenuItem,      SpectacleWindowActionMoveToFullscreen,
        _moveToLeftHotKeyMenuItem,            SpectacleWindowActionMoveToLeftHalf,
        _moveToRightHotKeyMenuItem,           SpectacleWindowActionMoveToRightHalf,
        _moveToTopHotKeyMenuItem,             SpectacleWindowActionMoveToTopHalf,
        _moveToBottomHotKeyMenuItem,          SpectacleWindowActionMoveToBottomHalf,
        _moveToUpperLeftHotKeyMenuItem,       SpectacleWindowActionMoveToUpperLeft,
        _moveToLowerLeftHotKeyMenuItem,       SpectacleWindowActionMoveToLowerLeft,
        _moveToUpperRightHotKeyMenuItem,      SpectacleWindowActionMoveToUpperRight,
        _moveToLowerRightHotKeyMenuItem,      SpectacleWindowActionMoveToLowerRight,
        _moveToNextDisplayHotKeyMenuItem,     SpectacleWindowActionMoveToNextDisplay,
        _moveToPreviousDisplayHotKeyMenuItem, SpectacleWindowActionMoveToPreviousDisplay,
        _moveToNextThirdHotKeyMenuItem,       SpectacleWindowActionMoveToNextThird,
        _moveToPreviousThirdHotKeyMenuItem,   SpectacleWindowActionMoveToPreviousThird,
        _makeLargerHotKeyMenuItem,            SpectacleWindowActionMakeLarger,
        _makeSmallerHotKeyMenuItem,           SpectacleWindowActionMakeSmaller,
        _undoLastMoveHotKeyMenuItem,          SpectacleWindowActionUndoLastMove,
        _redoLastMoveHotKeyMenuItem,          SpectacleWindowActionRedoLastMove, nil];

    [self registerHotKeys];

    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    BOOL automaticallyChecksForUpdates = [userDefaults boolForKey: SpectacleAutomaticUpdateCheckEnabledPreference];
    BOOL statusItemEnabled = [userDefaults boolForKey: SpectacleStatusItemEnabledPreference];

    if (statusItemEnabled) {
        [self createStatusItem];
    }

    [notificationCenter addObserver: self
                           selector: @selector(enableStatusItem)
                               name: SpectacleStatusItemEnabledNotification
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(disableStatusItem)
                               name: SpectacleStatusItemDisabledNotification
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(updateHotKeyMenuItems)
                               name: SpectacleHotKeyChangedNotification
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(updateHotKeyMenuItems)
                               name: SpectacleRestoreDefaultHotKeysNotification
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(menuDidSendAction:)
                               name: NSMenuDidSendActionNotification
                             object: nil];

    [SUUpdater.sharedUpdater setAutomaticallyChecksForUpdates: automaticallyChecksForUpdates];

    [self updateHotKeyMenuItems];

    switch (SpectacleUtilities.spectacleTrust) {
        case SpectacleIsNotTrustedBeforeMavericks:
            [SpectacleUtilities displayAccessibilityAPIAlert];

            break;
        case SpectacleIsNotTrustedOnOrAfterMavericks:
            [[NSApplication sharedApplication] runModalForWindow: _accessiblityAccessDialogWindow];

            break;
        default:
            break;
    }
}

#pragma mark -

- (BOOL)applicationShouldHandleReopen: (NSApplication *)application hasVisibleWindows: (BOOL)visibleWindows {
    [self showPreferencesWindow: self];

    return YES;
}

#pragma mark -

- (IBAction)showPreferencesWindow: (id)sender {
    [_preferencesController showWindow: sender];
}

#pragma mark -

- (IBAction)openSystemPreferences: (id)sender {
    NSURL *preferencePaneURL = [NSURL fileURLWithPath: [SpectacleUtilities pathForPreferencePaneNamed: SpectacleSecurityPreferencePaneName]];
    NSBundle *applicationBundle = NSBundle.mainBundle;
    NSURL *scriptURL = [applicationBundle URLForResource: SpectacleSecurityAndPrivacyPreferencesScriptName withExtension: SpectacleAppleScriptFileExtension];

    [NSApplication.sharedApplication stopModal];

    [_accessiblityAccessDialogWindow orderOut: self];

    if (![[[NSAppleScript alloc] initWithContentsOfURL: scriptURL error: nil] executeAndReturnError: nil]) {
        [NSWorkspace.sharedWorkspace openURL: preferencePaneURL];
    }
}

#pragma mark -

- (IBAction)restoreDefaults: (id)sender {
    [SpectacleUtilities displayRestoreDefaultsAlertWithCallback: ^(BOOL isConfirmed) {
        if (isConfirmed) {
            [SpectacleUtilities restoreDefaultHotKeys];

            [NSNotificationCenter.defaultCenter postNotificationName: SpectacleRestoreDefaultHotKeysNotification object: self];
        }
    }];
}

#pragma mark -

- (void)createStatusItem {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];

    _statusItem.image = [[NSImage alloc] initWithContentsOfFile: [NSBundle.mainBundle pathForImageResource: SpectacleStatusItemIcon]];
    _statusItem.alternateImage = [[NSImage alloc] initWithContentsOfFile: [NSBundle.mainBundle pathForImageResource: SpectacleAlternateStatusItemIcon]];
    _statusItem.highlightMode = YES;

    _statusItem.toolTip = [NSString stringWithFormat: @"Spectacle %@", SpectacleUtilities.applicationVersion];

    [_statusItem setMenu: _statusItemMenu];
}

- (void)destroyStatusItem {
    [NSStatusBar.systemStatusBar removeStatusItem: _statusItem];
}

#pragma mark -

- (void)updateHotKeyMenuItems {
    SpectacleHotKeyManager *hotKeyManager = SpectacleHotKeyManager.sharedManager;
    ZKHotKeyTranslator *hotKeyTranslator = ZKHotKeyTranslator.sharedTranslator;
    for (NSString *hotKeyName in _hotKeyMenuItems.allKeys) {
        NSMenuItem *hotKeyMenuItem = _hotKeyMenuItems[hotKeyName];
        ZKHotKey *hotKey = [hotKeyManager registeredHotKeyForName: hotKeyName];
        if (hotKey) {
            hotKeyMenuItem.keyEquivalent = [[hotKeyTranslator translateKeyCode: hotKey.hotKeyCode] lowercaseString];
            hotKeyMenuItem.keyEquivalentModifierMask = [ZKHotKeyTranslator convertModifiersToCocoafNecessary: hotKey.hotKeyModifiers];
        } else {
            hotKeyMenuItem.keyEquivalent = @"";
            hotKeyMenuItem.keyEquivalentModifierMask = 0;
        }
    }
}

#pragma mark -

- (void)enableStatusItem {
    [self createStatusItem];
}

- (void)disableStatusItem {
    [self destroyStatusItem];
}

#pragma mark -

- (void)menuDidSendAction: (NSNotification *)notification {
    NSMenuItem *menuItem = [notification.userInfo objectForKey: @"MenuItem"];

    if (menuItem.tag == SpectacleMenuItemActivateIgnoringOtherApps) {
        [NSApplication.sharedApplication activateIgnoringOtherApps: YES];
    }
}

@end
