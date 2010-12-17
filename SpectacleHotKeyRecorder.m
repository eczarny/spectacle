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

#import "SpectacleHotKeyRecorder.h"
#import "SpectacleHotKeyRecorderCell.h"

#define MyCell (SpectacleHotKeyRecorderCell *)[self cell]

#pragma mark -

@implementation SpectacleHotKeyRecorder

- (id)initWithFrame: (NSRect)frame {
    if (self = [super initWithFrame: frame]) {
        [MyCell setHotKeyRecorder: self];
    }
    
    return self;
}

#pragma mark -

+ (Class)cellClass {
    return [SpectacleHotKeyRecorderCell class];
}

#pragma mark -

- (NSString *)hotKeyName {
    return [MyCell hotKeyName];
}

- (void)setHotKeyName: (NSString *)hotKeyName {
    [MyCell setHotKeyName: hotKeyName];
}

#pragma mark -

- (SpectacleHotKey *)hotKey {
    return [MyCell hotKey];
}

- (void)setHotKey: (SpectacleHotKey *)hotKey {
    [MyCell setHotKey: hotKey];
    
    [self updateCell: MyCell];
}

#pragma mark -

- (id<SpectacleHotKeyRecorderDelegate>)delegate {
    return [MyCell delegate];
}

- (void)setDelegate: (id<SpectacleHotKeyRecorderDelegate>)delegate {
    [MyCell setDelegate: delegate];
}

#pragma mark -

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)acceptsFirstMouse: (NSEvent *)event {
    return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event {
    if ([[[self window] firstResponder] isEqualTo: self]) {
        return [MyCell performKeyEquivalent: event];
    }
    
    return [super performKeyEquivalent: event];
}

- (void)keyDown: (NSEvent *)event {
    if ([self performKeyEquivalent: event]) {
        return;
    }
    
    [super keyDown: event];
}

- (void)flagsChanged: (NSEvent *)event {
    [MyCell flagsChanged: event];
}

#pragma mark -

- (BOOL)resignFirstResponder {
    return [MyCell resignFirstResponder];
}

@end
