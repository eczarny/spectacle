#import "SpectacleGeneralPreferencePane.h"
#import "SpectacleUtilities.h"

@implementation SpectacleGeneralPreferencePane

- (void)preferencePaneDidLoad {
    NSInteger loginItemEnabledState = NSOffState;
    
    if ([SpectacleUtilities isLoginItemEnabledForBundle: [SpectacleUtilities applicationBundle]]) {
        loginItemEnabledState = NSOnState;
    }
    
    [myLoginItemEnabled setState: loginItemEnabledState];
    
    [mySpectacleVersionTextField setStringValue: [SpectacleUtilities standaloneApplicationVersion]];
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

@end
