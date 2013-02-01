#import "SpectacleHotKeyManager.h"
#import "SpectacleConstants.h"

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *data);

#pragma mark -

@interface SpectacleHotKeyManager (SpectacleHotKeyManagerPrivate)

- (void)updateUserDefaults;

#pragma mark -

- (void)installHotKeyEventHandler;

#pragma mark -

- (ZKHotKey *)registeredHotKeyForHandle: (NSInteger)handle;

#pragma mark -

- (OSStatus)handleHotKeyEvent: (EventRef)event;

@end

#pragma mark -

@implementation SpectacleHotKeyManager

static SpectacleHotKeyManager *sharedInstance = nil;

- (id)init {
    if ((self = [super init])) {
        registeredHotKeys = [NSMutableDictionary new];
        currentHotKeyID = 0;
        isHotKeyHandlerInstalled = NO;
    }
    
    return self;
}

#pragma mark -

+ (SpectacleHotKeyManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [self new];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSInteger)registerHotKey: (ZKHotKey *)hotKey {
    NSString *hotKeyName = [hotKey hotKeyName];
    ZKHotKey *existingHotKey = [self registeredHotKeyForName: hotKeyName];
    EventHotKeyID hotKeyID;
    EventHotKeyRef hotKeyRef;
    EventTargetRef eventTarget = GetEventDispatcherTarget();
    OSStatus error;
    
    if (existingHotKey) {
        [hotKey setHotKeyAction: [existingHotKey hotKeyAction]];
        
        [self unregisterHotKeyForName: hotKeyName];
    }
    
    hotKeyID.signature = 'ZERO';
    hotKeyID.id = ++currentHotKeyID;
    
    error = RegisterEventHotKey((UInt32)[hotKey hotKeyCode], (UInt32)[hotKey hotKeyModifiers], hotKeyID, eventTarget, 0, &hotKeyRef);
    
    if (error) {
        NSLog(@"There was a problem registering hot key %@.", hotKeyName);
        
        return -1;
    }
    
    [hotKey setHandle: hotKeyID.id];
    [hotKey setHotKeyRef: hotKeyRef];
    
    registeredHotKeys[hotKeyName] = hotKey;
    
    [self updateUserDefaults];
    
    [self installHotKeyEventHandler];
    
    return [hotKey handle];
}

- (void)registerHotKeys: (NSArray *)hotKeys {
    for (ZKHotKey *hotKey in hotKeys) {
        [self registerHotKey: hotKey];
    }
}

#pragma mark -

- (void)unregisterHotKeyForName: (NSString *)name {
    ZKHotKey *hotKey = [self registeredHotKeyForName: name];
    EventHotKeyRef hotKeyRef;
    OSStatus error;
    
    if (!hotKey) {
        NSLog(@"The specified hot key has not been registered.");
        
        return;
    }
    
    hotKeyRef = [hotKey hotKeyRef];
    
    if (hotKeyRef) {
        error = UnregisterEventHotKey(hotKeyRef);
        
        if (error) {
            NSLog(@"Receiving the following error code when unregistering hot key %@: %d", name, error);
        }
        
        registeredHotKeys[name] = [ZKHotKey clearedHotKeyWithName: name];
        
        [self updateUserDefaults];
    } else {
        NSLog(@"Unable to unregister hot key %@, no hotKeyRef appears to exist.", name);
    }
}

- (void)unregisterHotKeys {
    for (ZKHotKey *hotKey in [registeredHotKeys allValues]) {
        [self unregisterHotKeyForName: [hotKey hotKeyName]];
    }
}

#pragma mark -

- (NSArray *)registeredHotKeys {
    return [registeredHotKeys allValues];
}

- (ZKHotKey *)registeredHotKeyForName: (NSString *)name {
    ZKHotKey *hotKey = registeredHotKeys[name];
    
    if ([hotKey isClearedHotKey]) {
        hotKey = nil;
    }
    
    return hotKey;
}

#pragma mark -

- (BOOL)isHotKeyRegistered: (ZKHotKey *)hotKey {
    for (ZKHotKey *registeredHotKey in [registeredHotKeys allValues]) {
        if ([registeredHotKey isEqualToHotKey: hotKey]) {
            return YES;
        }
    }
    
    return NO;
}

@end

#pragma mark -

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *data) {
    return [[SpectacleHotKeyManager sharedManager] handleHotKeyEvent: event];
}

#pragma mark -

@implementation SpectacleHotKeyManager (SpectacleHotKeyManagerPrivate)

- (void)updateUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (ZKHotKey *hotKey in [registeredHotKeys allValues]) {
        NSData *hotKeyData = [NSKeyedArchiver archivedDataWithRootObject: hotKey];
        NSString *hotKeyName = [hotKey hotKeyName];
        
        if (![hotKeyData isEqualToData: [userDefaults dataForKey: hotKeyName]]) {
            [userDefaults setObject: hotKeyData forKey: hotKeyName];
        }
    }
}

#pragma mark -

- (void)installHotKeyEventHandler {
    if (([registeredHotKeys count] > 0) && !isHotKeyHandlerInstalled) {
        EventTypeSpec typeSpec;
        
        typeSpec.eventClass = kEventClassKeyboard;
        typeSpec.eventKind = kEventHotKeyPressed;
        
        InstallApplicationEventHandler(&hotKeyEventHandler, 1, &typeSpec, NULL, NULL);
        
        isHotKeyHandlerInstalled = YES;
    }
}

#pragma mark -

- (ZKHotKey *)registeredHotKeyForHandle: (NSInteger)handle {
    for (ZKHotKey *hotKey in [registeredHotKeys allValues]) {
        if ([hotKey handle] == handle) {
            return hotKey;
        }
    }
    
    return nil;
}

#pragma mark -

- (OSStatus)handleHotKeyEvent: (EventRef)event {
    ZKHotKey *hotKey;
    EventHotKeyID hotKeyID;
    OSStatus error = GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(EventHotKeyID), NULL, &hotKeyID);
    
    if (error) {
        return error;
    }
    
    hotKey = [self registeredHotKeyForHandle: hotKeyID.id];
    
    if (!hotKey) {
        NSLog(@"Unable to handle event for hot key with handle %d, the registered hot key does not exist.", hotKeyID.id);
    }
    
    switch (GetEventKind(event)) {
        case kEventHotKeyPressed:
            [hotKey triggerHotKeyAction];
            
            break;
        default:
            break;
    }
    
    return 0;
}

@end
