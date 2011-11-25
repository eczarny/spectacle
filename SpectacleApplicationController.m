#import "SpectacleApplicationController.h"
#import "SpectacleUtilities.h"

@implementation SpectacleApplicationController

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    [SpectacleUtilities registerDefaultsForBundle: [SpectacleUtilities helperApplicationBundle]];
    
    if (!AXAPIEnabled()) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        NSURL *preferencePaneURL = [NSURL fileURLWithPath: [SpectacleUtilities pathForPreferencePaneNamed: @"UniversalAccessPref"]];
        
        [alert setAlertStyle: NSWarningAlertStyle];
        [alert setMessageText: ZeroKitLocalizedString(@"Spectacle requires that the Accessibility API be enabled")];
        [alert setInformativeText: ZeroKitLocalizedString(@"Would you like to open the Universal Access preferences so that you can turn on \"Enable access for assistive devices\"?")];
        [alert addButtonWithTitle: ZeroKitLocalizedString(@"Open Universal Access Preferences")];
        [alert addButtonWithTitle: ZeroKitLocalizedString(@"Stop Spectacle")];
        
        switch ([alert runModal]) {
            case NSAlertFirstButtonReturn:
                [[NSWorkspace sharedWorkspace] openURL: preferencePaneURL];
                
                break;
            case NSAlertSecondButtonReturn:
            default:
                break;
        }
        
        [[NSApplication sharedApplication] terminate: self];
        
        return;
    }
    
    [self registerHotKeys];
}

@end
