#import "SpectacleShortcutManager.h"

#import <Carbon/Carbon.h>

#import "SpectacleShortcutHolder.h"
#import "SpectacleShortcut.h"
#import "SpectacleShortcutStorage.h"

static EventHotKeyID currentShortcutID = {
  .signature = 'ZERO',
  .id = 0
};

@implementation SpectacleShortcutManager
{
  id<SpectacleShortcutStorage> _shortcutStorage;
  NSMutableDictionary<NSString *, SpectacleShortcutHolder *> *_registeredShortcutsByName;
  BOOL _areShorcutsEnabled;
}

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage
{
  if (self = [super init]) {
    _shortcutStorage = shortcutStorage;
    _registeredShortcutsByName = [NSMutableDictionary new];
    _areShorcutsEnabled = YES;
    [self installApplicationEventHandler];
  }
  return self;
}

- (void)manageShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts
{
  for (SpectacleShortcut *shortcut in shortcuts) {
    NSString *shortcutName = shortcut.shortcutName;
    SpectacleShortcutHolder *shortcutHolder = _registeredShortcutsByName[shortcutName];
    if (shortcutHolder) {
      NSLog(@"Unable to add shortcut %@ as it already exists.", shortcutName);
      continue;
    }
    currentShortcutID.id = ++currentShortcutID.id;
    shortcutHolder = [[SpectacleShortcutHolder alloc] initWithShortcutID:currentShortcutID shortcut:shortcut];
    _registeredShortcutsByName[shortcutName] = _areShorcutsEnabled ? [self registerEventHotKey:shortcutHolder] : shortcutHolder;
  }
  [self storeShortcuts];
}

- (void)updateShortcut:(SpectacleShortcut *)shortcut
{
  NSString *shortcutName = shortcut.shortcutName;
  SpectacleShortcutHolder *shortcutHolder = _registeredShortcutsByName[shortcutName];
  if (!shortcutHolder) {
    NSLog(@"Unable to update shortcut %@ as it does not exists.", shortcutName);
    return;
  }
  if (_areShorcutsEnabled && [self unregisterEventHotKey:shortcutHolder]) {
    NSLog(@"Unable to unregister event hot key for shortcut: %@", shortcutName);
    return;
  }
  SpectacleShortcutHolder *registeredShortcutHolder = _areShorcutsEnabled ? [self registerEventHotKey:shortcutHolder] : shortcutHolder;
  _registeredShortcutsByName[shortcutName] = [registeredShortcutHolder
                                              copyWithShortcut:
                                              [shortcut
                                               copyWithShortcutAction:
                                               shortcut.shortcutAction ?: shortcutHolder.shortcut.shortcutAction]];
  [self storeShortcuts];
}

- (void)updateShortcuts:(NSArray<SpectacleShortcut *> *)shortcuts
{
  for (SpectacleShortcut *shortcut in shortcuts) {
    [self updateShortcut:shortcut];
  }
}

- (void)clearShortcut:(SpectacleShortcut *)shortcut
{
  NSString *shortcutName = shortcut.shortcutName;
  SpectacleShortcutHolder *shortcutHolder = _registeredShortcutsByName[shortcutName];
  if (!shortcutHolder) {
    NSLog(@"Unable to clear shortcut %@ as it does not exists.", shortcutName);
    return;
  }
  BOOL eventHotKeyUnregistered = NO;
  if (_areShorcutsEnabled) {
    eventHotKeyUnregistered = [self unregisterEventHotKey:shortcutHolder];
  }
  _registeredShortcutsByName[shortcutName] = [shortcutHolder copyWithClearedShortcut];
  if (_areShorcutsEnabled && !eventHotKeyUnregistered) {
    _registeredShortcutsByName[shortcutName] = shortcutHolder;
  }
  [self storeShortcuts];
}

- (NSArray<SpectacleShortcut *> *)shortcuts
{
  NSMutableArray<SpectacleShortcut *> *shortcuts = [NSMutableArray new];
  for (SpectacleShortcutHolder *shortcutHolder in _registeredShortcutsByName.allValues) {
    [shortcuts addObject:shortcutHolder.shortcut];
  }
  return shortcuts;
}

