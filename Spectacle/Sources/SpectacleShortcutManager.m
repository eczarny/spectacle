#import <Carbon/Carbon.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutManager.h"

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *shortcutManager);

static EventHotKeyID currentShortcutID = {
  .signature = 'ZERO',
  .id = 0
};

#pragma mark -

@implementation SpectacleShortcutManager
{
  id<SpectacleShortcutStorageProtocol> _shortcutStorage;
  NSMutableDictionary<NSString *, SpectacleShortcut *> *_registeredShortcutsByName;
  BOOL _areShorcutsEnabled;
}

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorageProtocol>)shortcutStorage
{
  if (self = [super init]) {
    _shortcutStorage = shortcutStorage;
    _registeredShortcutsByName = [NSMutableDictionary new];
    _areShorcutsEnabled = YES;

    [self installApplicationEventHandler];
  }

  return self;
}

#pragma mark -

- (void)registerShortcut:(SpectacleShortcut *)shortcut
{
  NSString *shortcutName = shortcut.shortcutName;
  SpectacleShortcut *existingShortcut = [self registeredShortcutForName:shortcutName];

  if (existingShortcut) {
    [shortcut setShortcutAction:existingShortcut.shortcutAction];

    [self unregisterShortcutForName:shortcutName];
  }

  if (_areShorcutsEnabled) {
    [self registerEventHotKey:shortcut];
  }

  _registeredShortcutsByName[shortcutName] = shortcut;

  [self storeRegisteredShortcuts];
}

- (void)unregisterShortcutForName:(NSString *)name
{
  SpectacleShortcut *shortcut = [self registeredShortcutForName:name];

  if (!shortcut) {
    NSLog(@"The specified shortcut has not been registered.");

    return;
  }

  BOOL eventHotKeyUnregistered = NO;

  if (_areShorcutsEnabled) {
    eventHotKeyUnregistered = [self unregisterEventHotKey:shortcut];
  }

  _registeredShortcutsByName[name] = [SpectacleShortcut clearedShortcutWithName:name];

  if (_areShorcutsEnabled && !eventHotKeyUnregistered) {
    _registeredShortcutsByName[name] = shortcut;
  }

  [self storeRegisteredShortcuts];
}

- (void)registerShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts
{
  for (SpectacleShortcut *shortcut in shortcuts) {
    [self registerShortcut:shortcut];
  }
}

- (void)unregisterShortcuts
{
  for (SpectacleShortcut *shortcut in self.registeredShortcuts) {
    [self unregisterShortcutForName:shortcut.shortcutName];
  }
}

#pragma mark -

- (NSArray<SpectacleShortcut *> *)registeredShortcuts
{
  return _registeredShortcutsByName.allValues;
}

- (SpectacleShortcut *)registeredShortcutForName:(NSString *)name
{
  SpectacleShortcut *shortcut = _registeredShortcutsByName[name];

  if (shortcut.isClearedShortcut) {
    shortcut = nil;
  }

  return shortcut;
}

#pragma mark -

- (BOOL)isShortcutRegistered:(SpectacleShortcut *)shortcut
{
  for (SpectacleShortcut *registeredShortcut in self.registeredShortcuts) {
    if ([registeredShortcut isEqualToShortcut:shortcut]) {
      return YES;
    }
  }

  return NO;
}

#pragma mark -

- (void)enableShortcuts
{
  if (_areShorcutsEnabled) return;

  for (SpectacleShortcut *shortcut in self.registeredShortcuts) {
    [self registerEventHotKey:shortcut];
  }

  _areShorcutsEnabled = YES;
}

- (void)disableShortcuts
{
  if (!_areShorcutsEnabled) return;

  for (SpectacleShortcut *shortcut in self.registeredShortcuts) {
    [self unregisterEventHotKey:shortcut];
  }

  _areShorcutsEnabled = NO;
}

#pragma mark -

- (void)installApplicationEventHandler
{
  EventTypeSpec typeSpec;

  typeSpec.eventClass = kEventClassKeyboard;
  typeSpec.eventKind = kEventHotKeyPressed;

  InstallApplicationEventHandler(&hotKeyEventHandler, 1, &typeSpec, (__bridge void*)self, NULL);
}

#pragma mark -

- (void)storeRegisteredShortcuts
{
  [_shortcutStorage storeShortcuts:self.registeredShortcuts];
}

#pragma mark -

- (SpectacleShortcut *)registeredShortcutForShortcutID:(EventHotKeyID)shortcutID
{
  for (SpectacleShortcut *shortcut in self.registeredShortcuts) {
    if (shortcut.shortcutID.id == shortcutID.id) {
      return shortcut;
    }
  }

  return nil;
}

#pragma mark -

- (void)registerEventHotKey:(SpectacleShortcut *)shortcut
{
  if (shortcut.isClearedShortcut) return;

  EventHotKeyRef shortcutRef;
  EventTargetRef eventTarget = GetApplicationEventTarget();
  OSStatus err;

  currentShortcutID.id = ++currentShortcutID.id;

  err = RegisterEventHotKey((unsigned int)shortcut.shortcutCode,
                            (unsigned int)shortcut.shortcutModifiers,
                            currentShortcutID,
                            eventTarget,
                            0,
                            &shortcutRef);

  if (err) {
    NSLog(@"There was a problem registering shortcut %@.", shortcut.shortcutName);

    return;
  }

  shortcut.shortcutID = currentShortcutID;
  shortcut.ref = shortcutRef;
}

- (BOOL)unregisterEventHotKey:(SpectacleShortcut *)shortcut
{
  EventHotKeyRef shortcutRef;
  OSStatus err;

  shortcutRef = shortcut.ref;

  if (shortcutRef) {
    err = UnregisterEventHotKey(shortcutRef);

    if (err) {
      NSLog(@"Receiving the following error code when unregistering shortcut %@: %d", shortcut.shortcutName, err);

      return NO;
    }
  } else {
    NSLog(@"Unable to unregister shortcut %@, no ref appears to exist.", shortcut.shortcutName);

    return NO;
  }

  return YES;
}

#pragma mark -

- (OSStatus)handleHotKeyEvent:(EventRef)event
{
  SpectacleShortcut *shortcut;
  EventHotKeyID shortcutID;
  OSStatus err = GetEventParameter(event,
                                   kEventParamDirectObject,
                                   typeEventHotKeyID,
                                   NULL,
                                   sizeof(EventHotKeyID),
                                   NULL,
                                   &shortcutID);

  if (err) {
    return err;
  }

  shortcut = [self registeredShortcutForShortcutID:shortcutID];

  if (!shortcut) {
    NSLog(@"Unable to handle event for shortcut with handle %d, the registered shortcut does not exist.", shortcutID.id);
  }

  switch (GetEventKind(event)) {
    case kEventHotKeyPressed:
      [shortcut triggerShortcutAction];

      break;
    default:
      break;
  }

  return noErr;
}

@end

#pragma mark -

OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *shortcutManager)
{
  return [(__bridge SpectacleShortcutManager *)shortcutManager handleHotKeyEvent:event];
}
