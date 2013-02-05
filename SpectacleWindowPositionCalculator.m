#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleConstants.h"

#define AgainstTheLeftEdgeOfScreen(a, b) (a.origin.x <= b.origin.x)
#define AgainstTheRightEdgeOfScreen(a, b) (CGRectGetMaxX(a) >= CGRectGetMaxX(b))
#define AgainstTheTopEdgeOfScreen(a, b) (CGRectGetMaxY(a) >= CGRectGetMaxY(b))
#define AgainstTheBottomEdgeOfScreen(a, b) (a.origin.y <= b.origin.y)

#pragma mark -

@interface SpectacleWindowPositionCalculator (SpectacleWindowPositionCalculatorPrivate)

+ (NSArray *)thirdsFromVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen;

+ (CGRect)findThirdForWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

#pragma mark -

+ (BOOL)isWindowRect: (CGRect)windowRect tooSmallRelativeToVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen;

@end

#pragma mark -

@implementation SpectacleWindowPositionCalculator

+ (CGRect)calculateWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action {
    if ((action >= SpectacleWindowActionRightHalf) && (action <= SpectacleWindowActionLowerRight)) {
        windowRect.origin.x = visibleFrameOfScreen.origin.x + floor(visibleFrameOfScreen.size.width / 2.0f);
    } else if (MovingToCenterRegionOfDisplay(action)) {
        windowRect.origin.x = floor(visibleFrameOfScreen.size.width / 2.0f) - floor(windowRect.size.width / 2.0f) + visibleFrameOfScreen.origin.x;
    } else if (!MovingToThirdOfDisplay(action)) {
        windowRect.origin.x = visibleFrameOfScreen.origin.x;
    }
    
    if (MovingToTopRegionOfDisplay(action)) {
        windowRect.origin.y = visibleFrameOfScreen.origin.y + floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (MovingToCenterRegionOfDisplay(action)) {
        windowRect.origin.y = floor(visibleFrameOfScreen.size.height / 2.0f) - floor(windowRect.size.height / 2.0f) + visibleFrameOfScreen.origin.y;
    } else if (!MovingToThirdOfDisplay(action)) {
        windowRect.origin.y = visibleFrameOfScreen.origin.y;
    }
    
    if ((action == SpectacleWindowActionLeftHalf) || (action == SpectacleWindowActionRightHalf)) {
        windowRect.size.width = floor(visibleFrameOfScreen.size.width / 2.0f);
        windowRect.size.height = visibleFrameOfScreen.size.height;
    } else if ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionBottomHalf)) {
        windowRect.size.width = visibleFrameOfScreen.size.width;
        windowRect.size.height = floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (MovingToUpperOrLowerLeftOfDisplay(action) || MovingToUpperOrLowerRightDisplay(action)) {
        windowRect.size.width = floor(visibleFrameOfScreen.size.width / 2.0f);
        windowRect.size.height = floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (!MovingToCenterRegionOfDisplay(action) && !MovingToThirdOfDisplay(action)) {
        windowRect.size.width = visibleFrameOfScreen.size.width;
        windowRect.size.height = visibleFrameOfScreen.size.height;
    }
    
    if (MovingToThirdOfDisplay(action)) {
        windowRect = [SpectacleWindowPositionCalculator findThirdForWindowRect: windowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
    }
    
    if (MovingToTopRegionOfDisplay(action)) {
        if (((visibleFrameOfScreen.size.height / 2.0f) - windowRect.size.height) > 0.0f) {
            windowRect.origin.y = windowRect.origin.y + 1.0f;
        } else {
            windowRect.origin.y = windowRect.origin.y + 1.0f;
            windowRect.size.height = windowRect.size.height - 1.0f;
        }
        
        windowRect.origin.y = windowRect.origin.y + 1.0f;
    }
    
    if ((action >= SpectacleWindowActionLeftHalf) && (action <= SpectacleWindowActionLowerLeft)) {
        windowRect.size.width = windowRect.size.width - 1.0f;
    }
    
    return windowRect;
}

+ (CGRect)calculateResizedWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen sizeOffset: (CGFloat)sizeOffset {
    CGRect previousWindowRect = windowRect;
    
    windowRect.size.width = windowRect.size.width + sizeOffset;
    windowRect.origin.x = windowRect.origin.x - floor(sizeOffset / 2.0f);
    
    if (AgainstTheRightEdgeOfScreen(previousWindowRect, visibleFrameOfScreen)) {
        windowRect.origin.x = CGRectGetMaxX(visibleFrameOfScreen) - windowRect.size.width;
        
        if (AgainstTheLeftEdgeOfScreen(previousWindowRect, visibleFrameOfScreen)) {
            windowRect.size.width = visibleFrameOfScreen.size.width;
        }
    }
    
    if (AgainstTheLeftEdgeOfScreen(previousWindowRect, visibleFrameOfScreen)) {
        windowRect.origin.x = visibleFrameOfScreen.origin.x;
    }
    
    if (windowRect.size.width >= visibleFrameOfScreen.size.width) {
        windowRect.size.width = visibleFrameOfScreen.size.width;
    }
    
    windowRect.size.height = windowRect.size.height + sizeOffset;
    windowRect.origin.y = windowRect.origin.y - floor(sizeOffset / 2.0f);
    
    if (AgainstTheTopEdgeOfScreen(previousWindowRect, visibleFrameOfScreen)) {
        windowRect.origin.y = CGRectGetMaxY(visibleFrameOfScreen) - windowRect.size.height;
        
        if (AgainstTheBottomEdgeOfScreen(previousWindowRect, visibleFrameOfScreen)) {
            windowRect.size.height = visibleFrameOfScreen.size.height;
        }
    }
    
    if (AgainstTheBottomEdgeOfScreen(previousWindowRect, visibleFrameOfScreen)) {
        windowRect.origin.y = visibleFrameOfScreen.origin.y;
    }
    
    if (windowRect.size.height >= visibleFrameOfScreen.size.height) {
        windowRect.size.height = visibleFrameOfScreen.size.height;
        windowRect.origin.y = previousWindowRect.origin.y;
    }
    
    if (CGRectEqualToRect(previousWindowRect, visibleFrameOfScreen) && (sizeOffset < 0)) {
        windowRect.size.width = previousWindowRect.size.width + sizeOffset;
        windowRect.origin.x = previousWindowRect.origin.x - floor(sizeOffset / 2.0f);
        
        windowRect.size.height = previousWindowRect.size.height + sizeOffset;
        windowRect.origin.y = previousWindowRect.origin.y - floor(sizeOffset / 2.0f);
    }
    
    if ([SpectacleWindowPositionCalculator isWindowRect: windowRect tooSmallRelativeToVisibleFrameOfScreen: visibleFrameOfScreen]) {
        windowRect = previousWindowRect;
    }
    
    return windowRect;
}

@end

#pragma mark -

@implementation SpectacleWindowPositionCalculator (SpectacleWindowPositionCalculatorPrivate)

+ (NSArray *)thirdsFromVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen {
    NSMutableArray *result = [NSMutableArray new];
    NSInteger i = 0;
    
    for (i = 0; i < 3; i++) {
        CGRect thirdOfScreen = visibleFrameOfScreen;
        
        thirdOfScreen.origin.x = visibleFrameOfScreen.origin.x + (floor(visibleFrameOfScreen.size.width / 3.0f) * i);
        thirdOfScreen.size.width = floor(visibleFrameOfScreen.size.width / 3.0f);
        
        [result addObject: [SpectacleHistoryItem historyItemFromAccessibilityElement: nil windowRect: thirdOfScreen]];
    }
    
    for (i = 0; i < 3; i++) {
        CGRect thirdOfScreen = visibleFrameOfScreen;
        
        thirdOfScreen.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height - (floor(visibleFrameOfScreen.size.height / 3.0f) * (i + 1));
        thirdOfScreen.size.height = floor(visibleFrameOfScreen.size.height / 3.0f);
        
        if (i == 2) {
            thirdOfScreen.origin.y = thirdOfScreen.origin.y - 1.0f;
            thirdOfScreen.size.height = thirdOfScreen.size.height + 1.0f;
        }
        
        [result addObject: [SpectacleHistoryItem historyItemFromAccessibilityElement: nil windowRect: thirdOfScreen]];
    }
    
    return result;
}

+ (CGRect)findThirdForWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    NSArray *thirds = [SpectacleWindowPositionCalculator thirdsFromVisibleFrameOfScreen: visibleFrameOfScreen];
    CGRect result = [thirds[0] windowRect];
    NSInteger i = 0;
    
    for (i = 0; i < [thirds count]; i++) {
        CGRect currentWindowRect = [thirds[i] windowRect];
        
        if (CGRectEqualToRect(currentWindowRect, windowRect)) {
            NSInteger j = i;
            
            if (action == SpectacleWindowActionNextThird) {
                if (++j >= [thirds count]) {
                    j = 0;
                }
            } else if (action == SpectacleWindowActionPreviousThird) {
                if (--j < 0) {
                    j = [thirds count] - 1;
                }
            }
            
            result = [thirds[j] windowRect];
            
            break;
        }
    }
    
    return result;
}

#pragma mark -

+ (BOOL)isWindowRect: (CGRect)windowRect tooSmallRelativeToVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen {
    CGFloat minimumWindowRectWidth = floor(visibleFrameOfScreen.size.width / SpectacleMinimumWindowSizeRatio);
    CGFloat minimumWindowRectHeight = floor(visibleFrameOfScreen.size.height / SpectacleMinimumWindowSizeRatio);
    
    return (windowRect.size.width <= minimumWindowRectWidth) || (windowRect.size.height <= minimumWindowRectHeight);
}

@end
