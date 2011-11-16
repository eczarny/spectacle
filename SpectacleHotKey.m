#import "SpectacleHotKey.h"
#import "SpectacleHotKeyAction.h"
#import "SpectacleHotKeyTranslator.h"

@implementation SpectacleHotKey

- (id)initWithHotKeyCode: (NSInteger)hotKeyCode hotKeyModifiers: (NSInteger)hotKeyModifiers {
    if (self = [super init]) {
        myHandle = -1;
        myHotKeyName = nil;
        myHotKeyAction = nil;
        myHotKeyCode = hotKeyCode;
        myHotKeyModifiers = [SpectacleHotKeyTranslator convertModifiersToCarbonIfNecessary: hotKeyModifiers];
        myHotKeyRef = NULL;
    }
    
    return self;
}

#pragma mark -

- (id)initWithCoder: (NSCoder *)coder {
    if (self = [super init]) {
        if ([coder allowsKeyedCoding]) {
            myHotKeyName = [[coder decodeObjectForKey: @"name"] retain];
            myHotKeyCode = [coder decodeIntegerForKey: @"keyCode"];
            myHotKeyModifiers = [coder decodeIntegerForKey: @"modifiers"];
        } else {
            myHotKeyName = [[coder decodeObject] retain];
            
            [coder decodeValueOfObjCType: @encode(NSInteger) at: &myHotKeyCode];
            [coder decodeValueOfObjCType: @encode(NSInteger) at: &myHotKeyModifiers];
        }
    }
    
    return self;
}

#pragma mark -

- (void)encodeWithCoder: (NSCoder *)coder {
    if ([coder allowsKeyedCoding]) {
        [coder encodeObject: myHotKeyName forKey: @"name"];
        [coder encodeInteger: myHotKeyCode forKey: @"keyCode"];
        [coder encodeInteger: myHotKeyModifiers forKey: @"modifiers"];
    } else {
        [coder encodeObject: myHotKeyName];
        [coder encodeValueOfObjCType: @encode(NSInteger) at: &myHotKeyCode];
        [coder encodeValueOfObjCType: @encode(NSInteger) at: &myHotKeyModifiers];
    }
}

#pragma mark -

- (id)replacementObjectForPortCoder: (NSPortCoder *)encoder {
    if ([encoder isBycopy]) {
        return self;
    }
    
    return [super replacementObjectForPortCoder: encoder];
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

- (NSInteger)hotKeyCode {
    return myHotKeyCode;
}

- (void)setHotKeyCode: (NSInteger)hotKeyCode {
    myHotKeyCode = hotKeyCode;
}

#pragma mark -

- (NSInteger)hotKeyModifiers {
    return myHotKeyModifiers;
}

- (void)setHotKeyModifiers: (NSInteger)hotKeyModifiers {
    myHotKeyModifiers = [SpectacleHotKeyTranslator convertModifiersToCarbonIfNecessary: hotKeyModifiers];
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
