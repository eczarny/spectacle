#import <Carbon/Carbon.h>

#import <CoreServices/CoreServices.h>

#import <Foundation/Foundation.h>

@class SpectacleShortcut;

NSUInteger SpectacleConvertModifiersToCarbonIfNecessary(NSUInteger modifiers);
NSUInteger SpectacleConvertModifiersToCocoaIfNecessary(NSUInteger modifiers);
NSUInteger SpectacleConvertCocoaModifiersToCarbon(NSUInteger modifiers);
NSUInteger SpectacleConvertCarbonModifiersToCocoa(NSUInteger modifiers);

NSString *SpectacleTranslateCocoaModifiers(NSUInteger modifiers);
NSString *SpectacleTranslateKeyCode(NSInteger keyCode);
NSString *SpectacleTranslateShortcut(SpectacleShortcut *shortcut);
