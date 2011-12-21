#import "SpectacleScreenDetection.h"
#import "SpectacleUtilities.h"

@interface SpectacleScreenDetection (SpectacleScreenDetectionPrivate)

+ (NSScreen *)screenAdjacentToFrameOfScreen: (CGRect)frameOfScreen inDirectionOfAction: (SpectacleWindowAction)action;

+ (NSScreen *)screenContainingRect: (CGRect)rect;

#pragma mark -

+ (CGFloat)percentageOfRect: (CGRect)rect withinFrameOfScreen: (CGRect)frameOfScreen;

@end

#pragma mark -

@implementation SpectacleScreenDetection

+ (NSScreen *)screenWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect {
    NSScreen *result = [self screenContainingRect: rect];
    
    if (MovingToDisplay(action)) {
        result = [self screenAdjacentToFrameOfScreen: NSRectToCGRect([result frame]) inDirectionOfAction: action];
    }
    
    return result;
}

@end

#pragma mark -

@implementation SpectacleScreenDetection (SpectacleScreenDetectionPrivate)

+ (NSScreen *)screenAdjacentToFrameOfScreen: (CGRect)frameOfScreen inDirectionOfAction: (SpectacleWindowAction)action {
    NSScreen *result = nil;
    
    for (NSScreen *currentScreen in [NSScreen screens]) {
        CGRect currentFrameOfScreen = NSRectToCGRect([currentScreen frame]);
        
        if (CGRectEqualToRect(currentFrameOfScreen, frameOfScreen)) {
            continue;
        }
        
        if ((action == SpectacleWindowActionLeftDisplay) && RectIsLeftOfRect(currentFrameOfScreen, frameOfScreen)) {
            result = currentScreen;
        } else if ((action == SpectacleWindowActionRightDisplay) && RectIsRightOfRect(currentFrameOfScreen, frameOfScreen)) {
            result = currentScreen;
        } else if ((action == SpectacleWindowActionTopDisplay) && RectIsAboveRect(currentFrameOfScreen, frameOfScreen)) {
            result = currentScreen;
        } else if ((action == SpectacleWindowActionBottomDisplay) && RectIsBelowRect(currentFrameOfScreen, frameOfScreen)) {
            result = currentScreen;
        }
    }
    
    return result;
}

+ (NSScreen *)screenContainingRect: (CGRect)rect {
    CGFloat largestPercentageOfRectWithinFrameOfScreen = 0.0f;
    NSScreen *result = [NSScreen mainScreen];
    
    for (NSScreen *currentScreen in [NSScreen screens]) {
        CGRect currentFrameOfScreen = NSRectToCGRect([currentScreen frame]);
        CGRect flippedRect = rect;
        CGFloat percentageOfRectWithinCurrentFrameOfScreen = 0.0f;
        
        flippedRect.origin.y = FlipVerticalOriginOfRectInRect(flippedRect, currentFrameOfScreen);
        
        if (CGRectContainsRect(currentFrameOfScreen, flippedRect)) {
            result = currentScreen;
            
            break;
        }
        
        percentageOfRectWithinCurrentFrameOfScreen = [self percentageOfRect: flippedRect withinFrameOfScreen: currentFrameOfScreen];
        
        if (percentageOfRectWithinCurrentFrameOfScreen > largestPercentageOfRectWithinFrameOfScreen) {
            largestPercentageOfRectWithinFrameOfScreen = percentageOfRectWithinCurrentFrameOfScreen;
            
            result = currentScreen;
        }
    }
    
    return result;
}

#pragma mark -

+ (CGFloat)percentageOfRect: (CGRect)rect withinFrameOfScreen: (CGRect)frameOfScreen {
    CGRect intersectionOfRectAndFrameOfScreen = CGRectIntersection(rect, frameOfScreen);
    CGFloat result = 0.0f;
    
    if (!CGRectIsNull(intersectionOfRectAndFrameOfScreen)) {
        result = AreaOfRect(intersectionOfRectAndFrameOfScreen) / AreaOfRect(rect);
    }
    
    return result;
}

@end
