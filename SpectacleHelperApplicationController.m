#import "SpectacleHelperApplicationController.h"
#import "SpectacleHelperController.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleHelperApplicationController (SpectacleHelperApplicationControllerPrivate)

- (void)terminateHelperApplication;

#pragma mark -

- (void)vendHelperController;

#pragma mark -

- (void)setUpSparkle;

#pragma mark -

- (NSString *)pathToRelaunchForUpdater: (SUUpdater *)updater;

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
    
    [SpectacleUtilities registerDefaultsForBundle: [SpectacleUtilities helperApplicationBundle]];
    
    [self vendHelperController];
    
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
    
    [self setUpSparkle];
    
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

#pragma mark -

- (void)setUpSparkle {
    SUUpdater *sparkleUpdater = [SUUpdater updaterForBundle: [SpectacleUtilities preferencePaneBundle]];
    
    if (sparkleUpdater) {
        [sparkleUpdater setDelegate: self];
        
        if ([sparkleUpdater automaticallyChecksForUpdates]) {
            [sparkleUpdater checkForUpdatesInBackground];
            
            [sparkleUpdater resetUpdateCycle];
        }
    } else {
        NSLog(@"Spectacle could not set up Sparkle.");
    }
}

#pragma mark -

- (NSString *)pathToRelaunchForUpdater: (SUUpdater *)updater {
    return [[SpectacleUtilities helperApplicationBundle] bundlePath];
}

@end
