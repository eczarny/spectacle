#import <Cocoa/Cocoa.h>
#import "SpectacleWindowActionController.h"

@interface SpectacleApplicationController : SpectacleWindowActionController {
    NSStatusItem *myStatusItem;
}

- (IBAction)togglePreferencesWindow: (id)sender;

@end
