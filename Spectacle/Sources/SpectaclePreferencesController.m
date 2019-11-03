#import "SpectaclePreferencesController.h"

#import <QuartzCore/QuartzCore.h>

#import "SpectacleAccessibilityElement.h"
#import "SpectacleDefaultShortcutHelpers.h"
#import "SpectacleLoginItemHelper.h"
#import "SpectacleRegisteredShortcutValidator.h"
#import "SpectacleShortcut.h"
#import "SpectacleShortcutManager.h"
#import "SpectacleShortcutRecorder.h"
#import "SpectacleShortcutStorage.h"
#import "SpectacleShortcutValidation.h"
#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"

@implementation SpectaclePreferencesController
{
  SpectacleShortcutManager *_shortcutManager;
  SpectacleWindowPositionManager *_windowPositionManager;
  id<SpectacleShortcutStorage> _shortcutStorage;
  NSDictionary<NSString *, SpectacleShortcutRecorder *> *_shortcutRecorders;
}

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                  windowPositionManager:(SpectacleWindowPositionManager *)windowPositionManager
                        shortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage
{
  if (self = [super initWithWindowNibName:@"SpectaclePreferencesWindow"]) {
    _shortcutManager = shortcutManager;
    _windowPositionManager = windowPositionManager;
    _shortcutStorage = shortcutStorage;
  }
  return self;
}

- (void)windowDidLoad
{
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  NSInteger loginItemEnabledState = NSOffState;
  BOOL isStatusItemEnabled = [NSUserDefaults.standardUserDefaults boolForKey:@"StatusItemEnabled"];
  _shortcutRecorders = @{
                         @"MoveToCenter": _moveToCenterShortcutRecorder,
                         @"MoveToFullscreen": _moveToFullscreenShortcutRecorder,
                         @"MoveToLeftHalf": _moveToLeftShortcutRecorder,
                         @"MoveToRightHalf": _moveToRightShortcutRecorder,
                         @"MoveToTopHalf": _moveToTopShortcutRecorder,
                         @"MoveToBottomHalf": _moveToBottomShortcutRecorder,
                         @"MoveToUpperLeft": _moveToUpperLeftShortcutRecorder,
                         @"MoveToLowerLeft": _moveToLowerLeftShortcutRecorder,
                         @"MoveToUpperRight": _moveToUpperRightShortcutRecorder,
                         @"MoveToLowerRight": _moveToLowerRightShortcutRecorder,
                         @"MoveToNextDisplay": _moveToNextDisplayShortcutRecorder,
                         @"MoveToPreviousDisplay": _moveToPreviousDisplayShortcutRecorder,
                         @"MoveToNextThird": _moveToNextThirdShortcutRecorder,
                         @"MoveToPreviousThird": _moveToPreviousThirdShortcutRecorder,
                         @"MakeLarger": _makeLargerShortcutRecorder,
                         @"MakeSmaller": _makeSmallerShortcutRecorder,
                         @"UndoLastMove": _undoLastMoveShortcutRecorder,
                         @"RedoLastMove": _redoLastMoveShortcutRecorder,
                         };
  [self loadRegisteredShortcuts];
  [notificationCenter addObserver:self
                         selector:@selector(loadRegisteredShortcuts)
                             name:@"SpectacleShortcutChangedNotification"
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(loadRegisteredShortcuts)
                             name:@"SpectacleRestoreDefaultShortcutsNotification"
                           object:nil];
  if ([SpectacleLoginItemHelper isLoginItemEnabledForBundle:NSBundle.mainBundle]) {
    loginItemEnabledState = NSOnState;
  }
  self.loginItemEnabled.state = loginItemEnabledState;
  [self.statusItemEnabled selectItemWithTag:isStatusItemEnabled ? 0 : 1];
  self.window.title = [@"Spectacle " stringByAppendingString:SpectacleUtilities.applicationVersion];
  self.footerView.wantsLayer = YES;
}

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
   didReceiveNewShortcut:(SpectacleShortcut *)shortcut
{
  [_shortcutManager updateShortcut:[shortcut copyWithShortcutAction:^(SpectacleShortcut *shortcut) {
    [self->_windowPositionManager moveFrontmostWindowElement:[SpectacleAccessibilityElement frontmostWindowElement]
                                                      action:shortcut.windowAction];
  }]];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SpectacleShortcutChangedNotification" object:self];
}

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
didClearExistingShortcut:(SpectacleShortcut *)shortcut
{
  [_shortcutManager clearShortcut:shortcut];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SpectacleShortcutChangedNotification" object:self];
}

