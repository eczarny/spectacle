#import "SpectacleWindowPositionManager.h"
#import "SpectacleScreenDetection.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"

#define MovingToCenterRegionOfDisplay(action) (action == SpectacleWindowActionCenter)
#define MovingToTopRegionOfDisplay(action) ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionUpperRight))
#define MovingToUpperOrLowerLeftOfDisplay(action) ((action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionLowerLeft))
#define MovingToUpperOrLowerRightDisplay(action) ((action == SpectacleWindowActionUpperRight) || (action == SpectacleWindowActionLowerRight))

#pragma mark -

#define MovingToThirdOfDisplay(action) ((action == SpectacleWindowActionNextThird) || (action == SpectacleWindowActionPreviousThird))

#pragma mark -

#define CurrentWorkspace [SpectacleUtilities currentWorkspace]
#define CurrentWorkspaceKey [NSString stringWithFormat: @"Workspace%d", CurrentWorkspace]

#pragma mark -

#define CurrentUndoHistory [myUndoHistory objectForKey: CurrentWorkspaceKey]
#define CurrentRedoHistory [myRedoHistory objectForKey: CurrentWorkspaceKey]

#pragma mark -

@interface SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (ZeroKitAccessibilityElement *)frontMostWindowElement;

#pragma mark -

- (CGRect)rectOfWindowWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement;

#pragma mark -

- (void)moveWindowRect: (CGRect)windowRect frameOfScreen: (CGRect)frameOfScreen visibleFrameOfScreen: (CGRect)visibleFrameOfScreen frontMostWindowElement: (ZeroKitAccessibilityElement *)frontMostWindowElement action: (SpectacleWindowAction)action;

- (void)moveWindowRect: (CGRect)windowRect frontMostWindowElement: (ZeroKitAccessibilityElement *)frontMostWindowElement;

#pragma mark -

- (CGRect)recalculateWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action;

- (CGRect)recalculateCenteredWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage;

#pragma mark -

- (NSArray *)thirdsFromVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen;

- (CGRect)findThirdForFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

@end

#pragma mark -

@interface SpectacleWindowPositionManager (WindowHistory)

- (void)moveWithHistory: (NSMutableArray *)history action: (SpectacleWindowAction)action;

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action;

#pragma mark -

- (void)addHistoryItemToUndoHistory: (SpectacleHistoryItem *)historyItem;

- (void)addHistoryItemToRedoHistory: (SpectacleHistoryItem *)historyItem;

@end

#pragma mark -

@implementation SpectacleWindowPositionManager

static SpectacleWindowPositionManager *sharedInstance = nil;

- (id)init {
    if ((self = [super init])) {
        myUndoHistory = [[NSMutableDictionary dictionary] retain];
        myRedoHistory = [[NSMutableDictionary dictionary] retain];
    }
    
    return self;
}

#pragma mark -

+ (id)allocWithZone: (NSZone *)zone {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone: zone];
            
            return sharedInstance;
        }
    }
    
    return nil;
}

#pragma mark -

