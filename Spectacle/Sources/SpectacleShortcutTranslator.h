#import <Carbon/Carbon.h>

#import <CoreServices/CoreServices.h>

#import <Foundation/Foundation.h>

@class SpectacleShortcut;

@interface SpectacleShortcutTranslator : NSObject

+ (NSUInteger)convertModifiersToCarbonIfNecessary:(NSUInteger)modifiers;
+ (NSUInteger)convertModifiersToCocoaIfNecessary:(NSUInteger)modifiers;
+ (NSUInteger)convertCocoaModifiersToCarbon:(NSUInteger)modifiers;
+ (NSUInteger)convertCarbonModifiersToCocoa:(NSUInteger)modifiers;

+ (NSString *)translateCocoaModifiers:(NSUInteger)modifiers;
+ (NSString *)translateKeyCode:(NSInteger)keyCode;
+ (NSString *)translateShortcut:(SpectacleShortcut *)shortcut;

@end
