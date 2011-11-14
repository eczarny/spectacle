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

#import "SpectacleHotKeyTranslator.h"
#import "SpectacleHotKey.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

enum {
    SpectacleHotKeyAlternateGlyph   = 0x2325,
    SpectacleHotKeyCommandGlyph     = 0x2318,
    SpectacleHotKeyControlGlyph     = 0x2303,
    SpectacleHotKeyDeleteLeftGlyph  = 0x232B,
    SpectacleHotKeyDeleteRightGlyph = 0x2326,
    SpectacleHotKeyDownArrowGlyph   = 0x2193,
    SpectacleHotKeyLeftArrowGlyph   = 0x2190,
    SpectacleHotKeyPageDownGlyph    = 0x21DF,
    SpectacleHotKeyPageUpGlyph      = 0x21DE,
    SpectacleHotKeyReturnGlyph      = 0x21A9,
    SpectacleHotKeyRightArrowGlyph  = 0x2192,
    SpectacleHotKeyShiftGlyph       = 0x21E7,
    SpectacleHotKeyTabLeftGlyph     = 0x21E4,
    SpectacleHotKeyTabRightGlyph    = 0x21E5,
    SpectacleHotKeyUpArrowGlyph     = 0x2191
};

enum {
    SpectacleHotKeyAlternateCarbonKeyMask = 1 << 11,
    SpectacleHotKeyCommandCarbonKeyMask   = 1 << 8,
    SpectacleHotKeyControlCarbonKeyMask   = 1 << 12,
    SpectacleHotKeyShiftCarbonKeyMask     = 1 << 9,
};

@interface SpectacleHotKeyTranslator (SpectacleHotKeyTranslatorPrivate)

+ (NSInteger)convertCocoaModifiersToCarbon: (NSInteger)modifiers;

+ (NSInteger)convertCarbonModifiersToCocoa: (NSInteger)modifiers;

#pragma mark -

- (void)buildKeyCodeConvertorDictionary;

@end

#pragma mark -

@implementation SpectacleHotKeyTranslator

static SpectacleHotKeyTranslator *sharedInstance = nil;

- (id)init {
    if ((self = [super init])) {
        mySpecialHotKeyTranslations = nil;
    }
    
    return self;
}

#pragma mark -

+ (id)allocWithZone: (NSZone *)zone {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone: zone];
            
            return sharedInstance;
        }
    }
    
    return nil;
}

#pragma mark -

+ (SpectacleHotKeyTranslator *)sharedTranslator {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

+ (NSInteger)convertModifiersToCarbonIfNecessary: (NSInteger)modifiers {
    if ([SpectacleHotKey validCocoaModifiers: modifiers]) {
        modifiers = [self convertCocoaModifiersToCarbon: modifiers];
    }
    
    return modifiers;
}

#pragma mark -

+ (NSString *)translateCocoaModifiers: (NSInteger)modifiers {
    NSString *modifierGlyphs = [NSString string];
    
    if (modifiers & NSControlKeyMask) {
        modifierGlyphs = [modifierGlyphs stringByAppendingFormat: @"%C", SpectacleHotKeyControlGlyph];
    }
    
    if (modifiers & NSAlternateKeyMask) {
        modifierGlyphs = [modifierGlyphs stringByAppendingFormat: @"%C", SpectacleHotKeyAlternateGlyph];
    }
    
    if (modifiers & NSShiftKeyMask) {
        modifierGlyphs = [modifierGlyphs stringByAppendingFormat: @"%C", SpectacleHotKeyShiftGlyph];
    }
    
    if (modifiers & NSCommandKeyMask) {
        modifierGlyphs = [modifierGlyphs stringByAppendingFormat: @"%C", SpectacleHotKeyCommandGlyph];
    }
    
    return modifierGlyphs;
}

- (NSString *)translateKeyCode: (NSInteger)keyCode {
    NSDictionary *keyCodeTranslations = nil;
    NSString *result;
    
    [self buildKeyCodeConvertorDictionary];
    
    keyCodeTranslations = [mySpecialHotKeyTranslations objectForKey: SpectacleHotKeyTranslationsKey];
    
    result = [keyCodeTranslations objectForKey: [NSString stringWithFormat: @"%d", keyCode]];
    
    if (result) {
        NSDictionary *glyphTranslations = [mySpecialHotKeyTranslations objectForKey: SpectacleHotKeyGlyphTranslationsKey];
        id translatedGlyph = [glyphTranslations objectForKey: result];
        
        if (translatedGlyph) {
            result = [NSString stringWithFormat: @"%C", [translatedGlyph integerValue]];
        }
    } else {
        TISInputSourceRef inputSource = TISCopyCurrentKeyboardInputSource();
        CFDataRef layoutData = (CFDataRef)TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData);
        const UCKeyboardLayout *keyboardLayout = nil;
        UInt32 keysDown = 0;
        UniCharCount length = 4;
        UniCharCount actualLength = 0;
        UniChar chars[4];
        OSStatus err;
        
        if (layoutData == NULL) {
            NSLog(@"Unable to determine keyboard layout.");
            
            return @"?";
        }
        
        keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
        
        err = UCKeyTranslate(keyboardLayout,
                             keyCode,
                             kUCKeyActionDisplay,
                             0,
                             LMGetKbdType(),
                             kUCKeyTranslateNoDeadKeysBit,
                             &keysDown,
                             length,
                             &actualLength,
                             chars);
        
        if (err != noErr) {
            NSLog(@"There was a problem translating the key code.");
            
            return @"?";
        }
        
        result = [[NSString stringWithCharacters: chars length: 1] uppercaseString];
    }
    
    return result;
}

