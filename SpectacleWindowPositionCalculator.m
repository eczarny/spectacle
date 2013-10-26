#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleConstants.h"

#define AgainstTheLeftEdgeOfScreen(a, b) (a.origin.x <= b.origin.x)
#define AgainstTheRightEdgeOfScreen(a, b) (CGRectGetMaxX(a) >= CGRectGetMaxX(b))
#define AgainstTheTopEdgeOfScreen(a, b) (CGRectGetMaxY(a) >= CGRectGetMaxY(b))
#define AgainstTheBottomEdgeOfScreen(a, b) (a.origin.y <= b.origin.y)

#pragma mark -

#define AlreadyTwoThirdsOfDisplay(a, b) (abs(a.size.width - floor((b.size.width * 2.0f) / 3.0f)) < SpectacleWindowCalculationFudgeFactor) && (a.size.height == b.size.height)
#define AlreadyOneHalfOfDisplay(a, b) (abs(a.size.width - (b.size.width / 2.0f)) < SpectacleWindowCalculationFudgeFactor) && (a.size.height == b.size.height)

#define IsMovingToNewHalfOfDisplay(a, b) (((action == SpectacleWindowActionLeftHalf) && AgainstTheRightEdgeOfScreen(a, b)) || ((action == SpectacleWindowActionRightHalf) && AgainstTheLeftEdgeOfScreen(a, b)))

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
    CGRect calculateWindowRect = windowRect;
    
    if ((action >= SpectacleWindowActionRightHalf) && (action <= SpectacleWindowActionLowerRight)) {
        calculateWindowRect.origin.x = visibleFrameOfScreen.origin.x + floor(visibleFrameOfScreen.size.width / 2.0f);
    } else if (MovingToCenterRegionOfDisplay(action)) {
        calculateWindowRect.origin.x = floor(visibleFrameOfScreen.size.width / 2.0f) - floor(calculateWindowRect.size.width / 2.0f) + visibleFrameOfScreen.origin.x;
    } else if (!MovingToThirdOfDisplay(action)) {
        calculateWindowRect.origin.x = visibleFrameOfScreen.origin.x;
    }
    
    if (MovingToTopRegionOfDisplay(action)) {
        calculateWindowRect.origin.y = visibleFrameOfScreen.origin.y + floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (MovingToCenterRegionOfDisplay(action)) {
        calculateWindowRect.origin.y = floor(visibleFrameOfScreen.size.height / 2.0f) - floor(calculateWindowRect.size.height / 2.0f) + visibleFrameOfScreen.origin.y;
    } else if (!MovingToThirdOfDisplay(action)) {
        calculateWindowRect.origin.y = visibleFrameOfScreen.origin.y;
    }
    
    if ((action == SpectacleWindowActionLeftHalf) || (action == SpectacleWindowActionRightHalf)) {
        if (AlreadyOneHalfOfDisplay(calculateWindowRect, visibleFrameOfScreen) && !IsMovingToNewHalfOfDisplay(windowRect, visibleFrameOfScreen)) {
            calculateWindowRect.size.width = floor((visibleFrameOfScreen.size.width * 2.0f) / 3.0f);
        } else if (AlreadyTwoThirdsOfDisplay(calculateWindowRect, visibleFrameOfScreen) && !IsMovingToNewHalfOfDisplay(windowRect, visibleFrameOfScreen)) {
            calculateWindowRect.size.width = floor(visibleFrameOfScreen.size.width / 3.0f);
        } else {
            calculateWindowRect.size.width = floor(visibleFrameOfScreen.size.width / 2.0f);
        }
        
        if (action == SpectacleWindowActionRightHalf) {
            calculateWindowRect.origin.x = visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width - calculateWindowRect.size.width;
        }
        
        calculateWindowRect.size.height = visibleFrameOfScreen.size.height;
    } else if ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionBottomHalf)) {
        calculateWindowRect.size.width = visibleFrameOfScreen.size.width;
        calculateWindowRect.size.height = floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (MovingToUpperOrLowerLeftOfDisplay(action) || MovingToUpperOrLowerRightDisplay(action)) {
        calculateWindowRect.size.width = floor(visibleFrameOfScreen.size.width / 2.0f);
        calculateWindowRect.size.height = floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (!MovingToCenterRegionOfDisplay(action) && !MovingToThirdOfDisplay(action)) {
        calculateWindowRect.size.width = visibleFrameOfScreen.size.width;
        calculateWindowRect.size.height = visibleFrameOfScreen.size.height;
    }
    
    if (MovingToThirdOfDisplay(action)) {
        calculateWindowRect = [SpectacleWindowPositionCalculator findThirdForWindowRect: calculateWindowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
    }
    
    if (MovingToTopRegionOfDisplay(action)) {
        if (((visibleFrameOfScreen.size.height / 2.0f) - calculateWindowRect.size.height) > 0.0f) {
            calculateWindowRect.origin.y = calculateWindowRect.origin.y + 1.0f;
        } else {
            calculateWindowRect.origin.y = calculateWindowRect.origin.y + 1.0f;
            calculateWindowRect.size.height = calculateWindowRect.size.height - 1.0f;
        }
        
        calculateWindowRect.origin.y = calculateWindowRect.origin.y + 1.0f;
    }
    
    if ((action >= SpectacleWindowActionLeftHalf) && (action <= SpectacleWindowActionLowerLeft)) {
        calculateWindowRect.size.width = calculateWindowRect.size.width - 1.0f;
    }
    
    return calculateWindowRect;
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
        
        if ((i == 2) && (fmodf(visibleFrameOfScreen.size.height, 3.0f) != 0.0f)) {
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
