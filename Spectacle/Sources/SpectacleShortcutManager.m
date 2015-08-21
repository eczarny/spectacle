#import <Carbon/Carbon.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutManager.h"

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *data);

static EventHotKeyID currentShortcutID = {
  .signature = 'ZERO',
  .id = 0
};

#pragma mark -

@interface SpectacleShortcutManager ()

@property (nonatomic) id<SpectacleShortcutStorageProtocol> shortcutStorage;
@property (nonatomic) NSMutableDictionary *registeredShortcutsByName;
@property (nonatomic) BOOL isShortcutHandlerInstalled;

@end

#pragma mark -

@implementation SpectacleShortcutManager

- (instancetype)initWithShortcutStorage:(id<SpectacleShortcutStorageProtocol>)shortcutStorage
{
  if (self = [super init]) {
    _shortcutStorage = shortcutStorage;
    _registeredShortcutsByName = [NSMutableDictionary new];
    _isShortcutHandlerInstalled = NO;
  }

  return self;
}

#pragma mark -

- (NSInteger)registerShortcut:(SpectacleShortcut *)shortcut
{
  NSString *shortcutName = shortcut.shortcutName;
  SpectacleShortcut *existingShortcut = [self registeredShortcutForName:shortcutName];
  EventHotKeyRef shortcutRef;
  EventTargetRef eventTarget = GetEventDispatcherTarget();
  OSStatus err;

  if (existingShortcut) {
    [shortcut setShortcutAction:existingShortcut.shortcutAction];

    [self unregisterShortcutForName:shortcutName];
  }

  currentShortcutID.id = ++currentShortcutID.id;

  err = RegisterEventHotKey((unsigned int)shortcut.shortcutCode,
                            (unsigned int)shortcut.shortcutModifiers,
                            currentShortcutID,
                            eventTarget,
                            0,
                            &shortcutRef);

  if (err) {
    NSLog(@"There was a problem registering shortcut %@.", shortcutName);

    return -1;
  }

  shortcut.handle = currentShortcutID.id;
  shortcut.ref = shortcutRef;

  self.registeredShortcutsByName[shortcutName] = shortcut;

  [self updateUserDefaults];

  [self installHotKeyEventHandler];

  return shortcut.handle;
}

- (void)registerShortcuts:(NSArray *)shortcuts
{
  for (SpectacleShortcut *shortcut in shortcuts) {
    [self registerShortcut:shortcut];
  }
}

#pragma mark -

- (void)unregisterShortcutForName:(NSString *)name
{
  SpectacleShortcut *shortcut = [self registeredShortcutForName:name];
  EventHotKeyRef shortcutRef;
  OSStatus err;

  if (!shortcut) {
    NSLog(@"The specified shortcut has not been registered.");

    return;
  }

  shortcutRef = shortcut.ref;

  if (shortcutRef) {
    err = UnregisterEventHotKey(shortcutRef);

    if (err) {
      NSLog(@"Receiving the following error code when unregistering shortcut %@: %d", name, err);
    }

    self.registeredShortcutsByName[name] = [SpectacleShortcut clearedShortcutWithName:name];

    [self updateUserDefaults];
  } else {
    NSLog(@"Unable to unregister shortcut %@, no ref appears to exist.", name);
  }
}

- (void)unregisterShortcuts
{
  for (SpectacleShortcut *shortcut in self.registeredShortcuts) {
    [self unregisterShortcutForName:shortcut.shortcutName];
  }
}

#pragma mark -

- (NSArray *)registeredShortcuts
{
  return self.registeredShortcutsByName.allValues;
}

- (SpectacleShortcut *)registeredShortcutForName:(NSString *)name
{
  SpectacleShortcut *shortcut = self.registeredShortcutsByName[name];

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

- (void)updateUserDefaults
{
  [self.shortcutStorage storeShortcuts:self.registeredShortcuts];
}

#pragma mark -

- (void)installHotKeyEventHandler
{
  if ((self.registeredShortcutsByName.count > 0) && !self.isShortcutHandlerInstalled) {
    EventTypeSpec typeSpec;

    typeSpec.eventClass = kEventClassKeyboard;
    typeSpec.eventKind = kEventHotKeyPressed;

    InstallApplicationEventHandler(&hotKeyEventHandler, 1, &typeSpec, (__bridge void*)self, NULL);

    self.isShortcutHandlerInstalled = YES;
  }
}

#pragma mark -

- (SpectacleShortcut *)registeredShortcutForHandle:(NSInteger)handle
{
  for (SpectacleShortcut *shortcut in self.registeredShortcuts) {
    if (shortcut.handle == handle) {
      return shortcut;
    }
  }

  return nil;
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

  shortcut = [self registeredShortcutForHandle:shortcutID.id];

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

  return 0;
}

#pragma mark -

static OSStatus hotKeyEventHandler(EventHandlerCallRef handlerCall, EventRef event, void *shortcutManager)
{
  return [(__bridge SpectacleShortcutManager *)shortcutManager handleHotKeyEvent:event];
}

@end
