#import <Foundation/Foundation.h>
#import "SpectacleWindowActionController.h"

@class SpectaclePreferencesController;

@interface SpectacleApplicationController : SpectacleWindowActionController {
    IBOutlet NSMenu *statusItemMenu;
    IBOutlet NSWindow *accessiblityAccessWindow;
    NSStatusItem *statusItem;
    SpectaclePreferencesController *preferencesController;
}

- (IBAction)showPreferencesWindow: (id)sender;

# pragma mark -

- (IBAction)openSystemPreferences: (id)sender;

@end
