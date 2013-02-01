#import <Foundation/Foundation.h>
#import "SpectacleWindowActionController.h"

@class SpectaclePreferencesController;

@interface SpectacleApplicationController : SpectacleWindowActionController {
    IBOutlet NSMenu *statusItemMenu;
    NSStatusItem *statusItem;
    SpectaclePreferencesController *preferencesController;
    
}

- (IBAction)showPreferencesWindow: (id)sender;

@end
