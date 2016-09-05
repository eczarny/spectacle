#import "SpectacleDefaultShortcutHelpers.h"

#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

static NSArray<SpectacleShortcut *> *builtinDefaultShortcuts(void);

NSArray<SpectacleShortcut *> *SpectacleDefaultShortcutsWithAction(SpectacleShortcutAction action)
{
  NSMutableArray<SpectacleShortcut *> *defaultShortcuts = [NSMutableArray new];
  for (SpectacleShortcut *defaultShortcut in builtinDefaultShortcuts()) {
    [defaultShortcuts addObject:[defaultShortcut copyWithShortcutAction:action]];
  }
  return defaultShortcuts;
}

static NSArray<SpectacleShortcut *> *builtinDefaultShortcuts(void)
{
  return @[
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"          shortcutKeyBinding:@"alt+cmd+c"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToFullscreen"      shortcutKeyBinding:@"alt+cmd+f"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLeftHalf"        shortcutKeyBinding:@"alt+cmd+left"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToRightHalf"       shortcutKeyBinding:@"alt+cmd+right"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToTopHalf"         shortcutKeyBinding:@"alt+cmd+up"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToBottomHalf"      shortcutKeyBinding:@"alt+cmd+down"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperLeft"       shortcutKeyBinding:@"ctrl+cmd+left"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerLeft"       shortcutKeyBinding:@"ctrl+shift+cmd+left"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperRight"      shortcutKeyBinding:@"ctrl+cmd+right"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerRight"      shortcutKeyBinding:@"ctrl+shift+cmd+right"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextDisplay"     shortcutKeyBinding:@"ctrl+alt+cmd+right"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousDisplay" shortcutKeyBinding:@"ctrl+alt+cmd+left"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextThird"       shortcutKeyBinding:@"ctrl+alt+right"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousThird"   shortcutKeyBinding:@"ctrl+alt+left"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeLarger"            shortcutKeyBinding:@"ctrl+alt+shift+right"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeSmaller"           shortcutKeyBinding:@"ctrl+alt+shift+left"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"UndoLastMove"          shortcutKeyBinding:@"alt+cmd+z"],
           [[SpectacleShortcut alloc] initWithShortcutName:@"RedoLastMove"          shortcutKeyBinding:@"alt+shift+cmd+z"],
           ];
}
