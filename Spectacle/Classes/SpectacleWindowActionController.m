#import "SpectacleWindowActionController.h"

#import "SpectacleShortcutManager.h"
#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"

@interface SpectacleWindowActionController ()

@property (nonatomic) SpectacleWindowPositionManager *windowPositionManager;
@property (nonatomic) SpectacleShortcutManager *shortcutManager;

@end

#pragma mark -

@implementation SpectacleWindowActionController

- (instancetype)init
{
  if (self = [super init]) {
    _windowPositionManager = SpectacleWindowPositionManager.sharedManager;
    _shortcutManager = SpectacleShortcutManager.sharedManager;
  }
  
  return self;
}

#pragma mark -

- (void)registerShortcuts
{
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  NSMutableDictionary *shortcutsFromUserDefaults = [NSMutableDictionary new];
  
  for (NSString *shortcutName in SpectacleUtilities.shortcutNames) {
    shortcutsFromUserDefaults[shortcutName] = [userDefaults dataForKey:shortcutName];
  }

  NSArray *shortcuts = [SpectacleUtilities shortcutsFromDictionary:shortcutsFromUserDefaults
                                                            action:^(SpectacleShortcut *shortcut) {
    [self.windowPositionManager moveFrontMostWindowWithAction:[_windowPositionManager windowActionForShortcut:shortcut]];
  }];

  [self.shortcutManager registerShortcuts:shortcuts];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToCenter:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionCenter];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToFullscreen:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionFullscreen];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToLeftHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionLeftHalf];
}

- (IBAction)moveFrontMostWindowToRightHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionRightHalf];
}

- (IBAction)moveFrontMostWindowToTopHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionTopHalf];
}

- (IBAction)moveFrontMostWindowToBottomHalf:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionBottomHalf];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperLeft:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionUpperLeft];
}

- (IBAction)moveFrontMostWindowToLowerLeft:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionLowerLeft];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToUpperRight:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionUpperRight];
}

- (IBAction)moveFrontMostWindowToLowerRight:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionLowerRight];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextDisplay:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionNextDisplay];
}

- (IBAction)moveFrontMostWindowToPreviousDisplay:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionPreviousDisplay];
}

#pragma mark -

- (IBAction)moveFrontMostWindowToNextThird:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionNextThird];
}

- (IBAction)moveFrontMostWindowToPreviousThird:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionPreviousThird];
}

#pragma mark -

- (IBAction)makeFrontMostWindowLarger:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionLarger];
}

- (IBAction)makeFrontMostWindowSmaller:(id)sender
{
  [self.windowPositionManager moveFrontMostWindowWithAction:SpectacleWindowActionSmaller];
}

#pragma mark -

- (IBAction)undoLastWindowAction:(id)sender
{
  [self.windowPositionManager undoLastWindowAction];
}

- (IBAction)redoLastWindowAction:(id)sender
{
  [self.windowPositionManager redoLastWindowAction];
}

@end
