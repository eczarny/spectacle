#import "SpectacleShortcut.h"
#import "SpectacleShortcutRecorder.h"
#import "SpectacleShortcutRecorderCell.h"
#import "SpectacleShortcutTranslator.h"
#import "SpectacleShortcutValidator.h"

#define MakeRelativePoint(a, b, c) NSMakePoint((a * horizontalScale) + c.origin.x, (b * verticalScale) + c.origin.y)

#pragma mark -

@interface SpectacleShortcutRecorderCell ()

@property (nonatomic) NSUInteger modifierFlags;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) NSTrackingArea *trackingArea;
@property (nonatomic) BOOL isMouseAboveBadge;
@property (nonatomic) BOOL isMouseDown;
@property (nonatomic) void *shortcutMode;

@end

#pragma mark -

@implementation SpectacleShortcutRecorderCell

- (instancetype)init
{
  if (self = [super init]) {
    _shortcutRecorder = nil;
    _shortcutName = nil;
    _shortcut = nil;
    _delegate = nil;
    _additionalShortcutValidators = [NSArray new];
    _modifierFlags = 0;
    _isRecording = NO;
    _trackingArea = nil;
    _isMouseAboveBadge = NO;
    _isMouseDown = NO;
  }

  return self;
}

#pragma mark -

- (BOOL)resignFirstResponder
{
  if (self.isRecording) {
    PopSymbolicHotKeyMode(self.shortcutMode);

    self.isRecording = NO;

    [self.controlView setNeedsDisplay:YES];
  }

  return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  NSInteger keyCode = event.keyCode;
  NSUInteger newModifierFlags = (self.modifierFlags | event.modifierFlags) & NSDeviceIndependentModifierFlagsMask;
  BOOL functionKey = ((keyCode == kVK_F1)  || (keyCode == kVK_F2)  || (keyCode == kVK_F3)  || (keyCode == kVK_F4)  ||
                      (keyCode == kVK_F5)  || (keyCode == kVK_F6)  || (keyCode == kVK_F7)  || (keyCode == kVK_F8)  ||
                      (keyCode == kVK_F9)  || (keyCode == kVK_F10) || (keyCode == kVK_F11) || (keyCode == kVK_F12) ||
                      (keyCode == kVK_F13) || (keyCode == kVK_F14) || (keyCode == kVK_F15) || (keyCode == kVK_F16) ||
                      (keyCode == kVK_F17) || (keyCode == kVK_F18) || (keyCode == kVK_F19) || (keyCode == kVK_F20));

  if (self.isRecording && (functionKey || [SpectacleShortcut validCocoaModifiers:newModifierFlags])) {
    NSString *characters = event.charactersIgnoringModifiers.uppercaseString;

    if (characters.length) {
      SpectacleShortcut *newShortcut = [[SpectacleShortcut alloc] initWithShortcutCode:keyCode
                                                                     shortcutModifiers:newModifierFlags];
      NSError *error = nil;
      BOOL isShortcutValid = [SpectacleShortcutValidator isShortcutValid:newShortcut
                                                          withValidators:self.additionalShortcutValidators
                                                                   error:&error];

      if (!isShortcutValid) {
        [[NSAlert alertWithError:error] runModal];
      } else {
        newShortcut.shortcutName = self.shortcutName;

        self.shortcut = newShortcut;

        [self.delegate shortcutRecorder:self.shortcutRecorder didReceiveNewShortcut:newShortcut];
      }
    } else {
      NSBeep();
    }

    self.modifierFlags = 0;

    PopSymbolicHotKeyMode(self.shortcutMode);

    self.isRecording = NO;

    [self.controlView setNeedsDisplay:YES];

    return YES;
  }

  return NO;
}

- (void)flagsChanged:(NSEvent *)event
{
  if (self.isRecording) {
    self.modifierFlags = event.modifierFlags;

    [self.controlView setNeedsDisplay:YES];
  }
}

#pragma mark -

