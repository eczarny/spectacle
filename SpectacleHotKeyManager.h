#import <Foundation/Foundation.h>
#import <ZeroKit/ZeroKit.h>

@interface SpectacleHotKeyManager : NSObject {
    NSMutableDictionary *registeredHotKeys;
    UInt32 currentHotKeyID;
    BOOL isHotKeyHandlerInstalled;
}

+ (SpectacleHotKeyManager *)sharedManager;

#pragma mark -

- (NSInteger)registerHotKey: (ZKHotKey *)hotKey;

- (void)registerHotKeys: (NSArray *)hotKeys;

#pragma mark -

- (void)unregisterHotKeyForName: (NSString *)name;

- (void)unregisterHotKeys;

#pragma mark -

- (NSArray *)registeredHotKeys;

- (ZKHotKey *)registeredHotKeyForName: (NSString *)name;

#pragma mark -

- (BOOL)isHotKeyRegistered: (ZKHotKey *)hotKey;

@end
