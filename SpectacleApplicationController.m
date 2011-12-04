#import "SpectacleApplicationController.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleApplicationController (SpectacleApplicationControllerPrivate)

- (NSMenu *)statusItemMenu;

#pragma mark -

- (void)refreshStatusMenu;

#pragma mark -

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
    
    if (!AXAPIEnabled()) {
        [SpectacleUtilities displayAccessibilityAPIAlert];
        
        [[NSApplication sharedApplication] terminate: self];
        
        return;
    }
    
    [SpectacleUtilities registerDefaultsForBundle: [SpectacleUtilities applicationBundle]];
    
    [self registerHotKeys];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey: SpectacleStatusItemEnabledPreference]) {
        [self createStatusItem];
    }
}

#pragma mark -

- (IBAction)togglePreferencesWindow: (id)sender {
    [[ZeroKitPreferencesWindowController sharedController] togglePreferencesWindow: sender];
}

@end

#pragma mark -

@implementation SpectacleApplicationController (SpectacleApplicationControllerPrivate)

- (NSMenu *)statusItemMenu {
    NSMenu *statusItemMenu = [[[NSMenu alloc] init] autorelease];
    
    [statusItemMenu addItemWithTitle: ZeroKitLocalizedString(@"Preferences...") action: @selector(togglePreferencesWindow:) keyEquivalent: @""];
    
    [statusItemMenu addItem: [NSMenuItem separatorItem]];
    
    [statusItemMenu addItemWithTitle: ZeroKitLocalizedString(@"Quit Spectacle") action: @selector(terminate:) keyEquivalent: @""];
    
    return statusItemMenu;
}

#pragma mark -

- (void)refreshStatusMenu {
    NSString *applicationVersion = [SpectacleUtilities standaloneApplicationVersion];
    
    if (applicationVersion) {
        [myStatusItem setToolTip: [NSString stringWithFormat: @"Spectacle %@", applicationVersion]];
    } else {
        [myStatusItem setToolTip: @"Spectacle"];
    }
    
    [myStatusItem setMenu: [self statusItemMenu]];
}

#pragma mark -

- (void)createStatusItem {
    myStatusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    
    [myStatusItem setTitle: @"sP"];
    [myStatusItem setHighlightMode: YES];
    
    [self refreshStatusMenu];
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
