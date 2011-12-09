#import "SpectaclePreferencePaneUtilities.h"
#import "SpectacleConstants.h"

@implementation SpectaclePreferencePaneUtilities

+ (NSBundle *)preferencePaneBundle {
    NSString *preferencePanePath = [SpectaclePreferencePaneUtilities pathForPreferencePaneNamed: SpectaclePreferencePaneName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSBundle *preferencePaneBundle = nil;
    
    if (preferencePanePath && [fileManager fileExistsAtPath: preferencePanePath isDirectory: nil]) {
        preferencePaneBundle = [NSBundle bundleWithPath: preferencePanePath];
    }
    
    if (!preferencePaneBundle) {
        NSLog(@"The preference pane does not exist at path: %@", preferencePanePath);
    }
    
    return preferencePaneBundle;
}

+ (NSBundle *)helperApplicationBundle {
    NSBundle *preferencePaneBundle = [SpectaclePreferencePaneUtilities preferencePaneBundle];
    NSURL *bundleURL = [preferencePaneBundle URLForResource: SpectacleHelperApplicationName withExtension: SpectacleApplicationBundleExtension];
    NSBundle *helperApplicationBundle = nil;
    
    if (preferencePaneBundle && bundleURL) {
        helperApplicationBundle = [NSBundle bundleWithURL: bundleURL];
    } else {
        helperApplicationBundle = [NSBundle mainBundle];
    }
    
    return helperApplicationBundle;
}

#pragma mark -

+ (NSString *)preferencePaneVersion {
    return [SpectaclePreferencePaneUtilities versionOfBundle: [SpectaclePreferencePaneUtilities preferencePaneBundle]];
}

+ (NSString *)helperApplicationVersion {
    return [SpectaclePreferencePaneUtilities versionOfBundle: [SpectaclePreferencePaneUtilities helperApplicationBundle]];
}

#pragma mark -

+ (void)startSpectacle {
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    NSBundle *helperApplicationBundle = [SpectaclePreferencePaneUtilities helperApplicationBundle];
    NSURL *helperApplicationURL = nil;
    
    if ([SpectaclePreferencePaneUtilities isSpectacleRunning]) {
        NSLog(@"Unable to start the Spectacle helper application as it is already running.");
        
        return;
    }
    
    if (!helperApplicationBundle) {
        NSLog(@"Unable to locate the Spectacle helper application bundle.");
    } else {
        helperApplicationURL = [helperApplicationBundle bundleURL];
        
        [sharedWorkspace launchApplicationAtURL: helperApplicationURL
                                        options: NSWorkspaceLaunchWithoutAddingToRecents | NSWorkspaceLaunchAsync
                                  configuration: nil
                                          error: nil];
    }
}

+ (void)stopSpectacle {
    if (![SpectaclePreferencePaneUtilities isSpectacleRunning]) {
        NSLog(@"Unable to stop the Spectacle helper application as it is not running.");
        
        return;
    }
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName: SpectacleHelperShouldTerminateNotification
                                                                   object: nil
                                                                 userInfo: nil
                                                       deliverImmediately: YES];
}

#pragma mark -

+ (BOOL)isSpectacleRunning {
    NSArray *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier: SpectacleHelperBundleIdentifier];
    
    if (runningApplications && ([runningApplications count] > 0)) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

+ (NSImage *)imageFromResource: (NSString *)resource {
    return [SpectaclePreferencePaneUtilities imageFromResource: resource inBundle: [SpectaclePreferencePaneUtilities preferencePaneBundle]];
}

@end
