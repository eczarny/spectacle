#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <CoreServices/CoreServices.h>

@class ZKHotKey;

@interface ZKHotKeyTranslator : NSObject

+ (ZKHotKeyTranslator *)sharedTranslator;

#pragma mark -

+ (NSInteger)convertModifiersToCarbonIfNecessary: (NSInteger)modifiers;

#pragma mark -

+ (NSString *)translateCocoaModifiers: (NSInteger)modifiers;

- (NSString *)translateKeyCode: (NSInteger)keyCode;

#pragma mark -

- (NSString *)translateHotKey: (ZKHotKey *)hotKey;

@end
