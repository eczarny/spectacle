#import "SpectacleHelperApplicationController.h"
#import "SpectacleHelperController.h"
#import "SpectaclePreferencePaneUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleHelperApplicationController (SpectacleHelperApplicationControllerPrivate)

- (void)terminateHelperApplication;

#pragma mark -

- (void)vendHelperController;

@end

#pragma mark -

@implementation SpectacleHelperApplicationController

- (id)init {
    if (self = [super init]) {
        myVendedHelperControllerConnection = nil;
    }
    
    return self;
}

#pragma mark -

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    NSDistributedNotificationCenter *distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
    
    [distributedNotificationCenter addObserver: self
                                      selector: @selector(terminateHelperApplication)
                                          name: SpectacleHelperShouldTerminateNotification
                                        object: nil
                            suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    
    [SpectaclePreferencePaneUtilities registerDefaultsForBundle: [SpectaclePreferencePaneUtilities helperApplicationBundle]];
    
    [self vendHelperController];
    
    if (!AXAPIEnabled()) {
        [SpectaclePreferencePaneUtilities displayAccessibilityAPIAlert];
        
        [[NSApplication sharedApplication] terminate: self];
        
        return;
    }
    
    [self registerHotKeys];
    
    [distributedNotificationCenter postNotificationName: SpectacleHelperDidFinishLaunchingNotification
                                                 object: nil
                                               userInfo: nil
                                     deliverImmediately: YES];
}

#pragma mark -

- (void)applicationWillTerminate: (NSNotification *)notification {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName: SpectacleHelperDidTerminateNotification
                                                                   object: nil
                                                                 userInfo: nil
                                                       deliverImmediately: YES];
}

#pragma mark -

- (void)dealloc {
    [myVendedHelperControllerConnection release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleHelperApplicationController (SpectacleHelperApplicationControllerPrivate)

- (void)terminateHelperApplication {
    [[NSApplication sharedApplication] terminate: self];
}

#pragma mark -

- (void)vendHelperController {
    if (myVendedHelperControllerConnection) {
        [myVendedHelperControllerConnection release];
        
        myVendedHelperControllerConnection = nil;
    }
    
    myVendedHelperControllerConnection = [NSConnection serviceConnectionWithName: SpectacleHelperControllerServiceName rootObject: myHelperController];
    
    if (!myVendedHelperControllerConnection) {
        NSLog(@"Unable to vend the helper controller.");
    } else {
        [myVendedHelperControllerConnection retain];
    }
}

@end