- (SpectacleShortcut *)shortcutForShortcutName:(NSString *)shortcutName
{
  SpectacleShortcutHolder *shortcutHolder = _registeredShortcutsByName[shortcutName];
  SpectacleShortcut *shortcut = shortcutHolder.shortcut;
  if (shortcut.isClearedShortcut) {
    return nil;
  }
  return shortcut;
}

- (BOOL)doesShortcutExist:(SpectacleShortcut *)shortcut
{
  for (SpectacleShortcutHolder *shortcutHolder in _registeredShortcutsByName.allValues) {
    if ([shortcutHolder.shortcut isEqualToShortcut:shortcut]) {
      return YES;
    }
  }
  return NO;
}

- (void)registerShortcuts
{
  if (_areShorcutsEnabled) {
    return;
  }
  for (SpectacleShortcutHolder *shortcutHolder in _registeredShortcutsByName.allValues) {
    _registeredShortcutsByName[shortcutHolder.shortcut.shortcutName] = [self registerEventHotKey:shortcutHolder];
  }
  _areShorcutsEnabled = YES;
}

- (void)unregisterShortcuts
{
  if (!_areShorcutsEnabled) {
    return;
  }
  for (SpectacleShortcutHolder *shortcutHolder in _registeredShortcutsByName.allValues) {
    [self unregisterEventHotKey:shortcutHolder];
  }
  _areShorcutsEnabled = NO;
}

- (void)installApplicationEventHandler
{
  EventTypeSpec typeSpec;
  typeSpec.eventClass = kEventClassKeyboard;
  typeSpec.eventKind = kEventHotKeyPressed;
  InstallApplicationEventHandler(&hotKeyEventHandler, 1, &typeSpec, (__bridge void*)self, NULL);
}

- (void)storeShortcuts
{
  [_shortcutStorage storeShortcuts:self.shortcuts];
}

- (SpectacleShortcut *)shortcutForShortcutID:(EventHotKeyID)shortcutID
{
  for (SpectacleShortcutHolder *shortcut in _registeredShortcutsByName.allValues) {
    if (shortcut.shortcutID.id == shortcutID.id) {
      return shortcut.shortcut;
    }
  }
  return nil;
}

- (SpectacleShortcutHolder *)registerEventHotKey:(SpectacleShortcutHolder *)shortcutHolder
{
  SpectacleShortcut *shortcut = shortcutHolder.shortcut;
  if (shortcut.isClearedShortcut) {
    return shortcutHolder;
  }
  EventHotKeyRef shortcutRef;
  OSStatus err;
  err = RegisterEventHotKey((unsigned int)shortcut.shortcutKeyCode,
                            (unsigned int)shortcut.shortcutModifiers,
                            shortcutHolder.shortcutID,
                            GetEventDispatcherTarget(),
                            kEventHotKeyNoOptions,
                            &shortcutRef);
  if (err) {
    NSLog(@"There was a problem registering shortcut %@.", shortcut.shortcutName);
    return [shortcutHolder copyWithClearedShortcut];
  }
  return [shortcutHolder copyWithShortcutRef:shortcutRef];
}

- (BOOL)unregisterEventHotKey:(SpectacleShortcutHolder *)shortcutHolder
{
  NSString *shortcutName = shortcutHolder.shortcut.shortcutName;
  EventHotKeyRef shortcutRef = shortcutHolder.shortcutRef;
  OSStatus err;
  if (shortcutRef) {
    err = UnregisterEventHotKey(shortcutRef);
    if (err) {
      NSLog(@"Received the following error code when unregistering shortcut %@: %d", shortcutName, err);
      return NO;
    }
  }
  return YES;
}

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
  shortcut = [self shortcutForShortcutID:shortcutID];
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

OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *shortcutManager)
{
  return [(__bridge SpectacleShortcutManager *)shortcutManager handleHotKeyEvent:event];
}

@end
