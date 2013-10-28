#import <Foundation/Foundation.h>
#import "SpectacleWindowActionController.h"

@class SpectaclePreferencesController;

@interface SpectacleApplicationController : SpectacleWindowActionController

@property (nonatomic) IBOutlet NSMenu *statusItemMenu;
@property (nonatomic) IBOutlet NSWindow *accessiblityAccessDialogWindow;

# pragma mark -

- (IBAction)showPreferencesWindow: (id)sender;

# pragma mark -

- (IBAction)openSystemPreferences: (id)sender;

@end