+ (SpectacleWindowPositionManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (void)moveFrontMostWindowWithAction: (SpectacleWindowAction)action {
    ZeroKitAccessibilityElement *frontMostWindowElement = [self frontMostWindowElement];
    CGRect frontMostWindowRect = [self rectOfWindowWithAccessibilityElement: frontMostWindowElement];
    CGRect previousFrontMostWindowRect = CGRectNull;
    NSScreen *screenOfDisplay = [SpectacleScreenDetection screenWithAction: action andRect: frontMostWindowRect];
    CGRect frameOfScreen = CGRectNull;
    CGRect visibleFrameOfScreen = CGRectNull;
    SpectacleHistoryItem *historyItem = nil;
    
    if (screenOfDisplay) {
        frameOfScreen = NSRectToCGRect([screenOfDisplay frame]);
        visibleFrameOfScreen = NSRectToCGRect([screenOfDisplay visibleFrame]);
    }
    
    if (CGRectIsNull(frontMostWindowRect) || CGRectIsNull(frameOfScreen) || CGRectIsNull(visibleFrameOfScreen)) {
        NSBeep();
        
        return;
    }
    
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement: frontMostWindowElement
                                                                 windowRect: frontMostWindowRect];
    
    [self addHistoryItemToUndoHistory: historyItem];
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    if (MovingToDisplay(action) && RectFitsInRect(frontMostWindowRect, visibleFrameOfScreen)) {
        action = SpectacleWindowActionCenter;
    }
    
    previousFrontMostWindowRect = frontMostWindowRect;
    
    frontMostWindowRect = [self recalculateWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen action: action];
    
    if ((action == SpectacleWindowActionCenter) && CGRectEqualToRect(frontMostWindowRect, previousFrontMostWindowRect)) {
        frontMostWindowRect = [self recalculateCenteredWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen percentage: 0.05];
    }
    
    if (CGRectEqualToRect(previousFrontMostWindowRect, frontMostWindowRect)) {
        NSBeep();
        
        return;
    }
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    [self moveWindowRect: frontMostWindowRect frameOfScreen: frameOfScreen visibleFrameOfScreen: visibleFrameOfScreen frontMostWindowElement: frontMostWindowElement action: action];
}

#pragma mark -

- (void)undoLastWindowAction {
    [self moveWithHistory: CurrentUndoHistory action: SpectacleWindowActionUndo];
}

- (void)redoLastWindowAction {
    [self moveWithHistory: CurrentRedoHistory action: SpectacleWindowActionRedo];
}

#pragma mark -

- (void)dealloc {
    [myUndoHistory release];
    [myRedoHistory release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (ZeroKitAccessibilityElement *)frontMostWindowElement {
    ZeroKitAccessibilityElement *systemWideElement = [ZeroKitAccessibilityElement systemWideElement];
    ZeroKitAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute: kAXFocusedApplicationAttribute];
    ZeroKitAccessibilityElement *frontMostWindowElement = nil;
    
    if (applicationWithFocusElement) {
        frontMostWindowElement = [applicationWithFocusElement elementWithAttribute: kAXFocusedWindowAttribute];
        
        if (!frontMostWindowElement) {
            NSLog(@"Invalid accessibility element provided, unable to determine the size and position of the window.");
        }
    } else {
        NSLog(@"Failed to find the application that currently has focus.");
    }
    
    return frontMostWindowElement;
}

#pragma mark -

- (CGRect)rectOfWindowWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement {
    CGRect result = CGRectNull;
    
    if (accessibilityElement) {
        CFTypeRef windowPositionValue = [accessibilityElement valueOfAttribute: kAXPositionAttribute type: kAXValueCGPointType];
        CFTypeRef windowSizeValue = [accessibilityElement valueOfAttribute: kAXSizeAttribute type: kAXValueCGSizeType];
        CGPoint windowPosition;
        CGSize windowSize;
        
        AXValueGetValue(windowPositionValue, kAXValueCGPointType, (void *)&windowPosition);
        AXValueGetValue(windowSizeValue, kAXValueCGSizeType, (void *)&windowSize);
        
        result = CGRectMake(windowPosition.x, windowPosition.y, windowSize.width, windowSize.height);
    }
    
    return result;
}

#pragma mark -

- (void)moveWindowRect: (CGRect)windowRect frameOfScreen: (CGRect)frameOfScreen visibleFrameOfScreen: (CGRect)visibleFrameOfScreen frontMostWindowElement: (ZeroKitAccessibilityElement *)frontMostWindowElement action: (SpectacleWindowAction)action {
    [self moveWindowRect: windowRect frontMostWindowElement: frontMostWindowElement];

    CGRect movedWindowRect = [self rectOfWindowWithAccessibilityElement: [self frontMostWindowElement]];
    
    movedWindowRect.origin.y = FlipVerticalOriginOfRectInRect(movedWindowRect, frameOfScreen);
    
    if (!CGRectContainsRect(visibleFrameOfScreen, movedWindowRect) && (action != SpectacleWindowActionUndo) && (action != SpectacleWindowActionRedo)) {
        if (movedWindowRect.origin.x + movedWindowRect.size.width > visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width) {
            movedWindowRect.origin.x = (visibleFrameOfScreen.origin.x + visibleFrameOfScreen.size.width) - movedWindowRect.size.width;
        } else if (movedWindowRect.origin.x < visibleFrameOfScreen.origin.x) {
            movedWindowRect.origin.x = visibleFrameOfScreen.origin.x;
        }
        
        if (movedWindowRect.origin.y + movedWindowRect.size.height > visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height) {
            movedWindowRect.origin.y = (visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height) - movedWindowRect.size.height;
        } else if (movedWindowRect.origin.y < visibleFrameOfScreen.origin.y) {
            movedWindowRect.origin.y = visibleFrameOfScreen.origin.y;
        }
        
        movedWindowRect.origin.y = FlipVerticalOriginOfRectInRect(movedWindowRect, frameOfScreen);
        
        [self moveWindowRect: movedWindowRect frontMostWindowElement: frontMostWindowElement];
    }
}

- (void)moveWindowRect: (CGRect)windowRect frontMostWindowElement: (ZeroKitAccessibilityElement *)frontMostWindowElement {
    AXValueRef windowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&windowRect.origin);
    AXValueRef windowRectSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&windowRect.size);
    
    [frontMostWindowElement setValue: windowRectSizeRef forAttribute: kAXSizeAttribute];
    [frontMostWindowElement setValue: windowRectPositionRef forAttribute: kAXPositionAttribute];
    [frontMostWindowElement setValue: windowRectSizeRef forAttribute: kAXSizeAttribute];
}

