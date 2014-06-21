#import <Foundation/Foundation.h>

@class ZKHotKey;

@interface SpectacleHotKeyManager : NSObject

@property (nonatomic) BOOL hotKeysEnabled;

- (void)setHotKeysEnabled: (BOOL)hotKeysEnabled;

#pragma mark -

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
