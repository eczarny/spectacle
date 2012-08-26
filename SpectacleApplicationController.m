#import "SpectacleApplicationController.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

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
    
    myPreferencesController = [[SpectaclePreferencesController alloc] initWithApplicationController: self];
    
    if (!AXAPIEnabled()) {
        [SpectacleUtilities displayAccessibilityAPIAlert];
        
        [[NSApplication sharedApplication] terminate: self];
        
        return;
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
    [myPreferencesController showWindow: sender];
}

@end

#pragma mark -

@implementation SpectacleApplicationController (SpectacleApplicationControllerPrivate)

- (void)createStatusItem {
    NSString *applicationVersion = [SpectacleUtilities applicationVersion];
    
    myStatusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    
    [myStatusItem setImage: [SpectacleUtilities imageFromResource: SpectacleStatusItemIcon inBundle: [SpectacleUtilities applicationBundle]]];
    [myStatusItem setAlternateImage: [SpectacleUtilities imageFromResource: SpectacleAlternateStatusItemIcon inBundle: [SpectacleUtilities applicationBundle]]];
    [myStatusItem setHighlightMode: YES];
    
    if (applicationVersion) {
        [myStatusItem setToolTip: [NSString stringWithFormat: @"Spectacle %@", applicationVersion]];
    } else {
        [myStatusItem setToolTip: @"Spectacle"];
    }
    
    [myStatusItem setMenu: myStatusItemMenu];
}

- (void)destroyStatusItem {
    [[NSStatusBar systemStatusBar] removeStatusItem: myStatusItem];
    
    [myStatusItem release];
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
