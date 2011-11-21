#import "SpectacleToggleSwitchCell.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

#define BoundsOfHandle NSMakeRect(myHandlePosition.x, myHandlePosition.y, [myHandle size].width, [myHandle size].height)

#pragma mark -

@interface SpectacleToggleSwitchCell (SpectacleToggleSwitchCellPrivate)

- (void)drawHandleInRect: (NSRect)rect atPosition: (NSPoint)position;

- (void)drawLabelsInRect: (NSRect)rect withSliderSize: (NSSize)sliderSize andHorizontalAdjustment: (CGFloat)horizontalAdjustment;

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundcolor inRect: (NSRect)rect;

@end

#pragma mark -

@implementation SpectacleToggleSwitchCell

- (id)init {
    if (self = [super init]) {
        myToggleSwitch = nil;
        myDelegate = nil;
        mySliderBackground = [[SpectacleUtilities imageFromResource: SpectacleSliderBackgroundImage] retain];
        mySliderMask = [[SpectacleUtilities imageFromResource: SpectacleSliderMaskImage] retain];
        myHandle = [[SpectacleUtilities imageFromResource: SpectacleSliderHandleImage] retain];
        myHandlePressed = [[SpectacleUtilities imageFromResource: SpectacleSliderHandlePressedImage] retain];
        myHandlePosition = NSZeroPoint;
        isMouseDown = NO;
        isMouseDragging = NO;
        isMouseAboveHandle = NO;
    }
    
    return self;
}

#pragma mark -

- (void)setToggleSwitch: (SpectacleToggleSwitch *)toggleSwitch {
    if (myToggleSwitch != toggleSwitch) {
        [myToggleSwitch release];
        
        myToggleSwitch = [toggleSwitch retain];
    }
}

#pragma mark -

- (id<SpectacleToggleSwitchDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SpectacleToggleSwitchDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (void)setState: (NSInteger)state {
    [super setState: state];
    
    [[self controlView] setNeedsDisplay: YES];
}

#pragma mark -

- (void)drawWithFrame: (NSRect)frame inView: (NSView *)view {
    NSSize sliderSize = [mySliderBackground size];
    NSSize handleSize = [myHandle size];
    CGFloat x = NSMidX(frame) - floor(sliderSize.width / 2.0f);
    CGFloat maximumX = x + (sliderSize.width - handleSize.width);
    NSPoint startPosition = NSMakePoint(x, 0.0f);
    NSPoint endPosition = NSMakePoint(maximumX, 0.0f);
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [mySliderBackground drawAtPoint: startPosition fromRect: frame operation: NSCompositeCopy fraction: 1.0f];
    
    if ((isMouseDragging && (myHandlePosition.x < x)) || (!isMouseDragging && ([self state] == NSOffState))) {
        myHandlePosition = startPosition;
    } else if ((isMouseDragging && (myHandlePosition.x >= maximumX)) || (!isMouseDragging && ([self state] == NSOnState))) {
        myHandlePosition = endPosition;
    }
    
    [self drawHandleInRect: frame atPosition: myHandlePosition];
    
    [mySliderMask drawAtPoint: startPosition fromRect: frame operation: NSCompositeSourceAtop fraction: 1.0f];
    
    [self drawLabelsInRect: frame withSliderSize: sliderSize andHorizontalAdjustment: x];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

#pragma mark -

- (BOOL)trackMouse: (NSEvent *)event inRect: (NSRect)rect ofView: (NSView *)view untilMouseUp: (BOOL)untilMouseUp {
    NSEvent *currentEvent = event;
    NSPoint previousPosition = NSZeroPoint;
    NSInteger previousState = [self state];
    
    do {
        NSPoint currentPosition = [view convertPoint: [currentEvent locationInWindow] fromView: nil];
        NSInteger newState = 0;
        
        if (![myToggleSwitch isEnabled]) {
            NSBeep();
            
            return YES;
        }
        
        switch ([currentEvent type]) {
            case NSLeftMouseDown:
                isMouseDown = YES;
                
                if (NSPointInRect(currentPosition, BoundsOfHandle)) {
                    isMouseAboveHandle = YES;
                } else {
                    isMouseAboveHandle = NO;
                }
                
                break;
            case NSLeftMouseDragged:
                isMouseDragging = YES;
                
                if (isMouseAboveHandle) {
                    myHandlePosition.x = myHandlePosition.x + (currentPosition.x - previousPosition.x);
                }
                
                break;
            default:
                isMouseDown = NO;
                
                if (isMouseDragging) {
                    CGFloat middleX = NSMidX(rect);
                    CGFloat distanceA = middleX - myHandlePosition.x;
                    CGFloat distanceB = (myHandlePosition.x + [myHandle size].width) - middleX;
                    BOOL isOn = (previousState == NSOnState) ? YES : NO;
                    
                    newState = (!isOn && (distanceA < distanceB)) ? NSOnState : NSOffState;
                } else {
                    newState = (previousState == NSOnState) ? NSOffState : NSOnState;
                }
                
                if (previousState != newState) {
                    [self setState: newState];
                    
                    [myDelegate toggleSwitchDidChangeState: myToggleSwitch];
                }
                
                isMouseDragging = NO;
                
                [view setNeedsDisplay: YES];
                
                return YES;
        }
        
        [view setNeedsDisplay: YES];
        
        previousPosition = currentPosition;
    } while ((currentEvent = [[view window] nextEventMatchingMask: (NSLeftMouseDraggedMask | NSLeftMouseUpMask)
                                                        untilDate: [NSDate distantFuture]
                                                           inMode: NSEventTrackingRunLoopMode
                                                          dequeue: YES]));
    
    return YES;
}

#pragma mark -

- (void)dealloc {
    [mySliderBackground release];
    [mySliderMask release];
    [myHandle release];
    [myHandlePressed release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleToggleSwitchCell (SpectacleToggleSwitchCellPrivate)

- (void)drawHandleInRect: (NSRect)rect atPosition: (NSPoint)position {
    NSImage *handleImage = nil;
    
    if (isMouseDown && isMouseAboveHandle) {
        handleImage = myHandlePressed;
    } else {
        handleImage = myHandle;
    }
    
    [handleImage drawAtPoint: position fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.0f];
}

- (void)drawLabelsInRect: (NSRect)rect withSliderSize: (NSSize)sliderSize andHorizontalAdjustment: (CGFloat)horizontalAdjustment {
    NSColor *foregroundColor = [NSColor colorWithCalibratedRed: 0.294f green: 0.294f blue: 0.294f alpha: 1.00f];
    NSRect labelRect = rect;
    
    labelRect.origin.x = horizontalAdjustment - 46.0f;
    labelRect.size.width = 40.0f;
    
    [self drawString: ZeroKitLocalizedStringFromCurrentBundle(@"OFF") withForegroundColor: foregroundColor inRect: labelRect];
    
    labelRect.origin.x = horizontalAdjustment + sliderSize.width + 2.0f;
    
    if ([self state] == NSOnState) {
        foregroundColor = [NSColor colorWithCalibratedRed: 0.263f green: 0.529f blue: 0.929f alpha: 1.00f];
    }
    
    [self drawString: ZeroKitLocalizedStringFromCurrentBundle(@"ON") withForegroundColor: foregroundColor inRect: labelRect];
}

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundColor inRect: (NSRect)rect {
    NSMutableDictionary *attributes = [SpectacleUtilities createStringAttributesWithShadow];
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *arial = [NSFont fontWithName: @"Arial" size: 18.0f];
    NSFont *boldArial = [fontManager convertFont: arial toHaveTrait: NSBoldFontMask];
    NSRect labelRect = rect;
    
    if (boldArial) {
        [attributes setObject: boldArial forKey: NSFontAttributeName];
    } else {
        [attributes setObject: [NSFont boldSystemFontOfSize: 18.0f] forKey: NSFontAttributeName];
    }
    
    [attributes setObject: foregroundColor forKey: NSForegroundColorAttributeName];
    
    labelRect.origin.y = NSMidY(rect) - ([string sizeWithAttributes: attributes].height / 2.0f) - 6.0f;
    
    [string drawInRect: labelRect withAttributes: attributes];
}

@end
