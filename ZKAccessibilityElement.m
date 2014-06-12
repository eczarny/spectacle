#import "ZKAccessibilityElement.h"

@interface ZKAccessibilityElement ()

@property (nonatomic) AXUIElementRef element;

@end

#pragma mark -

@implementation ZKAccessibilityElement

- (id)init {
    if (self = [super init]) {
        _element = NULL;
    }
    
    return self;
}

#pragma mark -

+ (ZKAccessibilityElement *)systemWideElement {
    ZKAccessibilityElement *newElement = [ZKAccessibilityElement new];
    AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
    
    newElement.element = systemWideElement;
    
    CFRelease(systemWideElement);
    
    return newElement;
}

#pragma mark -

- (ZKAccessibilityElement *)elementWithAttribute: (CFStringRef)attribute {
    ZKAccessibilityElement *newElement = nil;
    AXUIElementRef childElement;
    AXError result;
    
    result = AXUIElementCopyAttributeValue(_element, attribute, (CFTypeRef *)&childElement);
    
    if (result == kAXErrorSuccess) {
        newElement = [ZKAccessibilityElement new];
        
        newElement.element = childElement;
        
        CFRelease(childElement);
    } else {
        NSLog(@"Unable to obtain the accessibility element with the specified attribute: %@", attribute);
    }
    
    return newElement;
}

#pragma mark -

- (NSString *)stringValueOfAttribute: (CFStringRef)attribute {
    if (CFGetTypeID(_element) == AXUIElementGetTypeID()) {
        CFTypeRef value;
        AXError result;
        
        result = AXUIElementCopyAttributeValue(_element, attribute, &value);
        
        if (result == kAXErrorSuccess) {
            return CFBridgingRelease(value);
        } else {
            NSLog(@"There was a problem getting the string value of the specified attribute: %@", attribute);
        }
    }
    
    return nil;
}

- (AXValueRef)valueOfAttribute: (CFStringRef)attribute type: (AXValueType)type {
    if (CFGetTypeID(_element) == AXUIElementGetTypeID()) {
        CFTypeRef value;
        AXError result;
        
        result = AXUIElementCopyAttributeValue(_element, attribute, (CFTypeRef *)&value);
        
        if ((result == kAXErrorSuccess) && (AXValueGetType(value) == type)) {
            return value;
        } else {
            NSLog(@"There was a problem getting the value of the specified attribute: %@", attribute);
        }
    }
    
    return NULL;
}

#pragma mark -

- (void)setValue: (AXValueRef)value forAttribute: (CFStringRef)attribute {
    AXError result = AXUIElementSetAttributeValue(_element, attribute, (CFTypeRef *)value);
    
    if (result != kAXErrorSuccess) {
        NSLog(@"There was a problem setting the value of the specified attribute: %@", attribute);
    }
}

#pragma mark -

- (void)dealloc {
    if (_element != NULL) {
        CFRelease(_element);
    }
}

#pragma mark -

- (void)setElement: (AXUIElementRef)element {
    if (_element != NULL) {
        CFRelease(_element);
    }
    
    _element = CFRetain(element);
}

@end
