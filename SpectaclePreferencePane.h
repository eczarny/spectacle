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

#import <PreferencePanes/PreferencePanes.h>
#import "SpectacleToggleSwitchDelegate.h"

@class SpectacleToggleSwitch;

@interface SpectaclePreferencePane : NSPreferencePane<ZeroKitHotKeyRecorderDelegate, SpectacleToggleSwitchDelegate> {
    id myVendedHelperController;
    NSDictionary *myHotKeyRecorders;
    IBOutlet NSTextField *mySpectacleVersionTextField;
    IBOutlet SpectacleToggleSwitch *myToggleRunningStateSwitch;
    IBOutlet NSButton *myLoginItemEnabledButton;
    IBOutlet NSButton *myAutomaticallyChecksForUpdatesButton;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToCenterHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToFullscreenHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLeftHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToRightHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToTopHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToBottomHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToUpperLeftHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLowerLeftHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToUpperRightHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLowerRightHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToLeftDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToRightDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToTopDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myMoveToBottomDisplayHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myUndoLastMoveHotKeyRecorder;
    IBOutlet ZeroKitHotKeyRecorder *myRedoLastMoveHotKeyRecorder;
}

- (void)toggleLoginItem: (id)sender;

#pragma mark -

- (void)toggleCheckForUpdates: (id)sender;

@end
