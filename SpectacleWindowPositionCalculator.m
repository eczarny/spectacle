#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleHistoryItem.h"

@interface SpectacleWindowPositionCalculator (SpectacleWindowPositionCalculatorPrivate)

+ (NSArray *)thirdsFromVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen;

+ (CGRect)findThirdForFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

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
        windowRect = [SpectacleWindowPositionCalculator findThirdForFrontMostWindowRect: windowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
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

+ (CGRect)calculateResizedWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage {
    CGFloat widthAdjustment = floor(windowRect.size.width * percentage);
    CGFloat heightAdjustment = floor(windowRect.size.height * percentage);
    
    windowRect.size.width = windowRect.size.width + widthAdjustment;
    windowRect.origin.x = windowRect.origin.x - (widthAdjustment / 2.0f);
    
    if (windowRect.size.width > visibleFrameOfScreen.size.width) {
        windowRect.size.width = visibleFrameOfScreen.size.width;
    }
    
    windowRect.size.height = windowRect.size.height + heightAdjustment;
    windowRect.origin.y = windowRect.origin.y - (heightAdjustment / 2.0f);
    
    if (windowRect.size.height > visibleFrameOfScreen.size.height) {
        windowRect.size.height = visibleFrameOfScreen.size.height;
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

+ (CGRect)findThirdForFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    NSArray *thirds = [SpectacleWindowPositionCalculator thirdsFromVisibleFrameOfScreen: visibleFrameOfScreen];
    CGRect result = [thirds[0] windowRect];
    NSInteger i = 0;
    
    for (i = 0; i < [thirds count]; i++) {
        CGRect currentWindowRect = [thirds[i] windowRect];
        
        if (CGRectEqualToRect(currentWindowRect, frontMostWindowRect)) {
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

@end
