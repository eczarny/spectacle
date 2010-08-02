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

#import "SpectaclePreferencePane.h"
#import "SpectacleHelperControllerProtocol.h"
#import "SpectacleHotKey.h"
#import "SpectacleHotKeyRecorder.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectaclePreferencePane (SpectaclePreferencePanePrivate)

- (void)toggleControlsBasedOnSpectacleRunningState;

#pragma mark -

- (void)helperApplicationDidFinishLaunching;

- (void)helperApplicationWillTerminate;

#pragma mark -

- (void)connectToVendedHelperController;

#pragma mark -

- (void)loadRegisteredHotKeys;

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled;

@end

#pragma mark -

@implementation SpectaclePreferencePane

- (void)mainViewDidLoad {
    NSDistributedNotificationCenter *distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
    
    [distributedNotificationCenter addObserver: self
                                      selector: @selector(helperApplicationDidFinishLaunching)
                                          name: SpectacleHelperDidFinishLaunchingNotification
                                        object: nil
                            suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    
    [distributedNotificationCenter addObserver: self
                                      selector: @selector(helperApplicationWillTerminate)
                                          name: SpectacleHelperWillTerminateNotification
                                        object: nil
                            suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    
    myHotKeyRecorders = [[NSDictionary alloc] initWithObjectsAndKeys:
                         myMoveToCenterHotKeyRecorder,        SpectacleWindowActionMoveToCenter,
                         myMoveToFullscreenHotKeyRecorder,    SpectacleWindowActionMoveToFullScreen,
                         myMoveToLeftHotKeyRecorder,          SpectacleWindowActionMoveToLeftHalf,
                         myMoveToRightHotKeyRecorder,         SpectacleWindowActionMoveToRightHalf,
                         myMoveToTopHotKeyRecorder,           SpectacleWindowActionMoveToTopHalf,
                         myMoveToBottomHotKeyRecorder,        SpectacleWindowActionMoveToBottomHalf,
                         myMoveToUpperLeftHotKeyRecorder,     SpectacleWindowActionMoveToUpperLeft,
                         myMoveToLowerLeftHotKeyRecorder,     SpectacleWindowActionMoveToLowerLeft,
                         myMoveToUpperRightHotKeyRecorder,    SpectacleWindowActionMoveToUpperRight,
                         myMoveToLowerRightHotKeyRecorder,    SpectacleWindowActionMoveToLowerRight,
                         myMoveToLeftDisplayHotKeyRecorder,   SpectacleWindowActionMoveToLeftDisplay,
                         myMoveToRightDisplayHotKeyRecorder,  SpectacleWindowActionMoveToRightDisplay,
                         myMoveToTopDisplayHotKeyRecorder,    SpectacleWindowActionMoveToTopDisplay,
                         myMoveToBottomDisplayHotKeyRecorder, SpectacleWindowActionMoveToBottomDisplay,
                         nil];
    
    [self toggleControlsBasedOnSpectacleRunningState];
    
    [mySpectacleVersionTextField setStringValue: [SpectacleUtilities preferencePaneVersion]];
}

#pragma mark -

- (void)didSelect {
    [self toggleControlsBasedOnSpectacleRunningState];
}

#pragma mark -

- (void)toggleRunningState: (id)sender {
    if ([SpectacleUtilities isSpectacleRunning]) {
        [SpectacleUtilities stopSpectacle];
    } else {
        [SpectacleUtilities startSpectacle];
    }
    
    [myToggleRunningStateButton setEnabled: NO];
}

#pragma mark -

- (void)toggleLoginItem: (id)sender {
    NSBundle *helperApplicationBundle = [SpectacleUtilities helperApplicationBundle];
    
    if ([myLoginItemEnabledButton state] == NSOnState) {
        [SpectacleUtilities enableLoginItemForBundle: helperApplicationBundle];
    } else{
        [SpectacleUtilities disableLoginItemForBundle: helperApplicationBundle];
    }
}

#pragma mark -

- (void)toggleCheckForUpdates: (id)sender {
    [myVendedHelperController setAutomaticallyChecksForUpdates: ![myVendedHelperController automaticallyChecksForUpdates]];
}

#pragma mark -

- (void)hotKeyRecorder: (SpectacleHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (SpectacleHotKey *)hotKey {
    [myVendedHelperController updateHotKeyWithKeyCode: [hotKey keyCode] modifiers: [hotKey modifiers] name: [hotKey hotKeyName]];
}

- (void)hotKeyRecorder: (SpectacleHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (SpectacleHotKey *)hotKey {
    [myVendedHelperController unregisterHotKeyWithName: [hotKey hotKeyName]];
}

#pragma mark -

- (void)dealloc {
    [myVendedHelperController release];
    [myHotKeyRecorders release];
    
    [[NSDistributedNotificationCenter defaultCenter] removeObserver: self];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectaclePreferencePane (SpectaclePreferencePanePrivate)

- (void)toggleControlsBasedOnSpectacleRunningState {
    NSInteger loginItemEnabledState = [SpectacleUtilities isLoginItemEnabledForBundle: [SpectacleUtilities helperApplicationBundle]] ? NSOnState : NSOffState;
    
    [myLoginItemEnabledButton setState: loginItemEnabledState];
    
    if ([SpectacleUtilities isSpectacleRunning]) {
        [myStatusTextField setStringValue: ZeroKitLocalizedStringFromCurrentBundle(@"Spectacle is running")];
        
        [myToggleRunningStateButton setTitle: ZeroKitLocalizedStringFromCurrentBundle(@"Stop")];
        
        [self connectToVendedHelperController];
    } else {
        [myAutomaticallyChecksForUpdatesButton setEnabled: NO];
        
        [self enableHotKeyRecorders: NO];
    }
}

#pragma mark -

- (void)helperApplicationDidFinishLaunching {
    [myStatusTextField setStringValue: ZeroKitLocalizedStringFromCurrentBundle(@"Spectacle is running")];
    
    [myToggleRunningStateButton setTitle: ZeroKitLocalizedStringFromCurrentBundle(@"Stop")];
    [myToggleRunningStateButton setEnabled: YES];
    
    [myAutomaticallyChecksForUpdatesButton setEnabled: YES];
    
    [self connectToVendedHelperController];
}

- (void)helperApplicationWillTerminate {
    [myStatusTextField setStringValue: ZeroKitLocalizedStringFromCurrentBundle(@"Spectacle is not running")];
    
    [myToggleRunningStateButton setTitle: ZeroKitLocalizedStringFromCurrentBundle(@"Start")];
    [myToggleRunningStateButton setEnabled: YES];
    
    [myAutomaticallyChecksForUpdatesButton setEnabled: NO];
    
    if (myVendedHelperController) {
        [myVendedHelperController release];
        
        myVendedHelperController = nil;
    }
    
    [self enableHotKeyRecorders: NO];
}

#pragma mark -

- (void)connectToVendedHelperController {
    NSConnection *connection = [NSConnection connectionWithRegisteredName: SpectacleHelperControllerServiceName host: nil];
    
    if (connection) {
        [myVendedHelperController release];
        
        myVendedHelperController = [[connection rootProxy] retain];
        
        [myVendedHelperController setProtocolForProxy: @protocol(SpectacleHelperControllerProtocol)];
        
        [self loadRegisteredHotKeys];
        
        if ([myVendedHelperController automaticallyChecksForUpdates]) {
            [myAutomaticallyChecksForUpdatesButton setState: NSOnState];
        } else {
            [myAutomaticallyChecksForUpdatesButton setState: NSOffState];
        }
    } else {
        NSLog(@"Connection to vended helper controller failed.");
    }
}

#pragma mark -

- (void)loadRegisteredHotKeys {
    if (myVendedHelperController) {
        for (NSString *hotKeyName in [myHotKeyRecorders allKeys]) {
            SpectacleHotKeyRecorder *hotKeyRecorder = [myHotKeyRecorders objectForKey: hotKeyName];
            SpectacleHotKey *hotKey = [myVendedHelperController registeredHotKeyForName: hotKeyName];
            
            [hotKeyRecorder setHotKeyName: hotKeyName];
            
            if (hotKey) {
                [hotKeyRecorder setHotKey: hotKey];
            }
            
            [hotKeyRecorder setDelegate: self];
        }
        
        [self enableHotKeyRecorders: YES];
    } else {
        NSLog(@"The vended helper controller is not available, unable to load registered hot keys.");
    }
}

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled {
    for (SpectacleHotKeyRecorder *hotKeyRecorder in [myHotKeyRecorders allValues]) {
        if (!enabled) {
            [hotKeyRecorder setHotKey: nil];
        }
        
        [hotKeyRecorder setEnabled: enabled];
    }
}

@end
