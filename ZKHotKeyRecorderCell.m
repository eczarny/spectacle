#import "ZKHotKeyRecorderCell.h"
#import "ZKHotKey.h"
#import "ZKHotKeyTranslator.h"
#import "ZKHotKeyValidator.h"
#import "ZKHotKeyRecorder.h"
#import "ZKHotKeyRecorderDelegate.h"
#import "ZKUtilities.h"

#define MakeRelativePoint(a, b, c) NSMakePoint((a * horizontalScale) + c.origin.x, (b * verticalScale) + c.origin.y)

#pragma mark -

@interface ZKHotKeyRecorderCell ()

@property (nonatomic) NSInteger modifierFlags;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) NSTrackingArea *trackingArea;
@property (nonatomic) BOOL isMouseAboveBadge;
@property (nonatomic) BOOL isMouseDown;
@property (nonatomic) void *hotKeyMode;

@end

#pragma mark -

@implementation ZKHotKeyRecorderCell

- (id)init {
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

- (BOOL)resignFirstResponder {
    if (_isRecording) {
        PopSymbolicHotKeyMode(_hotKeyMode);
        
        _isRecording = NO;
        
        [self.controlView setNeedsDisplay: YES];
    }
    
    return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event {
    NSInteger keyCode = event.keyCode;
    NSInteger newModifierFlags = _modifierFlags | event.modifierFlags;
    
    if (_isRecording && [ZKHotKey validCocoaModifiers: newModifierFlags]) {
        NSString *characters = event.charactersIgnoringModifiers.uppercaseString;
        
        if (characters.length) {
            ZKHotKey *newHotKey = [[ZKHotKey alloc] initWithHotKeyCode: keyCode hotKeyModifiers: newModifierFlags];
            NSError *error = nil;
            
            if (![ZKHotKeyValidator isHotKeyValid: newHotKey withValidators: _additionalHotKeyValidators error: &error]) {
                [[NSAlert alertWithError: error] runModal];
            } else {
                newHotKey.hotKeyName = _hotKeyName;
                
                self.hotKey = newHotKey;
                
                [_delegate hotKeyRecorder: _hotKeyRecorder didReceiveNewHotKey: newHotKey];
            }
        } else {
            NSBeep();
        }
        
        _modifierFlags = 0;
        
        PopSymbolicHotKeyMode(_hotKeyMode);
        
        _isRecording = NO;
        
        [self.controlView setNeedsDisplay: YES];
        
        return YES;
    }
    
    return NO;
}

- (void)flagsChanged: (NSEvent *)event {
    if (_isRecording) {
        _modifierFlags = event.modifierFlags;
        
        if (_modifierFlags == 256) {
            _modifierFlags = 0;
        }
        
        [self.controlView setNeedsDisplay: YES];
    }
}

#pragma mark -

- (BOOL)trackMouse: (NSEvent *)event inRect: (NSRect)rect ofView: (NSView *)view untilMouseUp: (BOOL)untilMouseUp {
    NSEvent *currentEvent = event;
    
    do {
        NSPoint mouseLocation = [view convertPoint: currentEvent.locationInWindow fromView: nil];
        
        switch ([currentEvent type]) {
            case NSLeftMouseDown:
                _isMouseDown = YES;
                
                [view setNeedsDisplay: YES];
                
                break;
            case NSLeftMouseDragged:
                if ([view mouse: mouseLocation inRect: rect]) {
                    _isMouseDown = YES;
                } else {
                    _isMouseDown = NO;
                }
                
                if (_isMouseAboveBadge && [view mouse: mouseLocation inRect: _trackingArea.rect]) {
                    _isMouseDown = YES;
                    _isMouseAboveBadge = YES;
                } else {
                    _isMouseDown = NO;
                    _isMouseAboveBadge = NO;
                }
                
                [view setNeedsDisplay: YES];
                
                break;
            default:
                _isMouseDown = NO;
                
                if ([view mouse: mouseLocation inRect: rect] && !_isRecording && !_isMouseAboveBadge) {
                    _isRecording = YES;
                    
                    _hotKeyMode = PushSymbolicHotKeyMode(kHIHotKeyModeAllDisabled);
                    
                    [view.window makeFirstResponder: view];
                } else if (_isRecording && _isMouseAboveBadge) {
                    PopSymbolicHotKeyMode(_hotKeyMode);
                    
                    _isRecording = NO;
                } else if (!_isRecording && _hotKey && _isMouseAboveBadge) {
                    [_delegate hotKeyRecorder: _hotKeyRecorder didClearExistingHotKey: _hotKey];
                    
                    self.hotKey = nil;
                }
                
                [view setNeedsDisplay: YES];
                
                return YES;
        }
    } while ((currentEvent = [[view window] nextEventMatchingMask: (NSLeftMouseDraggedMask | NSLeftMouseUpMask)
                                                        untilDate: NSDate.distantFuture
                                                           inMode: NSEventTrackingRunLoopMode
                                                          dequeue: YES]));
    
    return YES;
}

#pragma mark -

- (void)mouseEntered: (NSEvent *)event {
    _isMouseAboveBadge = YES;
    
    [self.controlView setNeedsDisplay: YES];
}

- (void)mouseExited: (NSEvent *)event {
    _isMouseAboveBadge = NO;
    
    [self.controlView setNeedsDisplay: YES];
}

#pragma mark -

- (void)drawWithFrame: (NSRect)frame inView: (NSView *)view {
    CGFloat radius = NSHeight(frame) / 2.0f;
    
    // Draw the border of the control.
    [self drawBorderInRect: frame withRadius: radius];
    
    // Draw the default background of the control.
    [self drawBackgroundInRect: frame withRadius: radius];
    
    // Draw the tracking area image, depending the control's current state.
    [self drawBadgeInRect: frame];
    
    // Draw the label of the control.
    [self drawLabelInRect: frame];
}

#pragma mark -

- (void)drawBorderInRect: (NSRect)rect withRadius: (CGFloat)radius {
    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: radius yRadius: radius];
    
    [NSGraphicsContext.currentContext saveGraphicsState];
    
    [roundedPath addClip];
    
    [NSColor.windowFrameColor set];
    
    [NSBezierPath fillRect: rect];
    
    [NSGraphicsContext.currentContext restoreGraphicsState];
}

- (void)drawBackgroundInRect: (NSRect)rect withRadius: (CGFloat)radius {
    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(rect, 1.0f, 1.0f) xRadius: radius yRadius: radius];
    NSColor *gradientStartingColor = nil;
    NSColor *gradientEndingColor = nil;
    NSGradient *gradient = nil;
    
    [NSGraphicsContext.currentContext saveGraphicsState];
    
    [roundedPath addClip];
    
    if (_isRecording) {
        gradientStartingColor = [NSColor colorWithDeviceRed: 0.784f green: 0.953f blue: 1.0f alpha: 1.0f];
        gradientEndingColor = [NSColor colorWithDeviceRed: 0.694f green: 0.859f blue: 1.0f alpha: 1.0f];
    } else {
        gradientStartingColor = [[NSColor.whiteColor shadowWithLevel: 0.2f] colorWithAlphaComponent: 0.9f];
        gradientEndingColor = [[NSColor.whiteColor highlightWithLevel: 0.2f] colorWithAlphaComponent: 0.9f];
    }
    
    if (!_isRecording && _isMouseDown && !_isMouseAboveBadge) {
        gradient = [[NSGradient alloc] initWithStartingColor: gradientEndingColor endingColor: gradientStartingColor];
    } else {
        gradient = [[NSGradient alloc] initWithStartingColor: gradientStartingColor endingColor: gradientEndingColor];
    }
    
    [gradient drawInRect: rect angle: 90.0f];
    
    [NSGraphicsContext.currentContext restoreGraphicsState];
}

