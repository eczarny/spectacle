#import "ZKHotKeyRecorderCell.h"

#import "SpectacleUtilities.h"
#import "ZKHotKey.h"
#import "ZKHotKeyRecorder.h"
#import "ZKHotKeyTranslator.h"
#import "ZKHotKeyValidator.h"

#define MakeRelativePoint(a, b, c) NSMakePoint((a * horizontalScale) + c.origin.x, (b * verticalScale) + c.origin.y)

#pragma mark -

@interface ZKHotKeyRecorderCell ()

@property (nonatomic) NSUInteger modifierFlags;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) NSTrackingArea *trackingArea;
@property (nonatomic) BOOL isMouseAboveBadge;
@property (nonatomic) BOOL isMouseDown;
@property (nonatomic) void *hotKeyMode;

@end

#pragma mark -

@implementation ZKHotKeyRecorderCell

- (instancetype)init
{
  if (self = [super init]) {
    _hotKeyRecorder = nil;
    _hotKeyName = nil;
    _hotKey = nil;
    _delegate = nil;
    _additionalHotKeyValidators = [NSArray new];
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
    PopSymbolicHotKeyMode(self.hotKeyMode);

    self.isRecording = NO;

    [self.controlView setNeedsDisplay:YES];
  }

  return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  NSInteger keyCode = event.keyCode;
  NSUInteger newModifierFlags = self.modifierFlags | event.modifierFlags;

  if (self.isRecording && [ZKHotKey validCocoaModifiers:newModifierFlags]) {
    NSString *characters = event.charactersIgnoringModifiers.uppercaseString;

    if (characters.length) {
      ZKHotKey *newHotKey = [[ZKHotKey alloc] initWithHotKeyCode:keyCode hotKeyModifiers:newModifierFlags];
      NSError *error = nil;

      if (![ZKHotKeyValidator isHotKeyValid:newHotKey withValidators:self.additionalHotKeyValidators error:&error]) {
        [[NSAlert alertWithError:error] runModal];
      } else {
        newHotKey.hotKeyName = self.hotKeyName;

        self.hotKey = newHotKey;

        [self.delegate hotKeyRecorder:self.hotKeyRecorder didReceiveNewHotKey:newHotKey];
      }
    } else {
      NSBeep();
    }

    self.modifierFlags = 0;

    PopSymbolicHotKeyMode(self.hotKeyMode);

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

    if (self.modifierFlags == 256) {
      self.modifierFlags = 0;
    }

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

          self.hotKeyMode = PushSymbolicHotKeyMode(kHIHotKeyModeAllDisabled);

          [view.window makeFirstResponder:view];
        } else if (self.isRecording && self.isMouseAboveBadge) {
          PopSymbolicHotKeyMode(self.hotKeyMode);

          self.isRecording = NO;
        } else if (!self.isRecording && self.hotKey && self.isMouseAboveBadge) {
          [self.delegate hotKeyRecorder:self.hotKeyRecorder didClearExistingHotKey:self.hotKey];

          self.hotKey = nil;
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

  if (self.isRecording && !self.hotKey) {
    [self drawClearHotKeyBadgeInRect:badgeRect withOpacity:0.25f];
  } else if (self.isRecording) {
    [self drawRevertHotKeyBadgeInRect:badgeRect];
  } else if (self.hotKey) {
    [self drawClearHotKeyBadgeInRect:badgeRect withOpacity:0.25f];
  }

  if (((self.hotKey && !self.isRecording) || (!self.hotKey && self.isRecording)) && self.isMouseAboveBadge && self.isMouseDown) {
    [self drawClearHotKeyBadgeInRect:badgeRect withOpacity:0.50f];
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

- (void)drawClearHotKeyBadgeInRect:(NSRect)rect withOpacity:(CGFloat)opacity
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

- (void)drawRevertHotKeyBadgeInRect:(NSRect)rect
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
    label = LocalizedString(@"Enter hot key");
  } else if (self.isRecording && self.isMouseAboveBadge && !self.hotKey) {
    label = LocalizedString(@"Stop recording");
  } else if (self.isRecording && self.isMouseAboveBadge) {
    label = LocalizedString(@"Use existing");
  } else if (self.hotKey) {
    label = self.hotKey.displayString;
  } else {
    label = LocalizedString(@"Click to record");
  }

  // Recording is in progress and modifier flags have already been set, display them.
  if (self.isRecording && (self.modifierFlags > 0)) {
    label = [ZKHotKeyTranslator translateCocoaModifiers:self.modifierFlags];
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
  NSMutableDictionary *attributes = SpectacleUtilities.stringAttributesWithShadow;
  NSRect labelRect = rect;

  attributes[NSFontAttributeName] = [NSFont systemFontOfSize:NSFont.smallSystemFontSize];
  attributes[NSForegroundColorAttributeName] = foregroundColor;

  labelRect.origin.y = -(NSMidY(rect) - [string sizeWithAttributes:attributes].height / 2.0f);

  [string drawInRect:labelRect withAttributes:attributes];
}

@end
