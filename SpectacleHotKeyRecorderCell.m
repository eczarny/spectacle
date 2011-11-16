#import "SpectacleHotKeyRecorderCell.h"
#import "SpectacleHotKey.h"
#import "SpectacleHotKeyTranslator.h"
#import "SpectacleHotKeyRecorderDelegate.h"
#import "SpectacleUtilities.h"

#define MakeRelativePoint(a, b, c) NSMakePoint((a * horizontalScale) + c.origin.x, (b * verticalScale) + c.origin.y)

#pragma mark -

@interface SpectacleHotKeyRecorderCell (SpectacleHotKeyRecorderCellPrivate)

- (void)drawBorderInRect: (NSRect)rect withRadius: (CGFloat)radius;

- (void)drawBackgroundInRect: (NSRect)rect withRadius: (CGFloat)radius;

#pragma mark -

- (void)drawBadgeInRect: (NSRect)rect;

#pragma mark -

- (void)drawClearHotKeyBadgeInRect: (NSRect)rect withOpacity: (CGFloat)opacity;

- (void)drawRevertHotKeyBadgeInRect: (NSRect)rect;

#pragma mark -

- (void)drawLabelInRect: (NSRect)rect;

#pragma mark -

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundcolor inRect: (NSRect)rect;

@end

#pragma mark -

@implementation SpectacleHotKeyRecorderCell

- (id)init {
    if (self = [super init]) {
        myHotKeyRecorder = nil;
        myHotKeyName = nil;
        myHotKey = nil;
        myDelegate = nil;
        myModifierFlags = 0;
        isRecording = NO;
        myTrackingArea = nil;
        isMouseAboveBadge = NO;
        isMouseDown = NO;
    }
    
    return self;
}

#pragma mark -

- (void)setHotKeyRecorder: (SpectacleHotKeyRecorder *)hotKeyRecorder {
    if (myHotKeyRecorder != hotKeyRecorder) {
        [myHotKeyRecorder release];
        
        myHotKeyRecorder = [hotKeyRecorder retain];
    }
}

#pragma mark -

- (NSString *)hotKeyName {
    return myHotKeyName;
}

- (void)setHotKeyName: (NSString *)hotKeyName {
    if (myHotKeyName != hotKeyName) {
        [myHotKeyName release];
        
        myHotKeyName = [hotKeyName retain];
    }
}

#pragma mark -

- (SpectacleHotKey *)hotKey {
    return myHotKey;
}

- (void)setHotKey: (SpectacleHotKey *)hotKey {
    if (myHotKey != hotKey) {
        [myHotKey release];
        
        myHotKey = [hotKey retain];
    }
}

#pragma mark -

- (id<SpectacleHotKeyRecorderDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SpectacleHotKeyRecorderDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (BOOL)resignFirstResponder {
    if (isRecording) {
        isRecording = NO;
        
        [[self controlView] setNeedsDisplay: YES];
    }
    
    return YES;
}

#pragma mark -

- (BOOL)performKeyEquivalent: (NSEvent *)event {
    NSInteger keyCode = [event keyCode];
    NSInteger modifierFlags = myModifierFlags | [event modifierFlags];
    
    if (isRecording && [SpectacleHotKey validCocoaModifiers: modifierFlags]) {
        NSString *characters = [[event charactersIgnoringModifiers] uppercaseString];
        
        if ([characters length]) {
            SpectacleHotKey *hotKey = [[[SpectacleHotKey alloc] initWithHotKeyCode: keyCode hotKeyModifiers: modifierFlags] autorelease];
            
            [hotKey setHotKeyName: myHotKeyName];
            
            [self setHotKey: hotKey];
            
            [myDelegate hotKeyRecorder: myHotKeyRecorder didReceiveNewHotKey: hotKey];
        } else {
            NSBeep();
        }
        
        myModifierFlags = 0;
        
        isRecording = NO;
        
        [[self controlView] setNeedsDisplay: YES];
        
        return YES;
    }
    
    return NO;
}

- (void)flagsChanged: (NSEvent *)event {
    if (isRecording) {
        myModifierFlags = [event modifierFlags];
        
        if (myModifierFlags == 256) {
            myModifierFlags = 0;
        }
        
        [[self controlView] setNeedsDisplay: YES];
    }
}

#pragma mark -

- (BOOL)trackMouse: (NSEvent *)event inRect: (NSRect)rect ofView: (NSView *)view untilMouseUp: (BOOL)untilMouseUp {
    NSEvent *currentEvent = event;
    
    do {
        NSPoint mouseLocation = [view convertPoint: [currentEvent locationInWindow] fromView: nil];
        
        switch ([currentEvent type]) {
            case NSLeftMouseDown:
                isMouseDown = YES;
                
                [view setNeedsDisplay: YES];
                
                break;
            case NSLeftMouseDragged:
                if ([view mouse: mouseLocation inRect: rect]) {
                    isMouseDown = YES;
                } else {
                    isMouseDown = NO;
                }
                
                if (isMouseAboveBadge && [view mouse: mouseLocation inRect: [myTrackingArea rect]]) {
                    isMouseDown = YES;
                    isMouseAboveBadge = YES;
                } else {
                    isMouseDown = NO;
                    isMouseAboveBadge = NO;
                }
                
                [view setNeedsDisplay: YES];
                
                break;
            default:
                isMouseDown = NO;
                
                if ([view mouse: mouseLocation inRect: rect] && !isRecording && !isMouseAboveBadge) {
                    isRecording = YES;
                    
                    [[view window] makeFirstResponder: view];
                } else if (isRecording && isMouseAboveBadge) {
                    isRecording = NO;
                } else if (!isRecording && myHotKey && isMouseAboveBadge) {
                    [myDelegate hotKeyRecorder: myHotKeyRecorder didClearExistingHotKey: myHotKey];
                    
                    [self setHotKey: nil];
                }
                
                [view setNeedsDisplay: YES];
                
                return YES;
        }
    } while (currentEvent = [[view window] nextEventMatchingMask: (NSLeftMouseDraggedMask | NSLeftMouseUpMask)
                                                       untilDate: [NSDate distantFuture]
                                                          inMode: NSEventTrackingRunLoopMode
                                                         dequeue: YES]);
    
    return YES;
}

#pragma mark -

- (void)mouseEntered: (NSEvent *)event {
    isMouseAboveBadge = YES;
    
    [[self controlView] setNeedsDisplay: YES];
}

- (void)mouseExited: (NSEvent *)event {
    isMouseAboveBadge = NO;
    
    [[self controlView] setNeedsDisplay: YES];
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

- (void)dealloc {
    [myHotKey release];
    [myTrackingArea release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleHotKeyRecorderCell (SpectacleHotKeyRecorderCellPrivate)

- (void)drawBorderInRect: (NSRect)rect withRadius: (CGFloat)radius {
    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: radius yRadius: radius];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [roundedPath addClip];
    
    [[NSColor windowFrameColor] set];
    
    [NSBezierPath fillRect: rect];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

- (void)drawBackgroundInRect: (NSRect)rect withRadius: (CGFloat)radius {
    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(rect, 1.0f, 1.0f) xRadius: radius yRadius: radius];
    NSColor *gradientStartingColor = nil;
    NSColor *gradientEndingColor = nil;
    NSGradient *gradient = nil;
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [roundedPath addClip];
    
    if (isRecording) {
        gradientStartingColor = [NSColor colorWithDeviceRed: 0.784f green: 0.953f blue: 1.0f alpha: 1.0f];
        gradientEndingColor = [NSColor colorWithDeviceRed: 0.694f green: 0.859f blue: 1.0f alpha: 1.0f];
    } else {
        gradientStartingColor = [[[NSColor whiteColor] shadowWithLevel: 0.2f] colorWithAlphaComponent: 0.9f];
        gradientEndingColor = [[[NSColor whiteColor] highlightWithLevel: 0.2f] colorWithAlphaComponent: 0.9f];
    }
    
    if (!isRecording && isMouseDown && !isMouseAboveBadge) {
        gradient = [[[NSGradient alloc] initWithStartingColor: gradientEndingColor endingColor: gradientStartingColor] autorelease];
    } else {
        gradient = [[[NSGradient alloc] initWithStartingColor: gradientStartingColor endingColor: gradientEndingColor] autorelease];
    }
    
    [gradient drawInRect: rect angle: 90.0f];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
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
    
    if (isRecording && !myHotKey) {
        [self drawClearHotKeyBadgeInRect: badgeRect withOpacity: 0.25f];
    } else if (isRecording) {
        [self drawRevertHotKeyBadgeInRect: badgeRect];
    } else if (myHotKey) {
        [self drawClearHotKeyBadgeInRect: badgeRect withOpacity: 0.25f];
    }
    
    if (((myHotKey && !isRecording) || (!myHotKey && isRecording)) && isMouseAboveBadge && isMouseDown) {
        [self drawClearHotKeyBadgeInRect: badgeRect withOpacity: 0.50f];
    }
    
    if (!myTrackingArea) {
        myTrackingArea = [[NSTrackingArea alloc] initWithRect: badgeRect
                                                      options: (NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited)
                                                        owner: self
                                                     userInfo: nil];
        
        [[self controlView] addTrackingArea: myTrackingArea];
    }
}

#pragma mark -

- (void)drawClearHotKeyBadgeInRect: (NSRect)rect withOpacity: (CGFloat)opacity {
    CGFloat horizontalScale = (rect.size.width / 13.0f);
    CGFloat verticalScale = (rect.size.height / 13.0f);
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [[NSColor colorWithCalibratedWhite: 0.0f alpha: opacity] setFill];
    
    [[NSBezierPath bezierPathWithOvalInRect: rect] fill];
    
    [[NSColor whiteColor] setStroke];
    
    NSBezierPath *cross = [[[NSBezierPath alloc] init] autorelease];
    
    [cross setLineWidth: horizontalScale * 1.4f];
    
    [cross moveToPoint: MakeRelativePoint(4.0f, 4.0f, rect)];
    [cross lineToPoint: MakeRelativePoint(9.0f, 9.0f, rect)];
    [cross moveToPoint: MakeRelativePoint(9.0f, 4.0f, rect)];
    [cross lineToPoint: MakeRelativePoint(4.0f, 9.0f, rect)];
    
    [cross stroke];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

- (void)drawRevertHotKeyBadgeInRect: (NSRect)rect {
    CGFloat horizontalScale = (rect.size.width / 1.0f);
    CGFloat verticalScale = (rect.size.height / 1.0f);
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    NSBezierPath *swoosh = [[[NSBezierPath alloc] init] autorelease];
    
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
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

#pragma mark -

- (void)drawLabelInRect: (NSRect)rect {
    NSString *label = nil;
    NSColor *foregroundColor = [NSColor blackColor];
    
    if (isRecording && !isMouseAboveBadge) {
        label = ZeroKitLocalizedStringFromCurrentBundle(@"Enter hot key");
    } else if (isRecording && isMouseAboveBadge && !myHotKey) {
        label = ZeroKitLocalizedStringFromCurrentBundle(@"Stop recording");
    } else if (isRecording && isMouseAboveBadge) {
        label = ZeroKitLocalizedStringFromCurrentBundle(@"Use existing");
    } else if (myHotKey) {
        label = [myHotKey displayString];
    } else {
        label = ZeroKitLocalizedStringFromCurrentBundle(@"Click to record");
    }
    
    // Recording is in progress and modifier flags have already been set, display them.
    if (isRecording && (myModifierFlags > 0)) {
        label = [SpectacleHotKeyTranslator translateCocoaModifiers: myModifierFlags];
    }
    
    if (![self isEnabled]) {
        foregroundColor = [NSColor disabledControlTextColor];
    }
    
    if (isRecording) {
        [self drawString: label withForegroundColor: foregroundColor inRect: rect];
    } else {
        [self drawString: label withForegroundColor: foregroundColor inRect: rect];
    }
}

#pragma mark -

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundColor inRect: (NSRect)rect {
    NSMutableDictionary *attributes = [SpectacleUtilities createStringAttributesWithShadow];
    NSRect labelRect = rect;
    
    [attributes setObject: [NSFont systemFontOfSize: [NSFont smallSystemFontSize]] forKey: NSFontAttributeName];
    [attributes setObject: foregroundColor forKey: NSForegroundColorAttributeName];
    
    labelRect.origin.y = -(NSMidY(rect) - [string sizeWithAttributes: attributes].height / 2.0f);
    
    [string drawInRect: labelRect withAttributes: attributes];
}

@end
