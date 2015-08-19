#import <Carbon/Carbon.h>

#import <CoreServices/CoreServices.h>

#import <Foundation/Foundation.h>

@class SpectacleShortcut;

@interface SpectacleShortcutTranslator : NSObject

+ (SpectacleShortcutTranslator *)sharedTranslator;

#pragma mark -

+ (NSUInteger)convertModifiersToCarbonIfNecessary:(NSUInteger)modifiers;

+ (NSUInteger)convertModifiersToCocoaIfNecessary:(NSUInteger)modifiers;

#pragma mark -

+ (NSUInteger)convertCocoaModifiersToCarbon:(NSUInteger)modifiers;

+ (NSUInteger)convertCarbonModifiersToCocoa:(NSUInteger)modifiers;

#pragma mark -

+ (NSString *)translateCocoaModifiers:(NSUInteger)modifiers;

- (NSString *)translateKeyCode:(NSInteger)keyCode;

#pragma mark -

- (NSString *)translateShortcut:(SpectacleShortcut *)shortcut;

@end