#pragma mark -

- (void)drawBadgeInRect: (NSRect)rect {
    NSRect badgeRect;
    NSSize badgeSize;
    
    // Calculate this! Eventually...
    badgeSize.width = 13.0f;
    badgeSize.height = 13.0f;
    
    badgeRect.origin = NSMakePoint(NSMaxX(rect) - badgeSize.width - 4.0f, floor((NSMaxY(rect) - badgeSize.height) / 2.0f));
    badgeRect.size = badgeSize;
    
    if (_isRecording && !_hotKey) {
        [self drawClearHotKeyBadgeInRect: badgeRect withOpacity: 0.25f];
    } else if (_isRecording) {
        [self drawRevertHotKeyBadgeInRect: badgeRect];
    } else if (_hotKey) {
        [self drawClearHotKeyBadgeInRect: badgeRect withOpacity: 0.25f];
    }
    
    if (((_hotKey && !_isRecording) || (!_hotKey && _isRecording)) && _isMouseAboveBadge && _isMouseDown) {
        [self drawClearHotKeyBadgeInRect: badgeRect withOpacity: 0.50f];
    }
    
    if (!_trackingArea) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect: badgeRect
                                                     options: (NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited)
                                                       owner: self
                                                    userInfo: nil];
        
        [self.controlView addTrackingArea: _trackingArea];
    }
}

#pragma mark -

