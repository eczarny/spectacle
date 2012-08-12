#import <Foundation/Foundation.h>
#import "SpectacleWindowActionController.h"

@class SpectaclePreferencesController;

@interface SpectacleApplicationController : SpectacleWindowActionController {
    IBOutlet NSMenu *myStatusItemMenu;
    NSStatusItem *myStatusItem;
    SpectaclePreferencesController *myPreferencesController;
    
}

- (IBAction)showPreferencesWindow: (id)sender;

@end
