#import "SpectacleGeneralPreferencePane.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@implementation SpectacleGeneralPreferencePane

- (void)preferencePaneDidLoad {
    NSInteger loginItemEnabledState = NSOffState;
    BOOL isStatusItemEnabled = [[NSUserDefaults standardUserDefaults] boolForKey: SpectacleStatusItemEnabledPreference];
    
    if ([SpectacleUtilities isLoginItemEnabledForBundle: [SpectacleUtilities applicationBundle]]) {
        loginItemEnabledState = NSOnState;
    }
    
    [myLoginItemEnabled setState: loginItemEnabledState];
    
    [mySpectacleVersionTextField setStringValue: [SpectacleUtilities standaloneApplicationVersion]];
    
    [myStatusItemEnabled selectItemWithTag: isStatusItemEnabled ? 0 : 1];
}

#pragma mark -

- (NSString *)name {
    return ZeroKitLocalizedString(@"General");
}

#pragma mark -

- (NSImage *)icon {
    return [SpectacleUtilities imageFromResource: @"General Preferences" inBundle: [SpectacleUtilities applicationBundle]];
}

#pragma mark -

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    return myView;
}

#pragma mark -

- (IBAction)toggleLoginItem: (id)sender {
    NSBundle *applicationBundle = [SpectacleUtilities applicationBundle];

    if ([myLoginItemEnabled state] == NSOnState) {
        [SpectacleUtilities enableLoginItemForBundle: applicationBundle];
    } else{
        [SpectacleUtilities disableLoginItemForBundle: applicationBundle];
    }
}

- (IBAction)toggleStatusItem: (id)sender {
    NSString *notificationName = SpectacleStatusItemEnabledNotification;
    
    if ([[sender selectedItem] tag] != 0) {
        notificationName = SpectacleStatusItemDisabledNotification;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool: ([[sender selectedItem] tag] == 0) forKey: SpectacleStatusItemEnabledPreference];
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationName object: self];
}

@end
