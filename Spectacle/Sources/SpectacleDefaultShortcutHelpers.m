#import <Cocoa/Cocoa.h>

#import "SpectacleDefaultShortcutHelpers.h"

static NSArray<SpectacleShortcut *> *builtinDefaultShortcuts(void);

extern NSArray<SpectacleShortcut *> *SpectacleDefaultShortcutsWithAction(SpectacleShortcutAction action)
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
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                              shortcutCode:8 // "C"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToFullscreen"
                                              shortcutCode:3 // "F"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLeftHalf"
                                              shortcutCode:123 // "←"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToRightHalf"
                                              shortcutCode:124 // "→"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToTopHalf"
                                              shortcutCode:126 // "↑"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToBottomHalf"
                                              shortcutCode:125 // "↓"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperLeft"
                                              shortcutCode:123 // "←"
                                         shortcutModifiers:NSControlKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerLeft"
                                              shortcutCode:123 // "←"
                                         shortcutModifiers:NSControlKeyMask|NSShiftKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperRight"
                                              shortcutCode:124 // "→"
                                         shortcutModifiers:NSControlKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerRight"
                                              shortcutCode:124 // "→"
                                         shortcutModifiers:NSControlKeyMask|NSShiftKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextDisplay"
                                              shortcutCode:124 // "→"
                                         shortcutModifiers:NSControlKeyMask|NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousDisplay"
                                              shortcutCode:123 // "←"
                                         shortcutModifiers:NSControlKeyMask|NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextThird"
                                              shortcutCode:124 // "→"
                                         shortcutModifiers:NSControlKeyMask|NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousThird"
                                              shortcutCode:123 // "←"
                                         shortcutModifiers:NSControlKeyMask|NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeLarger"
                                              shortcutCode:124 // "←"
                                         shortcutModifiers:NSControlKeyMask|NSShiftKeyMask|NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeSmaller"
                                              shortcutCode:123 // "←"
                                         shortcutModifiers:NSControlKeyMask|NSShiftKeyMask|NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"UndoLastMove"
                                              shortcutCode:6 // "Z"
                                         shortcutModifiers:NSAlternateKeyMask|NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"RedoLastMove"
                                              shortcutCode:6 // "Z"
                                         shortcutModifiers:NSAlternateKeyMask|NSShiftKeyMask|NSCommandKeyMask],
           ];
}