- (void)loadRegisteredShortcuts
{
  for (NSString *shortcutName in _shortcutRecorders.allKeys) {
    SpectacleShortcutRecorder *shortcutRecorder = _shortcutRecorders[shortcutName];
    SpectacleShortcut *shortcut = [_shortcutManager shortcutForShortcutName:shortcutName];
    shortcutRecorder.shortcutName = shortcutName;
    shortcutRecorder.shortcut = shortcut;
    shortcutRecorder.delegate = self;
    shortcutRecorder.shortcutValidation =
    [[SpectacleShortcutValidation alloc] initWithShortcutManager:_shortcutManager
                                                      validators:@[
                                                                   [SpectacleRegisteredShortcutValidator new],
                                                                   ]];
  }
}

- (IBAction)swapFooterViews:(id)sender
{
  CATransition *transition = [CATransition animation];
  NSView *currentFooterView = self.footerView.subviews[0];
  NSView *nextFooterView = nil;
  transition.type = kCATransitionPush;
  if (currentFooterView == self.shortcutModifierLegendFooterView) {
    nextFooterView = self.optionsFooterView;
    transition.subtype = kCATransitionFromRight;
  } else {
    nextFooterView = self.shortcutModifierLegendFooterView;
    transition.subtype = kCATransitionFromLeft;
  }
  self.footerView.animations = @{@"subviews": transition};
  [self.footerView.animator replaceSubview:currentFooterView
                                      with:nextFooterView];
}

- (IBAction)restoreDefaults:(id)sender
{
  [SpectacleUtilities displayRestoreDefaultsAlertWithConfirmationCallback:^() {
    NSArray<SpectacleShortcut *> *shortcuts = SpectacleDefaultShortcutsWithAction(^(SpectacleShortcut *shortcut) {
      [self->_windowPositionManager moveFrontmostWindowElement:[SpectacleAccessibilityElement frontmostWindowElement]
                                                        action:shortcut.windowAction];
    });
    [self->_shortcutManager updateShortcuts:shortcuts];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SpectacleRestoreDefaultShortcutsNotification"
                                                        object:self];
  }];
}

- (IBAction)toggleLoginItem:(id)sender
{
  NSBundle *applicationBundle = NSBundle.mainBundle;
  if (self.loginItemEnabled.state == NSOnState) {
    [SpectacleLoginItemHelper enableLoginItemForBundle:applicationBundle];
  } else {
    [SpectacleLoginItemHelper disableLoginItemForBundle:applicationBundle];
  }
}

- (IBAction)toggleStatusItem:(id)sender
{
  NSString *notificationName = @"SpectacleStatusItemEnabledNotification";
  BOOL isStatusItemEnabled = YES;
  __block BOOL statusItemStateChanged = YES;
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  if ([userDefaults boolForKey:@"StatusItemEnabled"] == ([[sender selectedItem] tag] == 0)) {
    return;
  }
  if ([sender selectedItem].tag != 0) {
    notificationName = @"SpectacleStatusItemDisabledNotification";
    isStatusItemEnabled = NO;
    if (![userDefaults boolForKey:@"BackgroundAlertSuppressed"]) {
      [SpectacleUtilities displayRunningInBackgroundAlertWithCallback:^(BOOL isConfirmed, BOOL isSuppressed) {
        if (!isConfirmed) {
          statusItemStateChanged = NO;
          [sender selectItemWithTag:0];
        }
        [userDefaults setBool:isSuppressed forKey:@"BackgroundAlertSuppressed"];
      }];
    }
  }
  if (statusItemStateChanged) {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    [userDefaults setBool:isStatusItemEnabled forKey:@"StatusItemEnabled"];
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
