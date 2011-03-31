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

#import <Cocoa/Cocoa.h>
#import "SpectacleHotKeyRecorderDelegate.h"

@class SpectacleHotKeyRecorder, SpectacleHotKey;

@interface SpectacleHotKeyRecorderCell : NSCell {
    SpectacleHotKeyRecorder *myHotKeyRecorder;
    NSString *myHotKeyName;
    SpectacleHotKey *myHotKey;
    id<SpectacleHotKeyRecorderDelegate> myDelegate;
    NSInteger myModifierFlags;
    BOOL isRecording;
    NSTrackingArea *myTrackingArea;
    BOOL isMouseAboveBadge;
    BOOL isMouseDown;
}

- (void)setHotKeyRecorder: (SpectacleHotKeyRecorder *)hotKeyRecorder;

#pragma mark -

- (NSString *)hotKeyName;

- (void)setHotKeyName: (NSString *)hotKeyName;

#pragma mark -

- (SpectacleHotKey *)hotKey;

- (void)setHotKey: (SpectacleHotKey *)hotKey;

#pragma mark -

- (id<SpectacleHotKeyRecorderDelegate>)delegate;

- (void)setDelegate: (id<SpectacleHotKeyRecorderDelegate>)delegate;

#pragma mark -

- (BOOL)resignFirstResponder;

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event;

- (void)flagsChanged: (NSEvent *)event;

@end
