// 
// Copyright (c) 2010 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

#import "SpectacleToggleSwitchCell.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

#define HandleBounds NSMakeRect(myHandlePosition.x, myHandlePosition.y, [myHandle size].width, [myHandle size].height)

#pragma mark -

@interface SpectacleToggleSwitchCell (SpectacleToggleSwitchCellPrivate)

- (void)drawHandleInRect: (NSRect)rect atPosition: (NSPoint)position;

#pragma mark -

- (void)drawLabelsInRect: (NSRect)rect withSliderSize: (NSSize)sliderSize andHorizontalAdjustment: (CGFloat)horizontalAdjustment;

#pragma mark -

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundcolor inRect: (NSRect)rect;

@end

#pragma mark -

@implementation SpectacleToggleSwitchCell

- (id)init {
    if (self = [super init]) {
        mySliderBackground = [SpectacleUtilities imageFromResource: SpectacleSliderBackgroundImage];
        mySliderMask = [SpectacleUtilities imageFromResource: SpectacleSliderMaskImage];
        myHandle = [SpectacleUtilities imageFromResource: SpectacleSliderHandleImage];
        myHandlePressed = [SpectacleUtilities imageFromResource: SpectacleSliderHandlePressedImage];
        myHandlePosition = NSZeroPoint;
        isMouseDown = NO;
        isMouseDragging = NO;
        isMouseAboveHandle = NO;
    }
    
    return self;
}

#pragma mark -

- (void)drawWithFrame: (NSRect)frame inView: (NSView *)view {
    CGSize sliderSize = [mySliderBackground size];
    CGSize handleSize = [myHandle size];
    CGFloat x = NSMidX(frame) - floor(sliderSize.width / 2.0f);
    CGFloat maxX = x + (sliderSize.width - handleSize.width);
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [mySliderBackground drawAtPoint: NSMakePoint(x, 0.0f) fromRect: frame operation: NSCompositeCopy fraction: 1.0f];
    
    if (myHandlePosition.x <= x) {
        myHandlePosition = NSMakePoint(x, 0.0f);
    } else if (myHandlePosition.x >= maxX) {
        myHandlePosition = NSMakePoint(maxX, 0.0f);
    }
    
    [self drawHandleInRect: frame atPosition: myHandlePosition];
    
    [mySliderMask drawAtPoint: NSMakePoint(x, 0.0f) fromRect: frame operation: NSCompositeSourceAtop fraction: 1.0f];
    
    [self drawLabelsInRect: frame withSliderSize: sliderSize andHorizontalAdjustment: x];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

#pragma mark -

- (BOOL)trackMouse: (NSEvent *)event inRect: (NSRect)rect ofView: (NSView *)view untilMouseUp: (BOOL)untilMouseUp {
    NSEvent *currentEvent = event;
    NSPoint previousPosition = NSZeroPoint;
    
    do {
        NSPoint currentPosition = [view convertPoint: [currentEvent locationInWindow] fromView: nil];
        
        switch ([currentEvent type]) {
            case NSLeftMouseDown:
                isMouseDown = YES;
                
                if (NSPointInRect(currentPosition, HandleBounds)) {
                    isMouseAboveHandle = YES;
                } else {
                    isMouseAboveHandle = NO;
                }
                
                break;
            case NSLeftMouseDragged:
                if (isMouseAboveHandle) {
                    myHandlePosition.x = myHandlePosition.x + (currentPosition.x - previousPosition.x);
                }
                
                isMouseDragging = YES;
                
                break;
            default:
                isMouseDragging = NO;
                isMouseDown = NO;
                
                [view setNeedsDisplay: YES];
                
                return YES;
        }
        
        [view setNeedsDisplay: YES];
        
        previousPosition = currentPosition;
    } while (currentEvent = [[view window] nextEventMatchingMask: (NSLeftMouseDraggedMask | NSLeftMouseUpMask)
                                                       untilDate: [NSDate distantFuture]
                                                          inMode: NSEventTrackingRunLoopMode
                                                         dequeue: YES]);
    
    return YES;
}

#pragma mark -

- (void)mouseEntered: (NSEvent *)event {
    isMouseAboveHandle = YES;
}

- (void)mouseExited: (NSEvent *)event {
    isMouseAboveHandle = NO;
}

@end

#pragma mark -

@implementation SpectacleToggleSwitchCell (SpectacleToggleSwitchCellPrivate)

- (void)drawHandleInRect: (NSRect)rect atPosition: (NSPoint)position {
    if (isMouseDown && isMouseAboveHandle) {
        [myHandlePressed drawAtPoint: position fromRect: rect operation: NSCompositeSourceOver fraction: 1.0f];
    } else {
        [myHandle drawAtPoint: position fromRect: rect operation: NSCompositeSourceOver fraction: 1.0f];
    }
}

#pragma mark -

- (void)drawLabelsInRect: (NSRect)rect withSliderSize: (NSSize)sliderSize andHorizontalAdjustment: (CGFloat)horizontalAdjustment {
    NSColor *foregroundColor = [NSColor disabledControlTextColor];
    NSRect labelRect = rect;
    
    labelRect.origin.x = horizontalAdjustment - 46.0f;
    labelRect.size.width = 40.0f;
    
    [self drawString: @"OFF" withForegroundColor: foregroundColor inRect: labelRect];
    
    labelRect.origin.x = horizontalAdjustment + sliderSize.width + 2.0f;
    
    if ([self state] == NSOnState) {
        foregroundColor = [NSColor colorWithCalibratedRed: 0.263 green:0.529 blue: 0.929 alpha: 1.00];
    }
    
    [self drawString: @"ON" withForegroundColor: foregroundColor inRect: labelRect];
}

#pragma mark -

- (void)drawString: (NSString *)string withForegroundColor: (NSColor *)foregroundColor inRect: (NSRect)rect {
    NSMutableDictionary *attributes = [SpectacleUtilities createStringAttributesWithShadow];
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *arial = [NSFont fontWithName: @"Arial" size: 18.0f];
    NSFont *boldArial = [fontManager convertFont: arial toHaveTrait: NSBoldFontMask];
    NSRect labelRect = rect;
    
    [attributes setObject: boldArial forKey: NSFontAttributeName];
    [attributes setObject: foregroundColor forKey: NSForegroundColorAttributeName];
    
    labelRect.origin.y = NSMidY(rect) - ([string sizeWithAttributes: attributes].height / 2.0f) - 6.0f;
    
    [string drawInRect: labelRect withAttributes: attributes];
}

@end