- (BOOL)trackMouse:(NSEvent *)event inRect:(NSRect)rect ofView:(NSView *)view untilMouseUp:(BOOL)untilMouseUp
{
  NSEvent *currentEvent = event;

  do {
    NSPoint mouseLocation = [view convertPoint:currentEvent.locationInWindow fromView:nil];

    switch ([currentEvent type]) {
      case NSLeftMouseDown:
        self.isMouseDown = YES;

        [view setNeedsDisplay:YES];

        break;
      case NSLeftMouseDragged:
        if ([view mouse:mouseLocation inRect:rect]) {
          self.isMouseDown = YES;
        } else {
          self.isMouseDown = NO;
        }

        if (self.isMouseAboveBadge && [view mouse:mouseLocation inRect:self.trackingArea.rect]) {
          self.isMouseDown = YES;
          self.isMouseAboveBadge = YES;
        } else {
          self.isMouseDown = NO;
          self.isMouseAboveBadge = NO;
        }

        [view setNeedsDisplay:YES];

        break;
      default:
        self.isMouseDown = NO;

        if ([view mouse:mouseLocation inRect:rect] && !self.isRecording && !self.isMouseAboveBadge) {
          self.isRecording = YES;

          self.shortcutMode = PushSymbolicHotKeyMode(kHIHotKeyModeAllDisabled);

          [view.window makeFirstResponder:view];
        } else if (self.isRecording && self.isMouseAboveBadge) {
          PopSymbolicHotKeyMode(self.shortcutMode);

          self.isRecording = NO;
        } else if (!self.isRecording && self.shortcut && self.isMouseAboveBadge) {
          [self.delegate shortcutRecorder:self.shortcutRecorder didClearExistingShortcut:self.shortcut];

          self.shortcut = nil;
        }

        [view setNeedsDisplay:YES];

        return YES;
    }
  } while ((currentEvent = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)
                                                      untilDate:NSDate.distantFuture
                                                         inMode:NSEventTrackingRunLoopMode
                                                        dequeue:YES]));

  return YES;
}

#pragma mark -

- (void)mouseEntered:(NSEvent *)event
{
  self.isMouseAboveBadge = YES;

  [self.controlView setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event
{
  self.isMouseAboveBadge = NO;

  [self.controlView setNeedsDisplay:YES];
}

#pragma mark -

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view
{
  CGFloat radius = NSHeight(frame) / 2.0f;

  // Draw the border of the control.
  [self drawBorderInRect:frame withRadius:radius];

  // Draw the default background of the control.
  [self drawBackgroundInRect:frame withRadius:radius];

  // Draw the tracking area image, depending the control's current state.
  [self drawBadgeInRect:frame];

  // Draw the label of the control.
  [self drawLabelInRect:frame];
}

#pragma mark -

- (void)drawBorderInRect:(NSRect)rect withRadius:(CGFloat)radius
{
  NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];

  [NSGraphicsContext.currentContext saveGraphicsState];

  [roundedPath addClip];

  [NSColor.windowFrameColor set];

  [NSBezierPath fillRect:rect];

  [NSGraphicsContext.currentContext restoreGraphicsState];
}

- (void)drawBackgroundInRect:(NSRect)rect withRadius:(CGFloat)radius
{
  NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rect, 1.0f, 1.0f)
                                                              xRadius:radius
                                                              yRadius:radius];

  NSColor *gradientStartingColor = nil;
  NSColor *gradientEndingColor = nil;
  NSGradient *gradient = nil;

  [NSGraphicsContext.currentContext saveGraphicsState];

  [roundedPath addClip];

  if (self.isRecording) {
    gradientStartingColor = [NSColor colorWithDeviceRed:0.784f green:0.953f blue:1.0f alpha:1.0f];
    gradientEndingColor = [NSColor colorWithDeviceRed:0.694f green:0.859f blue:1.0f alpha:1.0f];
  } else {
    gradientStartingColor = [[NSColor.whiteColor shadowWithLevel:0.2f] colorWithAlphaComponent:0.9f];
    gradientEndingColor = [[NSColor.whiteColor highlightWithLevel:0.2f] colorWithAlphaComponent:0.9f];
  }

  if (!self.isRecording && self.isMouseDown && !self.isMouseAboveBadge) {
    gradient = [[NSGradient alloc] initWithStartingColor:gradientEndingColor endingColor:gradientStartingColor];
  } else {
    gradient = [[NSGradient alloc] initWithStartingColor:gradientStartingColor endingColor:gradientEndingColor];
  }

  [gradient drawInRect:rect angle:90.0f];

  [NSGraphicsContext.currentContext restoreGraphicsState];
}

