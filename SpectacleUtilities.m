// 
// Copyright (c) 2010 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

#import "SpectacleUtilities.h"
#import "SpectacleHotKey.h"
#import "SpectacleHotKeyAction.h"
#import "SpectacleConstants.h"

@interface SpectacleUtilities (SpectacleUtilitiesPrivate)

+ (NSString *)versionOfBundle: (NSBundle *)bundle;

@end

#pragma mark -

@implementation SpectacleUtilities

+ (NSBundle *)preferencePaneBundle {
    NSString *preferencePanePath = [SpectacleUtilities pathForPreferencePaneNamed: SpectaclePreferencePaneName];
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
    NSBundle *preferencePaneBundle = [SpectacleUtilities preferencePaneBundle];
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
    return [SpectacleUtilities versionOfBundle: [SpectacleUtilities preferencePaneBundle]];
}

+ (NSString *)helperApplicationVersion {
    return [SpectacleUtilities versionOfBundle: [SpectacleUtilities helperApplicationBundle]];
}

#pragma mark -

+ (void)startSpectacle {
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    NSBundle *helperApplicationBundle = [SpectacleUtilities helperApplicationBundle];
    NSURL *helperApplicationURL = nil;
    
    if ([SpectacleUtilities isSpectacleRunning]) {
        NSLog(@"Unable to start the Spectacle helper application as it is already running.");
        
        return;
    }
    
    if (!helperApplicationBundle) {
        NSLog(@"Unable to locate the Spectacle helper application bundle.");
    } else {
        helperApplicationURL = [helperApplicationBundle bundleURL];
        
        [sharedWorkspace launchApplicationAtURL: helperApplicationURL
                                        options: NSWorkspaceLaunchWithoutAddingToRecents
                                  configuration: nil
                                          error: nil];
    }
}

+ (void)stopSpectacle {
    if (![SpectacleUtilities isSpectacleRunning]) {
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

+ (NSArray *)hotKeysFromDictionary: (NSDictionary *)dictionary hotKeyTarget: (id)target {
    NSMutableArray *hotKeys = [NSMutableArray array];
    
    for (NSData *hotKeyData in [dictionary allValues]) {
        SpectacleHotKey *hotKey = [NSKeyedUnarchiver unarchiveObjectWithData: hotKeyData];
        SpectacleHotKeyAction *hotKeyAction = [SpectacleUtilities actionForHotKeyWithName: [hotKey hotKeyName] target: target];
        
        [hotKey setHotKeyAction: hotKeyAction];
        
        [hotKeys addObject: hotKey];
    }
    
    return hotKeys;
}

#pragma mark -

+ (SpectacleHotKeyAction *)actionForHotKeyWithName: (NSString *)name target: (id)target {
    SEL selector = NULL;
    
    if ([name isEqualToString: SpectacleWindowActionMoveToCenter]) {
        selector = @selector(moveFrontMostWindowToCenter:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToFullScreen]) {
        selector = @selector(moveFrontMostWindowToFullScreen:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLeftHalf]) {
        selector = @selector(moveFrontMostWindowToLeftHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToRightHalf]) {
        selector = @selector(moveFrontMostWindowToRightHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToTopHalf]) {
        selector = @selector(moveFrontMostWindowToTopHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToBottomHalf]) {
        selector = @selector(moveFrontMostWindowToBottomHalf:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToUpperLeft]) {
        selector = @selector(moveFrontMostWindowToUpperLeft:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLowerLeft]) {
        selector = @selector(moveFrontMostWindowToLowerLeft:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToUpperRight]) {
        selector = @selector(moveFrontMostWindowToUpperRight:);
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLowerRight]) {
        selector = @selector(moveFrontMostWindowToLowerRight:);
    }
    
    return [SpectacleHotKeyAction hotKeyActionFromTarget: target selector: selector];
}

@end

#pragma mark -

@implementation SpectacleUtilities (SpectacleUtilitiesPrivate)

+ (NSString *)versionOfBundle: (NSBundle *)bundle {
    NSString *bundleVersion = [bundle objectForInfoDictionaryKey: ZeroKitApplicationBundleShortVersionString];
    
    if (!bundleVersion) {
        bundleVersion = [bundle objectForInfoDictionaryKey: ZeroKitApplicationBundleVersion];
    }
    
    return bundleVersion;
}

@end
