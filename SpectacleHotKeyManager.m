#import "SpectacleHotKeyManager.h"
#import "SpectacleConstants.h"

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *data);

#pragma mark -

@interface SpectacleHotKeyManager (SpectacleHotKeyManagerPrivate)

- (void)updateUserDefaults;

#pragma mark -

- (void)installHotKeyEventHandler;

#pragma mark -

- (ZeroKitHotKey *)registeredHotKeyForHandle: (NSInteger)handle;

#pragma mark -

- (OSStatus)handleHotKeyEvent: (EventRef)event;

@end

#pragma mark -

@implementation SpectacleHotKeyManager

static SpectacleHotKeyManager *sharedInstance = nil;

- (id)init {
    if ((self = [super init])) {
        myRegisteredHotKeys = [[NSMutableDictionary alloc] init];
        myCurrentHotKeyID = 0;
        isHotKeyHandlerInstalled = NO;
    }
    
    return self;
}

#pragma mark -

+ (id)allocWithZone: (NSZone *)zone {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone: zone];
            
            return sharedInstance;
        }
    }
    
    return nil;
}

#pragma mark -

+ (SpectacleHotKeyManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSInteger)registerHotKey: (ZeroKitHotKey *)hotKey {
    NSString *hotKeyName = [hotKey hotKeyName];
    ZeroKitHotKey *existingHotKey = [self registeredHotKeyForName: hotKeyName];
    EventHotKeyID hotKeyID;
    EventHotKeyRef hotKeyRef;
    OSStatus err;
    
    if (existingHotKey) {
        [hotKey setHotKeyAction: [existingHotKey hotKeyAction]];
        
        [self unregisterHotKeyForName: hotKeyName];
    }
    
    hotKeyID.signature = 'ZERO';
    hotKeyID.id = ++myCurrentHotKeyID;
    
    err = RegisterEventHotKey([hotKey hotKeyCode],
                              [hotKey hotKeyModifiers],
                              hotKeyID,
                              GetEventDispatcherTarget(),
                              0,
                              &hotKeyRef);
    
    if (err) {
        NSLog(@"There was a problem registering hot key %@.", hotKeyName);
        
        return -1;
    }
    
    [hotKey setHandle: hotKeyID.id];
    [hotKey setHotKeyRef: hotKeyRef];
    
    [myRegisteredHotKeys setObject: hotKey forKey: hotKeyName];
    
    [self updateUserDefaults];
    
    [self installHotKeyEventHandler];
    
    return [hotKey handle];
}

- (void)registerHotKeys: (NSArray *)hotKeys {
    for (ZeroKitHotKey *hotKey in hotKeys) {
        [self registerHotKey: hotKey];
    }
}

#pragma mark -

- (void)unregisterHotKeyForName: (NSString *)name {
    ZeroKitHotKey *hotKey = [self registeredHotKeyForName: name];
    EventHotKeyRef hotKeyRef;
    OSStatus err;
    
    if (!hotKey) {
        NSLog(@"The specified hot key has not been registered.");
        
        return;
    }
    
    hotKeyRef = [hotKey hotKeyRef];
    
    if (hotKeyRef) {
        err = UnregisterEventHotKey(hotKeyRef);
        
        if (err) {
            NSLog(@"Receiving the following error code when unregistering hot key %@: %d", name, err);
        }
        
        [myRegisteredHotKeys setObject: [ZeroKitHotKey clearedHotKeyWithName: name] forKey: name];
        
        [self updateUserDefaults];
    } else {
        NSLog(@"Unable to unregister hot key %@, no hotKeyRef appears to exist.", name);
    }
}

- (void)unregisterHotKeys {
    for (ZeroKitHotKey *hotKey in [myRegisteredHotKeys allValues]) {
        [self unregisterHotKeyForName: [hotKey hotKeyName]];
    }
}

#pragma mark -

- (NSArray *)registeredHotKeys {
    return [myRegisteredHotKeys allValues];
}

- (ZeroKitHotKey *)registeredHotKeyForName: (NSString *)name {
    ZeroKitHotKey *hotKey = [myRegisteredHotKeys objectForKey: name];
    
    if ([hotKey isClearedHotKey]) {
        hotKey = nil;
    }
    
    return hotKey;
}

#pragma mark -

- (BOOL)isHotKeyRegistered: (ZeroKitHotKey *)hotKey {
    for (ZeroKitHotKey *registeredHotKey in [myRegisteredHotKeys allValues]) {
        if ([registeredHotKey isEqualToHotKey: hotKey]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -

- (void)dealloc {
    [myRegisteredHotKeys release];
    
    [super dealloc];
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
    
    for (ZeroKitHotKey *hotKey in [myRegisteredHotKeys allValues]) {
        NSData *hotKeyData = [NSKeyedArchiver archivedDataWithRootObject: hotKey];
        NSString *hotKeyName = [hotKey hotKeyName];
        
        if (![hotKeyData isEqualToData: [userDefaults dataForKey: hotKeyName]]) {
            [userDefaults setObject: hotKeyData forKey: hotKeyName];
        }
    }
}

#pragma mark -

- (void)installHotKeyEventHandler {
    if (([myRegisteredHotKeys count] > 0) && !isHotKeyHandlerInstalled) {
        EventTypeSpec typeSpec;
        
        typeSpec.eventClass = kEventClassKeyboard;
        typeSpec.eventKind = kEventHotKeyPressed;
        
        InstallApplicationEventHandler(&hotKeyEventHandler, 1, &typeSpec, NULL, NULL);
        
        isHotKeyHandlerInstalled = YES;
    }
}

#pragma mark -

- (ZeroKitHotKey *)registeredHotKeyForHandle: (NSInteger)handle {
    for (ZeroKitHotKey *hotKey in [myRegisteredHotKeys allValues]) {
        if ([hotKey handle] == handle) {
            return hotKey;
        }
    }
    
    return nil;
}

#pragma mark -

- (OSStatus)handleHotKeyEvent: (EventRef)event {
    ZeroKitHotKey *hotKey;
    EventHotKeyID hotKeyID;
    OSStatus err = GetEventParameter(event,
                                     kEventParamDirectObject,
                                     typeEventHotKeyID,
                                     NULL,
                                     sizeof(EventHotKeyID),
                                     NULL,
                                     &hotKeyID);
    
    if (err) {
        return err;
    }
    
    hotKey = [self registeredHotKeyForHandle: hotKeyID.id];
    
    if (!hotKey) {
        NSLog(@"Unable to handle event for hot key with handle %d, the registered hot key does not exist.", hotKeyID.id);
    }
    
    switch (GetEventKind(event)) {
        case kEventHotKeyPressed:
            [[hotKey hotKeyAction] trigger];
            
            break;
        default:
            break;
    }
    
    return noErr;
}

@end
