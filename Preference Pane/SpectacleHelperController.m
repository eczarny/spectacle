#import "SpectacleHelperController.h"
#import "SpectacleHotKeyManager.h"
#import "SpectacleHelperApplicationController.h"
#import "SpectaclePreferencePaneUtilities.h"

@implementation SpectacleHelperController

- (id)init {
    if (self = [super init]) {
        myHotKeyManager = [SpectacleHotKeyManager sharedManager];
    }
    
    return self;
}

#pragma mark -

- (ZeroKitHotKey *)registeredHotKeyForName: (NSString *)name {
    return [myHotKeyManager registeredHotKeyForName: name];
}

#pragma mark -

- (void)updateHotKeyWithKeyCode: (NSInteger)keyCode modifiers: (NSInteger)modifiers name: (NSString *)name {
    ZeroKitHotKey *hotKey = [[[ZeroKitHotKey alloc] initWithHotKeyCode: keyCode hotKeyModifiers: modifiers] autorelease];
    
    [hotKey setHotKeyName: name];
    
    [hotKey setHotKeyAction: [SpectaclePreferencePaneUtilities actionForHotKeyWithName: name target: myHelperApplicationController]];
    
    [myHotKeyManager registerHotKey: hotKey];
}

#pragma mark -

- (void)unregisterHotKeyWithName: (NSString *)name {
    [myHotKeyManager unregisterHotKeyForName: name];
}

@end
