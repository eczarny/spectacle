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

#import "SpectacleAccessibilityElement.h"

@interface SpectacleAccessibilityElement (SpectacleAccessibilityElementPrivate)

- (void)setElement: (AXUIElementRef)element;

@end

#pragma mark -

@implementation SpectacleAccessibilityElement

- (id)init {
    if (self = [super init]) {
        myElement = NULL;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleAccessibilityElement *)systemWideElement {
    SpectacleAccessibilityElement *systemWideElement = [[[SpectacleAccessibilityElement alloc] init] autorelease];
    
    [systemWideElement setElement: AXUIElementCreateSystemWide()];
    
    return systemWideElement;
}

#pragma mark -

- (SpectacleAccessibilityElement *)elementWithAttribute: (CFStringRef)attribute {
    SpectacleAccessibilityElement *element = nil;
    AXUIElementRef childElement;
    AXError result;
    
    result = AXUIElementCopyAttributeValue(myElement, attribute, (CFTypeRef *)&childElement);
    
    if (result == kAXErrorSuccess) {
        element = [[[SpectacleAccessibilityElement alloc] init] autorelease];
        
        [element setElement: childElement];
    } else {
        NSLog(@"Unable to obtain the accessibility element with the specified attribute: %@", attribute);
    }
    
    return element;
}

#pragma mark -

- (AXValueRef)valueOfAttribute: (CFStringRef)attribute type: (AXValueType)type {
    if (CFGetTypeID(myElement) == AXUIElementGetTypeID()) {
        CFTypeRef value;
        AXError result;
        
        result = AXUIElementCopyAttributeValue(myElement, attribute, (CFTypeRef *)&value);
        
        if ((result == kAXErrorSuccess) && (AXValueGetType(value) == type)) {
            return value;
        } else {
            NSLog(@"There was a problem getting the value of the specified attribute: %@", attribute);
        }
    }
    
    return NULL;
}

- (void)setValue: (AXValueRef)value forAttribute: (CFStringRef)attribute {
    AXError result = AXUIElementSetAttributeValue(myElement, attribute, (CFTypeRef *)value);
    
    if (result != kAXErrorSuccess) {
        NSLog(@"There was a problem setting the value of the specified attribute: %@", attribute);
    }
}

@end

#pragma mark -

@implementation SpectacleAccessibilityElement (SpectacleAccessibilityElementPrivate)

- (void)setElement: (AXUIElementRef)element {
    myElement = element;
}

@end
