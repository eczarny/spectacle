#import "SpectacleApplicationController.h"
#import "SpectaclePreferencesController.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleApplicationController ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) SpectaclePreferencesController *preferencesController;

@end

#pragma mark -

@implementation SpectacleApplicationController

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    
    [SpectacleUtilities registerDefaultsForBundle: SpectacleUtilities.applicationBundle];
    
    _preferencesController = [SpectaclePreferencesController new];
    
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
    
    if ([NSUserDefaults.standardUserDefaults boolForKey: SpectacleStatusItemEnabledPreference]) {
        [self createStatusItem];
    }
    
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
    NSBundle *applicationBundle = SpectacleUtilities.applicationBundle;
    NSURL *scriptURL = [applicationBundle URLForResource: SpectacleSecurityAndPrivacyPreferencesScriptName withExtension: SpectacleAppleScriptFileExtension];
    
    [NSApplication.sharedApplication stopModal];

    [_accessiblityAccessDialogWindow orderOut: self];
    
    if (![[[NSAppleScript alloc] initWithContentsOfURL: scriptURL error: nil] executeAndReturnError: nil]) {
        [NSWorkspace.sharedWorkspace openURL: preferencePaneURL];
    }
}

#pragma mark -

- (void)createStatusItem {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    _statusItem.image = [SpectacleUtilities imageFromResource: SpectacleStatusItemIcon inBundle: SpectacleUtilities.applicationBundle];
    _statusItem.alternateImage = [SpectacleUtilities imageFromResource: SpectacleAlternateStatusItemIcon inBundle: SpectacleUtilities.applicationBundle];
    _statusItem.highlightMode = YES;
    
    _statusItem.toolTip = [NSString stringWithFormat: @"Spectacle %@", SpectacleUtilities.applicationVersion];
    
    [_statusItem setMenu: _statusItemMenu];
}

- (void)destroyStatusItem {
    [NSStatusBar.systemStatusBar removeStatusItem: _statusItem];
    
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
    [NSApplication.sharedApplication activateIgnoringOtherApps: YES];
}

@end
