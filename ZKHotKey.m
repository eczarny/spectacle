#import "ZKHotKey.h"
#import "ZKHotKeyTranslator.h"
#import "SpectacleConstants.h"

@implementation ZKHotKey

- (id)initWithHotKeyCode: (NSInteger)hotKeyCode hotKeyModifiers: (NSUInteger)hotKeyModifiers {
    if (self = [super init]) {
        _handle = -1;
        _hotKeyName = nil;
        _hotKeyAction = nil;
        _hotKeyCode = hotKeyCode;
        _hotKeyModifiers = [ZKHotKeyTranslator convertModifiersToCarbonIfNecessary: hotKeyModifiers];
        _hotKeyRef = NULL;
    }
    
    return self;
}

#pragma mark -

- (id)initWithCoder: (NSCoder *)coder {
    if (self = [super init]) {
        if ([coder allowsKeyedCoding]) {
            _hotKeyName = [coder decodeObjectForKey: @"name"];
            _hotKeyCode = [coder decodeIntegerForKey: @"keyCode"];
            _hotKeyModifiers = [coder decodeIntegerForKey: @"modifiers"];
        } else {
            _hotKeyName = [coder decodeObject];
            
            [coder decodeValueOfObjCType: @encode(NSInteger) at: &_hotKeyCode];
            [coder decodeValueOfObjCType: @encode(NSUInteger) at: &_hotKeyModifiers];
        }
    }
    
    return self;
}

#pragma mark -

- (OSStatus)updateEnabled: (BOOL)enabled {
    OSStatus  error;
    
    if (_enabled && !enabled) {
        error = UnregisterEventHotKey(_hotKeyRef);
        if (error) return error;
    } else if (!_enabled && enabled) {
        EventHotKeyID event_id = {
            .signature = SpectacleHotKeySignature,
            .id = (UInt32)_handle
        };
        error = RegisterEventHotKey((unsigned int)_hotKeyCode,
                                    (unsigned int)_hotKeyModifiers, event_id,
                                    GetEventDispatcherTarget(), 0, &_hotKeyRef);
        if (error) return error;
    }
    _enabled = enabled;
    
    return 0;
}

#pragma mark -

- (void)encodeWithCoder: (NSCoder *)coder {
    if ([coder allowsKeyedCoding]) {
        [coder encodeObject: _hotKeyName forKey: @"name"];
        [coder encodeInteger: _hotKeyCode forKey: @"keyCode"];
        [coder encodeInteger: _hotKeyModifiers forKey: @"modifiers"];
    } else {
        [coder encodeObject: _hotKeyName];
        [coder encodeValueOfObjCType: @encode(NSInteger) at: &_hotKeyCode];
        [coder encodeValueOfObjCType: @encode(NSUInteger) at: &_hotKeyModifiers];
    }
}

#pragma mark -

- (id)replacementObjectForPortCoder: (NSPortCoder *)encoder {
    if (encoder.isBycopy) {
        return self;
    }
    
    return [super replacementObjectForPortCoder: encoder];
}

#pragma mark -

+ (ZKHotKey *)clearedHotKey {
    return [[ZKHotKey alloc] initWithHotKeyCode: 0 hotKeyModifiers: 0];
}

+ (ZKHotKey *)clearedHotKeyWithName: (NSString *)name {
    ZKHotKey *hotKey = [[ZKHotKey alloc] initWithHotKeyCode: 0 hotKeyModifiers: 0];
    
    hotKey.hotKeyName = name;
    
    return hotKey;
}

#pragma mark -

- (void)triggerHotKeyAction {
    if (_hotKeyAction) {
        _hotKeyAction(self);
    }
}

#pragma mark -

- (BOOL)isClearedHotKey {
    return (_hotKeyCode == 0) && (_hotKeyModifiers == 0);
}

#pragma mark -

- (NSString *)displayString {
    return [ZKHotKeyTranslator.sharedTranslator translateHotKey: self];
}

#pragma mark -

+ (BOOL)validCocoaModifiers: (NSUInteger)modifiers {
    return (modifiers & NSAlternateKeyMask) || (modifiers & NSCommandKeyMask) || (modifiers & NSControlKeyMask) || (modifiers & NSShiftKeyMask);
}

#pragma mark -

- (BOOL)isEqual: (id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass: [self class]]) {
        return NO;
    }
    
    return [self isEqualToHotKey: object];
}

- (BOOL)isEqualToHotKey: (ZKHotKey *)hotKey {
    if (hotKey == self) {
        return YES;
    }
    
    if (hotKey.hotKeyCode != _hotKeyCode) {
        return NO;
    }
    
    if (hotKey.hotKeyModifiers != _hotKeyModifiers) {
        return NO;
    }
    
    return YES;
}

@end