#pragma mark -

- (void)drawBadgeInRect:(NSRect)rect
{
  NSRect badgeRect;
  NSSize badgeSize;

  // Calculate this! Eventually...
  badgeSize.width = 13.0f;
  badgeSize.height = 13.0f;

  badgeRect.origin = NSMakePoint(NSMaxX(rect) - badgeSize.width - 4.0f, floor((NSMaxY(rect) - badgeSize.height) / 2.0f));
  badgeRect.size = badgeSize;

  if (self.isRecording && !self.shortcut) {
    [self drawClearShortcutBadgeInRect:badgeRect withOpacity:0.25f];
  } else if (self.isRecording) {
    [self drawRevertShortcutBadgeInRect:badgeRect];
  } else if (self.shortcut) {
    [self drawClearShortcutBadgeInRect:badgeRect withOpacity:0.25f];
  }

  if (((self.shortcut && !self.isRecording) || (!self.shortcut && self.isRecording)) && self.isMouseAboveBadge && self.isMouseDown) {
    [self drawClearShortcutBadgeInRect:badgeRect withOpacity:0.50f];
  }

  if (!self.trackingArea) {
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:badgeRect
                                                     options:(NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited)
                                                       owner:self
                                                    userInfo:nil];

    [self.controlView addTrackingArea:self.trackingArea];
  }
}

#pragma mark -

- (void)drawClearShortcutBadgeInRect:(NSRect)rect withOpacity:(CGFloat)opacity
{
  CGFloat horizontalScale = (rect.size.width / 13.0f);
  CGFloat verticalScale = (rect.size.height / 13.0f);

  [NSGraphicsContext.currentContext saveGraphicsState];

  [[NSColor colorWithCalibratedWhite:0.0f alpha:opacity] setFill];

  [[NSBezierPath bezierPathWithOvalInRect:rect] fill];

  [NSColor.whiteColor setStroke];

  NSBezierPath *cross = [NSBezierPath new];

  [cross setLineWidth:horizontalScale * 1.4f];

  [cross moveToPoint:MakeRelativePoint(4.0f, 4.0f, rect)];
  [cross lineToPoint:MakeRelativePoint(9.0f, 9.0f, rect)];
  [cross moveToPoint:MakeRelativePoint(9.0f, 4.0f, rect)];
  [cross lineToPoint:MakeRelativePoint(4.0f, 9.0f, rect)];

  [cross stroke];

  [NSGraphicsContext.currentContext restoreGraphicsState];
}

