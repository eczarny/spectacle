#import <Cocoa/Cocoa.h>
#import "SpectacleWindowActionController.h"

@interface SpectacleApplicationController : SpectacleWindowActionController {
    IBOutlet NSMenu *myStatusItemMenu;
    NSStatusItem *myStatusItem;
}

- (IBAction)togglePreferencesWindow: (id)sender;

@end