#pragma mark -

- (NSString *)translateHotKey: (SpectacleHotKey *)hotKey {
    NSInteger modifiers = [SpectacleHotKeyTranslator convertCarbonModifiersToCocoa: [hotKey hotKeyModifiers]];
    
    return [NSString stringWithFormat: @"%@%@", [SpectacleHotKeyTranslator translateCocoaModifiers: modifiers], [self translateKeyCode: [hotKey hotKeyCode]]];
}

#pragma mark -

- (void)dealloc {
    [mySpecialHotKeyTranslations release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleHotKeyTranslator (SpectacleHotKeyTranslatorPrivate)

+ (NSInteger)convertCocoaModifiersToCarbon: (NSInteger)modifiers {
    NSInteger convertedModifiers = 0;
    
    if (modifiers & NSControlKeyMask) {
        convertedModifiers |= SpectacleHotKeyControlCarbonKeyMask;
    }
    
    if (modifiers & NSAlternateKeyMask) {
        convertedModifiers |= SpectacleHotKeyAlternateCarbonKeyMask;
    }
    
    if (modifiers & NSShiftKeyMask) {
        convertedModifiers |= SpectacleHotKeyShiftCarbonKeyMask;
    }
    
    if (modifiers & NSCommandKeyMask) {
        convertedModifiers |= SpectacleHotKeyCommandCarbonKeyMask;
    }
    
    return convertedModifiers;
}

+ (NSInteger)convertCarbonModifiersToCocoa: (NSInteger)modifiers {
    NSInteger convertedModifiers = 0;
    
    if (modifiers & SpectacleHotKeyControlCarbonKeyMask) {
        convertedModifiers |= NSControlKeyMask;
    }
    
    if (modifiers & SpectacleHotKeyAlternateCarbonKeyMask) {
        convertedModifiers |= NSAlternateKeyMask;
    }
    
    if (modifiers & SpectacleHotKeyShiftCarbonKeyMask) {
        convertedModifiers |= NSShiftKeyMask;
    }
    
    if (modifiers & SpectacleHotKeyCommandCarbonKeyMask) {
        convertedModifiers |= NSCommandKeyMask;
    }
    
    return convertedModifiers;
}

#pragma mark -

- (void)buildKeyCodeConvertorDictionary {
    if (!mySpecialHotKeyTranslations) {
        NSBundle *bundle = [SpectacleUtilities helperApplicationBundle];
        NSString *path = [bundle pathForResource: SpectacleHotKeyTranslationsPropertyListFile ofType: ZeroKitPropertyListFileExtension];
        
        mySpecialHotKeyTranslations = [[NSDictionary alloc] initWithContentsOfFile: path];
    }
}

@end
