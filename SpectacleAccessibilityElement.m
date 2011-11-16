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
