#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class SpectacleHotKey;

@interface SpectacleHotKeyManager : NSObject {
    NSMutableDictionary *myRegisteredHotKeys;
    NSInteger myCurrentHotKeyID;
    BOOL isHotKeyHandlerInstalled;
}

+ (SpectacleHotKeyManager *)sharedManager;

#pragma mark -

- (NSInteger)registerHotKey: (SpectacleHotKey *)hotKey;

- (void)registerHotKeys: (NSArray *)hotKeys;

#pragma mark -

- (void)unregisterHotKeyForName: (NSString *)name;

- (void)unregisterHotKeys;

#pragma mark -

- (NSArray *)registeredHotKeys;

- (SpectacleHotKey *)registeredHotKeyForName: (NSString *)name;

@end
