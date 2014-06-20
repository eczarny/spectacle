#import "SpectacleScreenDetection.h"
#import "SpectacleUtilities.h"

@implementation SpectacleScreenDetection

+ (NSScreen *)screenWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect {
    NSScreen *result = [self screenContainingRect: rect];
    
    if (MovingToNextOrPreviousDisplay(action)) {
        result = [self nextOrPreviousScreenToFrameOfScreen: NSRectToCGRect([result frame]) inDirectionOfAction: action];
    }
    
    return result;
}

#pragma mark -

+ (NSScreen *)screenContainingRect: (CGRect)rect {
    CGFloat largestPercentageOfRectWithinFrameOfScreen = 0.0f;
    NSScreen *result = NSScreen.mainScreen;
    
    for (NSScreen *currentScreen in [NSScreen screens]) {
        CGRect currentFrameOfScreen = NSRectToCGRect(currentScreen.frame);
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

#pragma mark -

+ (NSScreen *)nextOrPreviousScreenToFrameOfScreen: (CGRect)frameOfScreen inDirectionOfAction: (SpectacleWindowAction)action {
    NSArray *screens = NSScreen.screens;
    NSScreen *result = nil;
    NSInteger lastDeltaX = 0;
    NSInteger lastDeltaY = 0;
    
    if (screens.count <= 1) {
        return result;
    }
    
    for (NSInteger i = 0; i < screens.count; i++) {
        NSScreen *currentScreen = screens[i];
        CGRect currentFrameOfScreen = NSRectToCGRect(currentScreen.frame);
        
        if (CGRectEqualToRect(currentFrameOfScreen, frameOfScreen)) {
            continue;
        }

        NSInteger screenDeltaX = (frameOfScreen.origin.x - currentFrameOfScreen.origin.x) ;
        NSInteger screenDeltaY = (frameOfScreen.origin.y - currentFrameOfScreen.origin.y) ;
        NSInteger dir = (action == SpectacleWindowActionNextDisplay) ? -1 : 1;

        if ((screenDeltaX * dir > 0 ||
             (screenDeltaX == 0 &&
              screenDeltaY * dir > 0)) &&
            (result == nil ||
             (screenDeltaX * dir) < lastDeltaX ||
             (screenDeltaX == 0 &&
              (screenDeltaY * dir) < lastDeltaY))) {
            result = [screens objectAtIndex: i];
            lastDeltaX = screenDeltaX * dir;
            lastDeltaY = screenDeltaY * dir;
        }
    }
    
    return result;
}

@end
