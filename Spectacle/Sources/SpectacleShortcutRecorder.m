#import "SpectacleShortcutRecorder.h"

#import <Carbon/Carbon.h>

#import "SpectacleShortcutManager.h"
#import "SpectacleShortcutRecorderCell.h"

@implementation SpectacleShortcutRecorder

- (instancetype)initWithFrame:(NSRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.shortcutRecorderCell.shortcutRecorder = self;
  }
  return self;
}

- (NSString *)shortcutName
{
  return self.shortcutRecorderCell.shortcutName;
}

- (void)setShortcutName:(NSString *)shortcutName
{
  self.shortcutRecorderCell.shortcutName = shortcutName;
}

- (SpectacleShortcut *)shortcut
{
  return self.shortcutRecorderCell.shortcut;
}

- (void)setShortcut:(SpectacleShortcut *)shortcut
{
  self.shortcutRecorderCell.shortcut = shortcut;
  [self updateCell:self.shortcutRecorderCell];
}

- (id<SpectacleShortcutRecorderDelegate>)delegate
{
  return self.shortcutRecorderCell.delegate;
}

- (void)setDelegate:(id<SpectacleShortcutRecorderDelegate>)delegate
{
  self.shortcutRecorderCell.delegate = delegate;
}

- (void)setAdditionalShortcutValidators:(NSArray<id<SpectacleShortcutValidator>> *)additionalShortcutValidators
                        shortcutManager:(SpectacleShortcutManager *)shortcutManager
{
  self.shortcutRecorderCell.additionalShortcutValidators = additionalShortcutValidators;
  self.shortcutRecorderCell.shortcutManager = shortcutManager;
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
  return YES;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  if ([self.window.firstResponder isEqualTo:self]) {
    return [self.shortcutRecorderCell performKeyEquivalent:event];
  }
  return [super performKeyEquivalent:event];
}

- (void)keyDown:(NSEvent *)event
{
  if ([self performKeyEquivalent:event]) {
    return;
  }
  if (event.keyCode == kVK_Escape) {
    [self.shortcutRecorderCell resignFirstResponder];
  } else {
    [super keyDown:event];
  }
}

- (void)flagsChanged:(NSEvent *)event
{
  [self.shortcutRecorderCell flagsChanged:event];
}

- (BOOL)resignFirstResponder
{
  return [self.shortcutRecorderCell resignFirstResponder];
}

+ (Class)cellClass
{
  return [SpectacleShortcutRecorderCell class];
}

- (SpectacleShortcutRecorderCell *)shortcutRecorderCell
{
  return (SpectacleShortcutRecorderCell *)[self cell];
}

@end
