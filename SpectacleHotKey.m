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

#import "SpectacleHotKey.h"
#import "SpectacleHotKeyAction.h"
#import "SpectacleHotKeyTranslator.h"

@implementation SpectacleHotKey

- (id)initWithKeyCode: (NSInteger)keyCode modifiers: (NSInteger)modifiers {
    if (self = [super init]) {
        myHandle = -1;
        myHotKeyName = nil;
        myHotKeyAction = nil;
        myKeyCode = keyCode;
        myModifiers = [SpectacleHotKeyTranslator convertModifiersToCarbonIfNecessary: modifiers];
        myHotKeyRef = NULL;
    }
    
    return self;
}

#pragma mark -

- (id)initWithCoder: (NSCoder *)coder {
    if (self = [super init]) {
        myHotKeyName = [[coder decodeObjectForKey: @"name"] retain];
        myKeyCode = [coder decodeIntegerForKey: @"keyCode"];
        myModifiers = [coder decodeIntegerForKey: @"modifiers"];
    }
    
    return self;
}

#pragma mark -

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject: myHotKeyName forKey: @"name"];
    [coder encodeInteger: myKeyCode forKey: @"keyCode"];
    [coder encodeInteger: myModifiers forKey: @"modifiers"];
}

#pragma mark -

- (NSInteger)handle {
    return myHandle;
}

- (void)setHandle: (NSInteger)handle {
    myHandle = handle;
}

#pragma mark -

- (NSString *)hotKeyName {
    return myHotKeyName;
}

- (void)setHotKeyName: (NSString *)hotKeyName {
    if (myHotKeyName != hotKeyName) {
        [myHotKeyName release];
        
        myHotKeyName = [hotKeyName retain];
    }
}

#pragma mark -

- (SpectacleHotKeyAction *)hotKeyAction {
    return myHotKeyAction;
}

- (void)setHotKeyAction: (SpectacleHotKeyAction *)hotKeyAction {
    if (myHotKeyAction != hotKeyAction) {
        [myHotKeyAction release];
        
        myHotKeyAction = [hotKeyAction retain];
    }
}

#pragma mark -

- (NSInteger)keyCode {
    return myKeyCode;
}

- (void)setKeyCode: (NSInteger)keyCode {
    myKeyCode = keyCode;
}

#pragma mark -

- (NSInteger)modifiers {
    return myModifiers;
}

- (void)setModifiers: (NSInteger)modifiers {
    myModifiers = modifiers;
}

#pragma mark -

- (EventHotKeyRef)hotKeyRef {
    return myHotKeyRef;
}

- (void)setHotKeyRef: (EventHotKeyRef)hotKeyRef {
    myHotKeyRef = hotKeyRef;
}

#pragma mark -

- (NSString *)displayString {
    return [[SpectacleHotKeyTranslator sharedTranslator] translateHotKey: self];
}

#pragma mark -

+ (BOOL)validCocoaModifiers: (NSInteger)modifiers {
    return (modifiers & NSAlternateKeyMask) || (modifiers & NSCommandKeyMask) || (modifiers & NSControlKeyMask) || (modifiers & NSShiftKeyMask);
}

#pragma mark -

- (void)dealloc {
    [myHotKeyName release];
    [myHotKeyAction release];
    
    [super dealloc];
}

@end
