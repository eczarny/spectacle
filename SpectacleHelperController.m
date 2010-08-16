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

#import "SpectacleHelperController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHelperApplicationController.h"
#import "SpectacleHotKey.h"
#import "SpectacleHotKeyAction.h"
#import "SpectacleUtilities.h"

@implementation SpectacleHelperController

- (id)init {
    if (self = [super init]) {
        myHotKeyManager = [SpectacleHotKeyManager sharedManager];
    }
    
    return self;
}

#pragma mark -

- (SpectacleHotKey *)registeredHotKeyForName: (in NSString *)name {
    return [myHotKeyManager registeredHotKeyForName: name];
}

#pragma mark -

- (oneway void)updateHotKeyWithKeyCode: (NSInteger)keyCode modifiers: (NSInteger)modifiers name: (bycopy in NSString *)name {
    SpectacleHotKey *hotKey = [[[SpectacleHotKey alloc] initWithKeyCode: keyCode modifiers: modifiers] autorelease];
    
    [hotKey setHotKeyName: name];
    
    [hotKey setHotKeyAction: [SpectacleUtilities actionForHotKeyWithName: name target: myHelperApplicationController]];
    
    [myHotKeyManager registerHotKey: hotKey];
}

#pragma mark -

- (oneway void)unregisterHotKeyWithName: (in NSString *)name {
    [myHotKeyManager unregisterHotKeyForName: name];
}

#pragma mark -

- (BOOL)automaticallyChecksForUpdates {
    return [[SUUpdater updaterForBundle: [SpectacleUtilities preferencePaneBundle]] automaticallyChecksForUpdates];
}

- (oneway void)setAutomaticallyChecksForUpdates: (BOOL)automaticallyChecksForUpdates {
    [[SUUpdater updaterForBundle: [SpectacleUtilities preferencePaneBundle]] setAutomaticallyChecksForUpdates: automaticallyChecksForUpdates];
}

@end