- (void)drawRevertShortcutBadgeInRect:(NSRect)rect
{
  CGFloat horizontalScale = (rect.size.width / 1.0f);
  CGFloat verticalScale = (rect.size.height / 1.0f);

  [NSGraphicsContext.currentContext saveGraphicsState];

  NSBezierPath *swoosh = [NSBezierPath new];

  [swoosh setLineWidth:horizontalScale];

  [swoosh moveToPoint:MakeRelativePoint(0.0489685f, 0.6181513f, rect)];
  [swoosh lineToPoint:MakeRelativePoint(0.4085750f, 0.9469318f, rect)];
  [swoosh lineToPoint:MakeRelativePoint(0.4085750f, 0.7226146f, rect)];

  [swoosh curveToPoint:MakeRelativePoint(0.8508247f, 0.4836237f, rect)
         controlPoint1:MakeRelativePoint(0.4085750f, 0.7226146f, rect)
         controlPoint2:MakeRelativePoint(0.8371143f, 0.7491841f, rect)];

  [swoosh curveToPoint:MakeRelativePoint(0.5507195f, 0.0530682f, rect)
         controlPoint1:MakeRelativePoint(0.8677834f, 0.1545071f, rect)
         controlPoint2:MakeRelativePoint(0.5507195f, 0.0530682f, rect)];

  [swoosh curveToPoint:MakeRelativePoint(0.7421721f, 0.3391942f, rect)
         controlPoint1:MakeRelativePoint(0.5507195f, 0.0530682f, rect)
         controlPoint2:MakeRelativePoint(0.7458685f, 0.1913146f, rect)];

  [swoosh curveToPoint:MakeRelativePoint(0.4085750f, 0.5154130f, rect)
         controlPoint1:MakeRelativePoint(0.7383412f, 0.4930328f, rect)
         controlPoint2:MakeRelativePoint(0.4085750f, 0.5154130f, rect)];

  [swoosh lineToPoint:MakeRelativePoint(0.4085750f, 0.2654000f, rect)];

  [swoosh fill];

  [NSGraphicsContext.currentContext restoreGraphicsState];
}

#pragma mark -

- (void)drawLabelInRect:(NSRect)rect
{
  NSString *label = nil;
  NSColor *foregroundColor = NSColor.blackColor;

  if (self.isRecording && !self.isMouseAboveBadge) {
    label = NSLocalizedString(@"Enter shortcut", @"Enter shortcut");
  } else if (self.isRecording && self.isMouseAboveBadge && !self.shortcut) {
    label = NSLocalizedString(@"Stop recording", @"Stop recording");
  } else if (self.isRecording && self.isMouseAboveBadge) {
    label = NSLocalizedString(@"Use existing", "Use existing");
  } else if (self.shortcut) {
    label = self.shortcut.displayString;
  } else {
    label = NSLocalizedString(@"Click to record", @"Click to record");
  }

  // Recording is in progress and modifier flags have already been set, display them.
  if (self.isRecording && (self.modifierFlags > 0)) {
    label = [SpectacleShortcutTranslator translateCocoaModifiers:self.modifierFlags];
  }

  if (!self.isEnabled) {
    foregroundColor = NSColor.disabledControlTextColor;
  }

  if (self.isRecording) {
    [self drawString:label withForegroundColor:foregroundColor inRect:rect];
  } else {
    [self drawString:label withForegroundColor:foregroundColor inRect:rect];
  }
}

#pragma mark -

- (void)drawString:(NSString *)string withForegroundColor:(NSColor *)foregroundColor inRect:(NSRect)rect
{
  NSMutableDictionary *attributes = [self stringAttributesWithShadow];
  NSRect labelRect = rect;

  attributes[NSFontAttributeName] = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
  attributes[NSForegroundColorAttributeName] = foregroundColor;

  labelRect.origin.y = -(NSMidY(rect) - [string sizeWithAttributes:attributes].height / 2.0f);

  [string drawInRect:labelRect withAttributes:attributes];
}

#pragma mark -

- (NSMutableDictionary *)stringAttributesWithShadow
{
  NSMutableParagraphStyle *paragraphStyle = NSParagraphStyle.defaultParagraphStyle.mutableCopy;
  NSShadow *textShadow = [NSShadow new];
  NSMutableDictionary *stringAttributes = [NSMutableDictionary new];

  paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
  paragraphStyle.alignment = NSCenterTextAlignment;

  textShadow.shadowColor = [NSColor whiteColor];
  textShadow.shadowOffset = NSMakeSize(0.0f, -1.0);
  textShadow.shadowBlurRadius = 0.0f;

  stringAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
  stringAttributes[NSShadowAttributeName] = textShadow;

  return stringAttributes;
}

@end
