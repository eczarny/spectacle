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

#import "SpectacleHistoryItem.h"

@implementation SpectacleHistoryItem

- (id)initWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    if (self = [super init]) {
        myAccessibilityElement = [accessibilityElement retain];
        myWindowRect = windowRect;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHistoryItem *)historyItemFromAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement windowRect: (CGRect)windowRect {
    return [[[SpectacleHistoryItem alloc] initWithAccessibilityElement: accessibilityElement windowRect: windowRect] autorelease];
}

#pragma mark -

- (ZeroKitAccessibilityElement *)accessibilityElement {
    return myAccessibilityElement;
}

- (void)setAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement {
    if (myAccessibilityElement != accessibilityElement) {
        [myAccessibilityElement release];
        
        myAccessibilityElement = [accessibilityElement retain];
    }
}

#pragma mark -

- (CGRect)windowRect {
    return myWindowRect;
}

- (void)setWindowRect: (CGRect)windowRect {
    myWindowRect = windowRect;
}

#pragma mark -

- (void)dealloc {
    [myAccessibilityElement release];
    
    [super dealloc];
}

@end