- (void)drawClearHotKeyBadgeInRect: (NSRect)rect withOpacity: (CGFloat)opacity {
    CGFloat horizontalScale = (rect.size.width / 13.0f);
    CGFloat verticalScale = (rect.size.height / 13.0f);
    
    [NSGraphicsContext.currentContext saveGraphicsState];
    
    [[NSColor colorWithCalibratedWhite: 0.0f alpha: opacity] setFill];
    
    [[NSBezierPath bezierPathWithOvalInRect: rect] fill];
    
    [NSColor.whiteColor setStroke];
    
    NSBezierPath *cross = [NSBezierPath new];
    
    [cross setLineWidth: horizontalScale * 1.4f];
    
    [cross moveToPoint: MakeRelativePoint(4.0f, 4.0f, rect)];
    [cross lineToPoint: MakeRelativePoint(9.0f, 9.0f, rect)];
    [cross moveToPoint: MakeRelativePoint(9.0f, 4.0f, rect)];
    [cross lineToPoint: MakeRelativePoint(4.0f, 9.0f, rect)];
    
    [cross stroke];
    
    [NSGraphicsContext.currentContext restoreGraphicsState];
}

- (void)drawRevertHotKeyBadgeInRect: (NSRect)rect {
    CGFloat horizontalScale = (rect.size.width / 1.0f);
    CGFloat verticalScale = (rect.size.height / 1.0f);
    
    [NSGraphicsContext.currentContext saveGraphicsState];
    
    NSBezierPath *swoosh = [NSBezierPath new];
    
    [swoosh setLineWidth: horizontalScale];
    
    [swoosh moveToPoint: MakeRelativePoint(0.0489685f, 0.6181513f, rect)];
	[swoosh lineToPoint: MakeRelativePoint(0.4085750f, 0.9469318f, rect)];
	[swoosh lineToPoint: MakeRelativePoint(0.4085750f, 0.7226146f, rect)];
    
	[swoosh curveToPoint: MakeRelativePoint(0.8508247f, 0.4836237f, rect)
           controlPoint1: MakeRelativePoint(0.4085750f, 0.7226146f, rect)
           controlPoint2: MakeRelativePoint(0.8371143f, 0.7491841f, rect)];
	[swoosh curveToPoint: MakeRelativePoint(0.5507195f, 0.0530682f, rect)
           controlPoint1: MakeRelativePoint(0.8677834f, 0.1545071f, rect)
           controlPoint2: MakeRelativePoint(0.5507195f, 0.0530682f, rect)];
	[swoosh curveToPoint: MakeRelativePoint(0.7421721f, 0.3391942f, rect)
           controlPoint1: MakeRelativePoint(0.5507195f, 0.0530682f, rect)
           controlPoint2: MakeRelativePoint(0.7458685f, 0.1913146f, rect)];
	[swoosh curveToPoint: MakeRelativePoint(0.4085750f, 0.5154130f, rect)
           controlPoint1: MakeRelativePoint(0.7383412f, 0.4930328f, rect)
           controlPoint2: MakeRelativePoint(0.4085750f, 0.5154130f, rect)];
    
	[swoosh lineToPoint: MakeRelativePoint(0.4085750f, 0.2654000f, rect)];
    
    [swoosh fill];
    
    [NSGraphicsContext.currentContext restoreGraphicsState];
}

#pragma mark -

- (void)drawLabelInRect: (NSRect)rect {
    NSString *label = nil;
    NSColor *foregroundColor = NSColor.blackColor;
    
    if (_isRecording && !_isMouseAboveBadge) {
        label = ZKLocalizedStringFromCurrentBundle(@"Enter hot key");
    } else if (_isRecording && _isMouseAboveBadge && !_hotKey) {
        label = ZKLocalizedStringFromCurrentBundle(@"Stop recording");
    } else if (_isRecording && _isMouseAboveBadge) {
        label = ZKLocalizedStringFromCurrentBundle(@"Use existing");
    } else if (_hotKey) {
        label = _hotKey.displayString;
    } else {
        label = ZKLocalizedStringFromCurrentBundle(@"Click to record");
    }
    
    // Recording is in progress and modifier flags have already been set, display them.
    if (_isRecording && (_modifierFlags > 0)) {
        label = [ZKHotKeyTranslator translateCocoaModifiers: _modifierFlags];
    }
    
    if (!self.isEnabled) {
        foregroundColor = NSColor.disabledControlTextColor;
    }
    
    if (_isRecording) {
        [self drawString: label withForegroundColor: foregroundColor inRect: rect];
    } else {
        [self drawString: label withForegroundColor: foregroundColor inRect: rect];
    }
}

#pragma mark -

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundColor inRect: (NSRect)rect {
    NSMutableDictionary *attributes = ZKUtilities.stringAttributesWithShadow;
    NSRect labelRect = rect;
    
    attributes[NSFontAttributeName] = [NSFont systemFontOfSize: NSFont.smallSystemFontSize];
    attributes[NSForegroundColorAttributeName] = foregroundColor;
    
    labelRect.origin.y = -(NSMidY(rect) - [string sizeWithAttributes: attributes].height / 2.0f);
    
    [string drawInRect: labelRect withAttributes: attributes];
}

@end
