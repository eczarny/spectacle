#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <CoreServices/CoreServices.h>

@class ZKHotKey;

@interface ZKHotKeyTranslator : NSObject

+ (ZKHotKeyTranslator *)sharedTranslator;

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

- (NSString *)translateHotKey:(ZKHotKey *)hotKey;

@end
