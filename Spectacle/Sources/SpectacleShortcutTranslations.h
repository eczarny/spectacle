#import <Carbon/Carbon.h>

#import <CoreServices/CoreServices.h>

#import <Foundation/Foundation.h>

@class SpectacleShortcut;

NSUInteger SpectacleConvertModifiersToCarbonIfNecessary(NSUInteger modifiers);
NSUInteger SpectacleConvertModifiersToCocoaIfNecessary(NSUInteger modifiers);
NSUInteger SpectacleConvertCocoaModifiersToCarbon(NSUInteger modifiers);
NSUInteger SpectacleConvertCarbonModifiersToCocoa(NSUInteger modifiers);

NSString *SpectacleTranslateKeyCode(NSInteger keyCode, NSUInteger modifiers);
NSString *SpectacleTranslateModifiers(NSUInteger modifiers);
NSString *SpectacleTranslateShortcut(SpectacleShortcut *shortcut);
