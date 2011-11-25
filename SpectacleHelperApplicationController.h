#import <Cocoa/Cocoa.h>
#import "SpectacleWindowActionController.h"

@class SpectacleHelperController;

@interface SpectacleHelperApplicationController : SpectacleWindowActionController {
    NSConnection *myVendedHelperControllerConnection;
    IBOutlet SpectacleHelperController *myHelperController;
}



@end
