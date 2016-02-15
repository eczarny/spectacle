#import "SpectacleShortcutManager.h"
#import "SpectacleShortcutRecorder.h"
#import "SpectacleShortcutRecorderCell.h"

#define MyCell (SpectacleShortcutRecorderCell *)[self cell]

#pragma mark -

@implementation SpectacleShortcutRecorder

- (instancetype)initWithFrame:(NSRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [MyCell setShortcutRecorder:self];
  }
  
  return self;
}

#pragma mark -

+ (Class)cellClass
{
  return SpectacleShortcutRecorderCell.class;
}

#pragma mark -

- (NSString *)shortcutName
{
  return [MyCell shortcutName];
}

- (void)setShortcutName:(NSString *)shortcutName
{
  [MyCell setShortcutName:shortcutName];
}

#pragma mark -

- (SpectacleShortcut *)shortcut
{
  return [MyCell shortcut];
}

- (void)setShortcut:(SpectacleShortcut *)shortcut
{
  [MyCell setShortcut:shortcut];
  
  [self updateCell:MyCell];
}

#pragma mark -

- (id<SpectacleShortcutRecorderDelegate>)delegate
{
  return [MyCell delegate];
}

- (void)setDelegate:(id<SpectacleShortcutRecorderDelegate>)delegate
{
  [MyCell setDelegate:delegate];
}

#pragma mark -

- (void)setAdditionalShortcutValidators:(NSArray<id<SpectacleShortcutValidatorProtocol>> *)additionalShortcutValidators
                        shortcutManager:(SpectacleShortcutManager *)shortcutManager
{
  [MyCell setAdditionalShortcutValidators:additionalShortcutValidators];
  [MyCell setShortcutManager:shortcutManager];
}

#pragma mark -

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
  return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  if ([self.window.firstResponder isEqualTo:self]) {
    return [MyCell performKeyEquivalent:event];
  }
  
  return [super performKeyEquivalent:event];
}

- (void)keyDown:(NSEvent *)event
{
  if ([self performKeyEquivalent:event]) {
    return;
  }
  
  if (event.keyCode == kVK_Escape) {
    [MyCell resignFirstResponder];
  } else {
    [super keyDown:event];
  }
}

- (void)flagsChanged:(NSEvent *)event
{
  [MyCell flagsChanged:event];
}

#pragma mark -

- (BOOL)resignFirstResponder
{
  return [MyCell resignFirstResponder];
}

@end
