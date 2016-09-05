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
                                              shortcutCode:kVK_ANSI_C
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToFullscreen"
                                              shortcutCode:kVK_ANSI_F
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLeftHalf"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToRightHalf"
                                              shortcutCode:kVK_RightArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToTopHalf"
                                              shortcutCode:kVK_UpArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToBottomHalf"
                                              shortcutCode:kVK_DownArrow
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperLeft"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerLeft"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSShiftKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToUpperRight"
                                              shortcutCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToLowerRight"
                                              shortcutCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSShiftKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextDisplay"
                                              shortcutCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousDisplay"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToNextThird"
                                              shortcutCode:kVK_RightArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToPreviousThird"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeLarger"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSShiftKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"MakeSmaller"
                                              shortcutCode:kVK_LeftArrow
                                         shortcutModifiers:NSControlKeyMask | NSAlternateKeyMask | NSShiftKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"UndoLastMove"
                                              shortcutCode:kVK_ANSI_Z
                                         shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask],
           [[SpectacleShortcut alloc] initWithShortcutName:@"RedoLastMove"
                                              shortcutCode:kVK_ANSI_Z
                                         shortcutModifiers:NSAlternateKeyMask | NSShiftKeyMask | NSCommandKeyMask],
           ];
}
