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
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                           shortcutKeyCode:kVK_ANSI_C
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToFullscreen"
                                           shortcutKeyCode:kVK_ANSI_F
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLeftHalf"
                                           shortcutKeyCode:kVK_LeftArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToRightHalf"
                                           shortcutKeyCode:kVK_RightArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToTopHalf"
                                           shortcutKeyCode:kVK_UpArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToBottomHalf"
                                           shortcutKeyCode:kVK_DownArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperLeft"
                                           shortcutKeyCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerLeft"
                                           shortcutKeyCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSShiftKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperRight"
                                           shortcutKeyCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerRight"
                                           shortcutKeyCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSShiftKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextDisplay"
                                           shortcutKeyCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousDisplay"
                                           shortcutKeyCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextThird"
                                           shortcutKeyCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousThird"
                                           shortcutKeyCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeLarger"
                                           shortcutKeyCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSShiftKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeSmaller"
                                           shortcutKeyCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSShiftKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"UndoLastMove"
                                           shortcutKeyCode:kVK_ANSI_Z
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"RedoLastMove"
                                           shortcutKeyCode:kVK_ANSI_Z
                                         shortcutModifiers:NSAlternateKeyMask | NSShiftKeyMask | NSCommandKeyMask],
           ];
}
