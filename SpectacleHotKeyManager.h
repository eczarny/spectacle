#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHotKeyManager : NSObject {
    NSMutableDictionary *myRegisteredHotKeys;
    NSInteger myCurrentHotKeyID;
    BOOL isHotKeyHandlerInstalled;
}

+ (SpectacleHotKeyManager *)sharedManager;

#pragma mark -

- (NSInteger)registerHotKey: (ZeroKitHotKey *)hotKey;

- (void)registerHotKeys: (NSArray *)hotKeys;

#pragma mark -

- (void)unregisterHotKeyForName: (NSString *)name;

- (void)unregisterHotKeys;

#pragma mark -

- (NSArray *)registeredHotKeys;

- (ZeroKitHotKey *)registeredHotKeyForName: (NSString *)name;

#pragma mark -

- (BOOL)isHotKeyRegistered: (ZeroKitHotKey *)hotKey;

@end
