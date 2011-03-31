// 
// Copyright (c) 2011 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

#import "SpectacleHotKeyManager.h"
#import "SpectacleHotKey.h"
#import "SpectacleHotKeyAction.h"
#import "SpectacleConstants.h"

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *data);

#pragma mark -

@interface SpectacleHotKeyManager (SpectacleHotKeyManagerPrivate)

- (void)updateUserDefaults;

#pragma mark -

- (void)installHotKeyEventHandler;

#pragma mark -

- (SpectacleHotKey *)registeredHotKeyForHandle: (NSInteger)handle;

#pragma mark -

- (OSStatus)handleHotKeyEvent: (EventRef)event;

@end

#pragma mark -

@implementation SpectacleHotKeyManager

static SpectacleHotKeyManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
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

- (NSInteger)registerHotKey: (SpectacleHotKey *)hotKey {
    NSString *hotKeyName = [hotKey hotKeyName];
    SpectacleHotKey *existingHotKey = [self registeredHotKeyForName: hotKeyName];
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
    for (SpectacleHotKey *hotKey in hotKeys) {
        [self registerHotKey: hotKey];
    }
}

#pragma mark -

- (void)unregisterHotKeyForName: (NSString *)name {
    SpectacleHotKey *hotKey = [self registeredHotKeyForName: name];
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
        
        [myRegisteredHotKeys removeObjectForKey: name];
        
        [self updateUserDefaults];
    } else {
        NSLog(@"Unable to unregister hot key %@, no hotKeyRef appears to exist.", name);
    }
}

- (void)unregisterHotKeys {
    for (SpectacleHotKey *hotKey in [myRegisteredHotKeys allValues]) {
        [self unregisterHotKeyForName: [hotKey hotKeyName]];
    }
}

#pragma mark -

- (NSArray *)registeredHotKeys {
    return [myRegisteredHotKeys allValues];
}

- (SpectacleHotKey *)registeredHotKeyForName: (NSString *)name {
    return [myRegisteredHotKeys objectForKey: name];
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
    
    for (SpectacleHotKey *hotKey in [myRegisteredHotKeys allValues]) {
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

- (SpectacleHotKey *)registeredHotKeyForHandle: (NSInteger)handle {
    for (SpectacleHotKey *hotKey in [myRegisteredHotKeys allValues]) {
        if ([hotKey handle] == handle) {
            return hotKey;
        }
    }
    
    return nil;
}

#pragma mark -

- (OSStatus)handleHotKeyEvent: (EventRef)event {
    SpectacleHotKey *hotKey;
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
