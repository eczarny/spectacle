#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <CoreServices/CoreServices.h>

@class SpectacleHotKey;

@interface SpectacleHotKeyTranslator : NSObject {
    NSDictionary *mySpecialHotKeyTranslations;
}

+ (SpectacleHotKeyTranslator *)sharedTranslator;

#pragma mark -

+ (NSInteger)convertModifiersToCarbonIfNecessary: (NSInteger)modifiers;

#pragma mark -

+ (NSString *)translateCocoaModifiers: (NSInteger)modifiers;

- (NSString *)translateKeyCode: (NSInteger)keyCode;

#pragma mark -

- (NSString *)translateHotKey: (SpectacleHotKey *)hotKey;

@end
