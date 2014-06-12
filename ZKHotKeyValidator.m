#import "ZKHotKeyValidator.h"
#import "ZKHotKeyValidatorProtocol.h"
#import "ZKHotKeyTranslator.h"
#import "ZKHotKey.h"
#import "ZKUtilities.h"

@implementation ZKHotKeyValidator

+ (BOOL)isHotKeyValid: (ZKHotKey *)hotKey error: (NSError **)error {
    return [ZKHotKeyValidator isHotKeyValid: hotKey withValidators: @[] error: error];
}

+ (BOOL)isHotKeyValid: (ZKHotKey *)hotKey withValidators: (NSArray *)validators error: (NSError **)error {
    CFArrayRef hotKeys = NULL;
    
    if (CopySymbolicHotKeys(&hotKeys)) {
        return YES;
    }
    
    for (CFIndex i = 0; i < CFArrayGetCount(hotKeys); i++) {
        CFDictionaryRef hotKeyDictionary = (CFDictionaryRef)CFArrayGetValueAtIndex(hotKeys, i);
        
        if (!hotKeyDictionary || (CFGetTypeID(hotKeyDictionary) != CFDictionaryGetTypeID())) {
            continue;
        }
        
        if (kCFBooleanTrue != (CFBooleanRef)CFDictionaryGetValue(hotKeyDictionary, kHISymbolicHotKeyEnabled)) {
            continue;
        }
        
        NSInteger keyCode = [ZKHotKeyValidator keyCodeFromDictionary: hotKeyDictionary];
        NSInteger modifiers = [ZKHotKeyValidator modifiersFromDictionary: hotKeyDictionary];
        
        if (([hotKey hotKeyCode] == keyCode) && [ZKHotKeyValidator hotKey: hotKey containsModifiers: modifiers]) {
            if (error) {
                *error = [ZKHotKeyValidator errorWithHotKey: hotKey
                                                description: @"Hot key %@ already in use."
                                         recoverySuggestion: @"The hot key \"%@\" is already used by a system-wide keyboard shortcut.\n\nTo use this hot key change the existing shortcut in the Keyboard preference pane under System Preferences."];
            }
            
            return NO;
        }
    }
    
    for (id<ZKHotKeyValidatorProtocol> validator in validators) {
        if ([validator conformsToProtocol: @protocol(ZKHotKeyValidatorProtocol)] && ![validator isHotKeyValid: hotKey]) {
            if (error) {
                *error = [ZKHotKeyValidator errorWithHotKey: hotKey
                                                description: @"Hot key %@ already in use."
                                         recoverySuggestion: @"The hot key \"%@\" is already in use. Please select a new hot key."];
            }
            
            return NO;
        }
    }
    
    return [self isHotKey: hotKey availableInMenu: [[NSApplication sharedApplication] mainMenu] error: error];
}

#pragma mark -

+ (NSInteger)keyCodeFromDictionary: (CFDictionaryRef)dictionary {
    CFNumberRef keyCodeFromDictionary = (CFNumberRef)CFDictionaryGetValue(dictionary, kHISymbolicHotKeyCode);
    NSInteger keyCode = 0;
    
    CFNumberGetValue(keyCodeFromDictionary, kCFNumberLongType, &keyCode);
    
    return keyCode;
}

+ (NSInteger)modifiersFromDictionary: (CFDictionaryRef)dictionary {
    CFNumberRef modifiersFromDictionary = (CFNumberRef)CFDictionaryGetValue(dictionary, kHISymbolicHotKeyModifiers);
    NSInteger modifiers = 0;
    
    CFNumberGetValue(modifiersFromDictionary, kCFNumberLongType, &modifiers);
    
    return modifiers;
}

#pragma mark -

+ (BOOL)hotKey: (ZKHotKey *)hotKey containsModifiers: (NSInteger)modifiers {
    return hotKey.hotKeyModifiers == [ZKHotKeyTranslator convertModifiersToCarbonIfNecessary: modifiers];
}

#pragma mark -

+ (NSError *)errorWithHotKey: (ZKHotKey *)hotKey description: (NSString *)description recoverySuggestion: (NSString *)recoverySuggestion {
    NSString *hotKeyString = [ZKHotKeyTranslator.sharedTranslator translateHotKey: hotKey];
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat: ZKLocalizedStringFromCurrentBundle(description), hotKeyString];
    
    userInfo[NSLocalizedRecoverySuggestionErrorKey] = [NSString stringWithFormat: ZKLocalizedStringFromCurrentBundle(recoverySuggestion), hotKeyString];
    
    userInfo[NSLocalizedRecoveryOptionsErrorKey] = @[ZKLocalizedStringFromCurrentBundle(@"OK")];
    
    return [NSError errorWithDomain: NSCocoaErrorDomain code: 0 userInfo: userInfo];
}

#pragma mark -

+ (BOOL)isHotKey: (ZKHotKey *)hotKey availableInMenu: (NSMenu *)menu error: (NSError **)error {
    for (NSMenuItem *menuItem in menu.itemArray) {
        if ([menuItem hasSubmenu] && ![self isHotKey: hotKey availableInMenu: menuItem.submenu error: error]) {
            return NO;
        }
        
        NSString *keyEquivalent = menuItem.keyEquivalent;
        
        if (!keyEquivalent || [keyEquivalent isEqualToString: @""]) {
            continue;
        }
        
        NSString *keyCode = [ZKHotKeyTranslator.sharedTranslator translateKeyCode: hotKey.hotKeyCode];
        
        if ([[keyEquivalent uppercaseString] isEqualToString: keyCode]
                && [ZKHotKeyValidator hotKey: hotKey containsModifiers: menuItem.keyEquivalentModifierMask]) {
            if (error) {
                *error = [ZKHotKeyValidator errorWithHotKey: hotKey
                                                description: @"Hot key %@ already in use."
                                         recoverySuggestion: @"The hot key \"%@\" is already used in the menu."];
            }
            
            return NO;
        }
    }
    
    return YES;
}

@end
