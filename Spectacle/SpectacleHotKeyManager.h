#import <Foundation/Foundation.h>

@class ZKHotKey;

@interface SpectacleHotKeyManager : NSObject

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
