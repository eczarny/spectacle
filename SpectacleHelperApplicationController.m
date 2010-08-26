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

#import "SpectacleHelperApplicationController.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHelperController.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectacleHelperApplicationController (SpectacleHelperApplicationControllerPrivate)

- (void)terminateHelperApplication;

#pragma mark -

- (void)vendHelperController;

#pragma mark -

- (void)registerHotKeys;

#pragma mark -

- (void)setUpSparkle;

#pragma mark -

- (NSString *)pathToRelaunchForUpdater: (SUUpdater *)updater;

@end

#pragma mark -

@implementation SpectacleHelperApplicationController

- (id)init {
    if (self = [super init]) {
        myWindowPositionManager = [SpectacleWindowPositionManager sharedManager];
        myHotKeyManager = [SpectacleHotKeyManager sharedManager];
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

- (void)moveFrontMostWindowToCenter: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionCenter];
}

#pragma mark -

- (void)moveFrontMostWindowToFullscreen: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionFullscreen];
}

#pragma mark -

- (void)moveFrontMostWindowToLeftHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftHalf];
}

- (void)moveFrontMostWindowToRightHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightHalf];
}

- (void)moveFrontMostWindowToTopHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopHalf];
}

- (void)moveFrontMostWindowToBottomHalf: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (void)moveFrontMostWindowToUpperLeft: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperLeft];
}

- (void)moveFrontMostWindowToLowerLeft: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (void)moveFrontMostWindowToUpperRight: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionUpperRight];
}

- (void)moveFrontMostWindowToLowerRight: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLowerRight];
}

#pragma mark -

- (void)moveFrontMostWindowToLeftDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionLeftDisplay];
}

- (void)moveFrontMostWindowToRightDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionRightDisplay];
}

- (void)moveFrontMostWindowToTopDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionTopDisplay];
}

- (void)moveFrontMostWindowToBottomDisplay: (id)sender {
    [myWindowPositionManager moveFrontMostWindowWithAction: SpectacleWindowActionBottomDisplay];
}

#pragma mark -

- (void)undoLastWindowAction: (id)sender {
    [myWindowPositionManager undoLastWindowAction];
}

- (void)redoLastWindowAction: (id)sender {
    [myWindowPositionManager redoLastWindowAction];
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

- (void)registerHotKeys {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *hotKeysFromUserDefaults = [NSMutableDictionary dictionary];
    
    for (NSString *hotKeyName in [SpectacleUtilities hotKeyNames]) {
        [hotKeysFromUserDefaults setObject: [userDefaults dataForKey: hotKeyName] forKey: hotKeyName];
    }
    
    [myHotKeyManager registerHotKeys: [SpectacleUtilities hotKeysFromDictionary: hotKeysFromUserDefaults hotKeyTarget: self]];
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
