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

    if (screens.count <= 1) {
        return result;
    }

    NSArray *screensInConsistentOrder = [[screens sortedArrayWithOptions: NSSortStable usingComparator: ^(NSScreen *screenOne, NSScreen *screenTwo) {
        if (CGPointEqualToPoint(screenOne.frame.origin, CGPointMake(0, 0))) {
            return NSOrderedAscending;
        } else if (CGPointEqualToPoint(screenTwo.frame.origin, CGPointMake(0, 0))) {
            return NSOrderedDescending;
        }

        return (NSComparisonResult)(screenTwo.frame.origin.y - screenOne.frame.origin.y);
    }] sortedArrayWithOptions: NSSortStable usingComparator: ^(NSScreen *screenOne, NSScreen *screenTwo) {
        if (CGPointEqualToPoint(screenOne.frame.origin, CGPointMake(0, 0))) {
            return NSOrderedAscending;
        } else if (CGPointEqualToPoint(screenTwo.frame.origin, CGPointMake(0, 0))) {
            return NSOrderedDescending;
        }

        return (NSComparisonResult)(screenTwo.frame.origin.x - screenOne.frame.origin.x);
    }];

    for (NSInteger i = 0; i < screensInConsistentOrder.count; i++) {
        NSScreen *currentScreen = screensInConsistentOrder[i];
        CGRect currentFrameOfScreen = NSRectToCGRect(currentScreen.frame);
        NSInteger nextOrPreviousIndex = i;

        if (!CGRectEqualToRect(currentFrameOfScreen, frameOfScreen)) {
            continue;
        }

        if (action == SpectacleWindowActionNextDisplay) {
            nextOrPreviousIndex++;
        } else if (action == SpectacleWindowActionPreviousDisplay) {
            nextOrPreviousIndex--;
        }

        if (nextOrPreviousIndex < 0) {
            nextOrPreviousIndex = screens.count - 1;
        } else if (nextOrPreviousIndex >= screens.count) {
            nextOrPreviousIndex = 0;
        }

        result = screens[nextOrPreviousIndex];

        break;
    }
    
    return result;
}

@end
