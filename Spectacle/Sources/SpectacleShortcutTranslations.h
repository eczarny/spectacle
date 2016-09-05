#import <Foundation/Foundation.h>

@class SpectacleShortcut;

NSString *SpectacleTranslateKeyCode(NSInteger keyCode);
NSString *SpectacleTranslateModifiers(NSUInteger modifiers);
NSString *SpectacleTranslateShortcut(SpectacleShortcut *shortcut);

NSUInteger SpectacleConvertCocoaModifiersToCarbon(NSUInteger modifiers);
NSUInteger SpectacleConvertCarbonModifiersToCocoa(NSUInteger modifiers);
NSUInteger SpectacleConvertModifiersToCarbonIfNecessary(NSUInteger modifiers);
NSUInteger SpectacleConvertModifiersToCocoaIfNecessary(NSUInteger modifiers);
