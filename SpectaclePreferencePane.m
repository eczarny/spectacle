// 
// Copyright (c) 2011 Eric Czarny <eczarny@gmail.com>
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
#import "SpectacleToggleSwitch.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

@interface SpectaclePreferencePane (SpectaclePreferencePanePrivate)

- (void)toggleControlsBasedOnSpectacleRunningState;

#pragma mark -

- (void)helperApplicationDidFinishLaunching;

- (void)helperApplicationDidTerminate;

#pragma mark -

- (void)connectToVendedHelperController;

#pragma mark -

- (void)handleConnectionException: (NSException *)exception withMessage: (NSString *)message;

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
                                      selector: @selector(helperApplicationDidTerminate)
                                          name: SpectacleHelperDidTerminateNotification
                                        object: nil
                            suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    
    myHotKeyRecorders = [[NSDictionary alloc] initWithObjectsAndKeys:
                         myMoveToCenterHotKeyRecorder,        SpectacleWindowActionMoveToCenter,
                         myMoveToFullscreenHotKeyRecorder,    SpectacleWindowActionMoveToFullscreen,
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
                         myUndoLastMoveHotKeyRecorder,        SpectacleWindowActionUndoLastMove,
                         myRedoLastMoveHotKeyRecorder,        SpectacleWindowActionRedoLastMove,
                         nil];
    
    [myToggleRunningStateSwitch setDelegate: self];
    
    [self toggleControlsBasedOnSpectacleRunningState];
    
    [mySpectacleVersionTextField setStringValue: [SpectacleUtilities preferencePaneVersion]];
}

#pragma mark -

- (void)didSelect {
    [self toggleControlsBasedOnSpectacleRunningState];
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
    @try {
        [myVendedHelperController setAutomaticallyChecksForUpdates: ![myVendedHelperController automaticallyChecksForUpdates]];
    } @catch (NSException *e) {
        [self handleConnectionException: e
                            withMessage: @"There was a problem while changing the automatically checks for updates flag."];
    }
}

#pragma mark -

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didReceiveNewHotKey: (ZeroKitHotKey *)hotKey {
    @try {
        [myVendedHelperController updateHotKeyWithKeyCode: [hotKey hotKeyCode] modifiers: [hotKey hotKeyModifiers] name: [hotKey hotKeyName]];
    } @catch (NSException *e) {
        [self handleConnectionException: e
                            withMessage: @"There was a problem while updating a hot key."];
    }
}

- (void)hotKeyRecorder: (ZeroKitHotKeyRecorder *)hotKeyRecorder didClearExistingHotKey: (ZeroKitHotKey *)hotKey {
    @try {
        [myVendedHelperController unregisterHotKeyWithName: [hotKey hotKeyName]];
    } @catch (NSException *e) {
        [self handleConnectionException: e
                            withMessage: @"There was a problem while clearing an existing hot key."];
    }
}

#pragma mark -

- (void)toggleSwitchDidChangeState: (SpectacleToggleSwitch *)toggleSwitch {
    if ([toggleSwitch state] == NSOnState) {
        [SpectacleUtilities startSpectacle];
    } else {
        [SpectacleUtilities stopSpectacle];
    }
    
    [myToggleRunningStateSwitch setEnabled: NO];
}

#pragma mark -

- (void)willUnselect {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver: self];
    
    [myVendedHelperController release];
    
    myVendedHelperController = nil;
}

#pragma mark -

- (void)dealloc {
    [myVendedHelperController release];
    [myHotKeyRecorders release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectaclePreferencePane (SpectaclePreferencePanePrivate)

- (void)toggleControlsBasedOnSpectacleRunningState {
    NSInteger loginItemEnabledState = [SpectacleUtilities isLoginItemEnabledForBundle: [SpectacleUtilities helperApplicationBundle]] ? NSOnState : NSOffState;
    
    [myLoginItemEnabledButton setState: loginItemEnabledState];
    
    if ([SpectacleUtilities isSpectacleRunning]) {
        [myToggleRunningStateSwitch setState: NSOnState];
        
        [self connectToVendedHelperController];
    } else {
        [myToggleRunningStateSwitch setState: NSOffState];
        
        [myAutomaticallyChecksForUpdatesButton setEnabled: NO];
        
        [self enableHotKeyRecorders: NO];
    }
}

#pragma mark -

- (void)helperApplicationDidFinishLaunching {
    [myToggleRunningStateSwitch setEnabled: YES];
    
    [self connectToVendedHelperController];
}

- (void)helperApplicationDidTerminate {
    [myToggleRunningStateSwitch setEnabled: YES];
    
    [myAutomaticallyChecksForUpdatesButton setEnabled: NO];
    
    [self enableHotKeyRecorders: NO];
    
    [myVendedHelperController release];
    
    myVendedHelperController = nil;
}

#pragma mark -

- (void)connectToVendedHelperController {
    NSConnection *connection = [NSConnection connectionWithRegisteredName: SpectacleHelperControllerServiceName host: nil];
    
    if (connection) {
        [myVendedHelperController release];
        
        myVendedHelperController = [[connection rootProxy] retain];
        
        [myVendedHelperController setProtocolForProxy: @protocol(SpectacleHelperControllerProtocol)];
        
        [self loadRegisteredHotKeys];
        
        [myAutomaticallyChecksForUpdatesButton setEnabled: YES];
        
        @try {
            if ([myVendedHelperController automaticallyChecksForUpdates]) {
                [myAutomaticallyChecksForUpdatesButton setState: NSOnState];
            } else {
                [myAutomaticallyChecksForUpdatesButton setState: NSOffState];
            }
        } @catch (NSException *e) {
            [self handleConnectionException: e
                                withMessage: @"There was a problem while fetching the state of the automatically checks for updates flag."];
        }
    } else {
        NSLog(@"Connection to vended helper controller failed.");
    }
}

#pragma mark -

- (void)handleConnectionException: (NSException *)exception withMessage: (NSString *)message {
    NSLog(@"%@ (%@)", message, [exception name]);
    
    if (![SpectacleUtilities isSpectacleRunning]) {
        [self helperApplicationDidTerminate];
    }
}

#pragma mark -

- (void)loadRegisteredHotKeys {
    for (NSString *hotKeyName in [myHotKeyRecorders allKeys]) {
        ZeroKitHotKeyRecorder *hotKeyRecorder = [myHotKeyRecorders objectForKey: hotKeyName];
        ZeroKitHotKey *hotKey = nil;
        
        @try {
            hotKey = [myVendedHelperController registeredHotKeyForName: hotKeyName];
        } @catch (NSException *e) {
            [self handleConnectionException: e
                                withMessage: @"There was a problem while fetching a hot key."];
        }
        
        [hotKeyRecorder setHotKeyName: hotKeyName];
        
        if (hotKey) {
            [hotKeyRecorder setHotKey: hotKey];
        }
        
        [hotKeyRecorder setDelegate: self];
    }
    
    [self enableHotKeyRecorders: YES];
}

#pragma mark -

- (void)enableHotKeyRecorders: (BOOL)enabled {
    for (ZeroKitHotKeyRecorder *hotKeyRecorder in [myHotKeyRecorders allValues]) {
        if (!enabled) {
            [hotKeyRecorder setHotKey: nil];
        }
        
        [hotKeyRecorder setEnabled: enabled];
    }
}

@end