#pragma mark -

- (CGRect)recalculateWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action {
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
        windowRect = [self findThirdForFrontMostWindowRect: windowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
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

- (CGRect)recalculateCenteredWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage {
    CGRect previousWindowRect = windowRect;
    SpectacleWindowAction action = SpectacleWindowActionCenter;
    
    windowRect.size.width = floor(windowRect.size.width + (windowRect.size.width * percentage));
    windowRect.size.height = floor(windowRect.size.height + (windowRect.size.height * percentage));
    
    if (windowRect.size.width >= visibleFrameOfScreen.size.width) {
        windowRect.size.width = previousWindowRect.size.width;
    }
    
    if (windowRect.size.width == previousWindowRect.size.width) {
        windowRect.size.width = visibleFrameOfScreen.size.width;
    }
    
    if (windowRect.size.height >= visibleFrameOfScreen.size.height) {
        windowRect.size.height = previousWindowRect.size.height;
    }
    
    if (windowRect.size.height == previousWindowRect.size.height) {
        windowRect.size.height = visibleFrameOfScreen.size.height;
    }
    
    if (CGRectEqualToRect(windowRect, previousWindowRect)) {
        action = SpectacleWindowActionFullscreen;
    }
    
    return [self recalculateWindowRect: windowRect visibleFrameOfScreen: visibleFrameOfScreen action: action];
}

#pragma mark -

- (NSArray *)thirdsFromVisibleFrameOfScreen: (CGRect)visibleFrameOfScreen {
    NSMutableArray *result = [NSMutableArray array];
    NSInteger i = 0;
    
    for (i = 0; i < 3; i++) {
        CGRect thirdOfScreen = visibleFrameOfScreen;
        
        thirdOfScreen.origin.x = visibleFrameOfScreen.origin.x + (floor(visibleFrameOfScreen.size.width / 3.0f) * i);
        thirdOfScreen.size.width = floor(visibleFrameOfScreen.size.width / 3.0f) - 1.0f;

        [result addObject: [SpectacleHistoryItem historyItemFromAccessibilityElement: nil windowRect: thirdOfScreen]];
    }
    
    for (i = 0; i < 3; i++) {
        CGRect thirdOfScreen = visibleFrameOfScreen;
        
        thirdOfScreen.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.size.height - (floor(visibleFrameOfScreen.size.height / 3.0f) * (i + 1));
        thirdOfScreen.size.height = floor(visibleFrameOfScreen.size.height / 3.0f);
        
        [result addObject: [SpectacleHistoryItem historyItemFromAccessibilityElement: nil windowRect: thirdOfScreen]];
    }
    
    return result;
}

- (CGRect)findThirdForFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    NSArray *thirds = [self thirdsFromVisibleFrameOfScreen: visibleFrameOfScreen];
    CGRect result = [[thirds objectAtIndex: 0] windowRect];
    NSInteger i = 0;
    
    for (i = 0; i < [thirds count]; i++) {
        CGRect currentWindowRect = [[thirds objectAtIndex: i] windowRect];
        
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
            
            result = [[thirds objectAtIndex: j] windowRect];
            
            break;
        }
    }
    
    return result;
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (WindowHistory)

- (void)moveWithHistory: (NSMutableArray *)history action: (SpectacleWindowAction)action {
    SpectacleHistoryItem *historyItem = [history lastObject];
    ZeroKitAccessibilityElement *accessibilityElement = [historyItem accessibilityElement];
    CGRect windowRect = [self rectOfWindowWithAccessibilityElement: accessibilityElement];
    NSScreen *screenOfDisplay = [SpectacleScreenDetection screenWithAction: action andRect: windowRect];
    CGRect visibleFrameOfScreen = CGRectNull;
    
    if (screenOfDisplay) {
        visibleFrameOfScreen = NSRectToCGRect([screenOfDisplay visibleFrame]);
    }
    
    if (!CGRectIsNull(windowRect)) {
        SpectacleHistoryItem *nextHistoryItem = [SpectacleHistoryItem historyItemFromAccessibilityElement: accessibilityElement
                                                                                               windowRect: windowRect];
        
        if (action == SpectacleWindowActionUndo) {
            [self addHistoryItemToRedoHistory: nextHistoryItem];
        } else if (action == SpectacleWindowActionRedo) {
            [self addHistoryItemToUndoHistory: nextHistoryItem];
        }
    }
    
    if (![self moveWithHistoryItem: historyItem visibleFrameOfScreen: visibleFrameOfScreen action: action]) {
        NSBeep();
        
        return;
    }
    
    [history removeLastObject];
}

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action {
    ZeroKitAccessibilityElement *frontMostWindowElement = [historyItem accessibilityElement];
    
    if (!historyItem || !frontMostWindowElement) {
        return NO;
    }
    
    [self moveWindowRect: [historyItem windowRect] frameOfScreen: CGRectNull visibleFrameOfScreen: visibleFrameOfScreen frontMostWindowElement: frontMostWindowElement action: action];
    
    return YES;
}

#pragma mark -

- (void)addHistoryItemToUndoHistory: (SpectacleHistoryItem *)historyItem {
    if (!CurrentUndoHistory) {
        [myUndoHistory setObject: [NSMutableArray array] forKey: CurrentWorkspaceKey];
    }
    
    if ([CurrentUndoHistory count] >= SpectacleWindowActionHistorySize) {
        [CurrentUndoHistory removeObjectAtIndex: 0];
    }
    
    [CurrentUndoHistory addObject: historyItem];
}

- (void)addHistoryItemToRedoHistory: (SpectacleHistoryItem *)historyItem {
    if (!CurrentRedoHistory) {
        [myRedoHistory setObject: [NSMutableArray array] forKey: CurrentWorkspaceKey];
    }
    
    if ([CurrentRedoHistory count] >= SpectacleWindowActionHistorySize) {
        [CurrentRedoHistory removeObjectAtIndex: 0];
    }
    
    [CurrentRedoHistory addObject: historyItem];
}

@end
