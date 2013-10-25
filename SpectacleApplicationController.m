#import "SpectacleApplicationController.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));

@interface SpectacleApplicationController (SpectacleApplicationControllerPrivate)

- (void)createStatusItem;

- (void)destroyStatusItem;

#pragma mark -

- (void)enableStatusItem: (NSNotification *)notification;

- (void)disableStatusItem: (NSNotification *)notification;

#pragma mark -

- (void)menuDidSendAction: (NSNotification *)notification;

@end

#pragma mark -

@implementation SpectacleApplicationController

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [SpectacleUtilities registerDefaultsForBundle: [SpectacleUtilities applicationBundle]];
    
    preferencesController = [SpectaclePreferencesController new];
    
    if (AXIsProcessTrustedWithOptions != NULL) {
        if (!AXIsProcessTrustedWithOptions(NULL)) {
            [accessiblityAccessWindow makeKeyAndOrderFront: self];
        }
    } else {
        if (!AXAPIEnabled()) {
            [SpectacleUtilities displayAccessibilityAPIAlert];
        }
    }
    
    [self registerHotKeys];
    
    [notificationCenter addObserver: self
                           selector: @selector(enableStatusItem:)
                               name: SpectacleStatusItemEnabledNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(disableStatusItem:)
                               name: SpectacleStatusItemDisabledNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(menuDidSendAction:)
                               name: NSMenuDidSendActionNotification
                             object: nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey: SpectacleStatusItemEnabledPreference]) {
        [self createStatusItem];
    }
}

#pragma mark -

- (BOOL)applicationShouldHandleReopen: (NSApplication *)application hasVisibleWindows: (BOOL)visibleWindows {
    [self showPreferencesWindow: self];
    
    return YES;
}

#pragma mark -

- (IBAction)showPreferencesWindow: (id)sender {
    [preferencesController showWindow: sender];
}

#pragma mark -

- (IBAction)openSystemPreferences: (id)sender {
    NSURL *preferencePaneURL = [NSURL fileURLWithPath: [SpectacleUtilities pathForPreferencePaneNamed: @"Security"]];
    
    [[NSWorkspace sharedWorkspace] openURL: preferencePaneURL];
    
    [accessiblityAccessWindow orderOut: self];
}

@end

#pragma mark -

@implementation SpectacleApplicationController (SpectacleApplicationControllerPrivate)

- (void)createStatusItem {
    NSString *applicationVersion = [SpectacleUtilities applicationVersion];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    [statusItem setImage: [SpectacleUtilities imageFromResource: SpectacleStatusItemIcon inBundle: [SpectacleUtilities applicationBundle]]];
    [statusItem setAlternateImage: [SpectacleUtilities imageFromResource: SpectacleAlternateStatusItemIcon inBundle: [SpectacleUtilities applicationBundle]]];
    [statusItem setHighlightMode: YES];
    
    if (applicationVersion) {
        [statusItem setToolTip: [NSString stringWithFormat: @"Spectacle %@", applicationVersion]];
    } else {
        [statusItem setToolTip: @"Spectacle"];
    }
    
    [statusItem setMenu: statusItemMenu];
}

- (void)destroyStatusItem {
    [[NSStatusBar systemStatusBar] removeStatusItem: statusItem];
    
}

#pragma mark -

- (void)enableStatusItem: (NSNotification *)notification {
    [self createStatusItem];
}

- (void)disableStatusItem: (NSNotification *)notification {
    [self destroyStatusItem];
}

#pragma mark -

- (void)menuDidSendAction: (NSNotification *)notification {
    [[NSApplication sharedApplication] activateIgnoringOtherApps: YES];
}

@end
