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

#define BlacklistedWindowRect(applicationName, windowRect) [NSString stringWithFormat: @"%@ - %@", applicationName, WindowRectToString(windowRect)]

#pragma mark -

@interface SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (void)internallyMoveFrontMostWindowWithAction: (SpectacleWindowAction)action;

#pragma mark -

- (ZeroKitAccessibilityElement *)frontMostWindowElement;

#pragma mark -

- (NSString *)frontMostApplicationName;

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

- (NSString *)currentWorkspaceKey;

#pragma mark -

- (NSMutableArray *)currentUndoHistory;

- (NSMutableArray *)currentRedoHistory;

#pragma mark -

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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *path = [[SpectacleUtilities applicationBundle] pathForResource: SpectacleBlacklistedApplicationsPropertyListFile
                                                                          ofType: ZeroKitPropertyListFileExtension];
        
        myUndoHistory = [NSMutableDictionary new];
        myRedoHistory = [NSMutableDictionary new];
        myBlacklistedWindowRects = [NSMutableSet setWithArray: [userDefaults arrayForKey: SpectacleBlacklistedWindowRectsPreference]];
        myBlacklistedApplications = [NSMutableSet setWithArray: [NSArray arrayWithContentsOfFile: path]];
    }
    
    return self;
}

#pragma mark -

+ (SpectacleWindowPositionManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [self new];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (void)moveFrontMostWindowWithAction: (SpectacleWindowAction)action {
    if (action < SpectacleWindowActionNone) {
        NSMutableArray *history = (action == SpectacleWindowActionUndo) ? [self currentUndoHistory] : [self currentRedoHistory];
        
        [self moveWithHistory: history action: action];
    } else {
        [self internallyMoveFrontMostWindowWithAction: action];
    }
}

#pragma mark -

- (void)undoLastWindowAction {
    [self moveFrontMostWindowWithAction: SpectacleWindowActionUndo];
}

- (void)redoLastWindowAction {
    [self moveFrontMostWindowWithAction: SpectacleWindowActionRedo];
}

#pragma mark -

- (SpectacleWindowAction)windowActionForHotKey: (ZeroKitHotKey *)hotKey {
    NSString *name = [hotKey hotKeyName];
    SpectacleWindowAction windowAction = SpectacleWindowActionNone;
    
    if ([name isEqualToString: SpectacleWindowActionMoveToCenter]) {
        windowAction = SpectacleWindowActionCenter;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToFullscreen]) {
        windowAction = SpectacleWindowActionFullscreen;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLeftHalf]) {
        windowAction = SpectacleWindowActionLeftHalf;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToRightHalf]) {
        windowAction = SpectacleWindowActionRightHalf;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToTopHalf]) {
        windowAction = SpectacleWindowActionTopHalf;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToBottomHalf]) {
        windowAction = SpectacleWindowActionBottomHalf;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToUpperLeft]) {
        windowAction = SpectacleWindowActionUpperLeft;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLowerLeft]) {
        windowAction = SpectacleWindowActionLowerLeft;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToUpperRight]) {
        windowAction = SpectacleWindowActionUpperRight;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToLowerRight]) {
        windowAction = SpectacleWindowActionLowerRight;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToNextDisplay]) {
        windowAction = SpectacleWindowActionNextDisplay;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToPreviousDisplay]) {
        windowAction = SpectacleWindowActionPreviousDisplay;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToNextThird]) {
        windowAction = SpectacleWindowActionNextThird;
    } else if ([name isEqualToString: SpectacleWindowActionMoveToPreviousThird]) {
        windowAction = SpectacleWindowActionPreviousThird;
    } else if ([name isEqualToString: SpectacleWindowActionUndoLastMove]) {
        windowAction = SpectacleWindowActionUndo;
    } else if ([name isEqualToString: SpectacleWindowActionRedoLastMove]) {
        windowAction = SpectacleWindowActionRedo;
    }
    
    return windowAction;
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (void)internallyMoveFrontMostWindowWithAction: (SpectacleWindowAction)action {
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
    
    if (CGRectIsNull(frontMostWindowRect) || CGRectIsNull(frameOfScreen) || CGRectIsNull(visibleFrameOfScreen) || CGRectEqualToRect(frontMostWindowRect, frameOfScreen)) {
        NSBeep();
        
        return;
    }
    
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement: frontMostWindowElement
                                                                 windowRect: frontMostWindowRect];
    
    [self addHistoryItemToUndoHistory: historyItem];
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    if (MovingToNextOrPreviousDisplay(action) && RectFitsInRect(frontMostWindowRect, visibleFrameOfScreen)) {
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

- (NSString *)frontMostApplicationName {
    ZeroKitAccessibilityElement *systemWideElement = [ZeroKitAccessibilityElement systemWideElement];
    ZeroKitAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute: kAXFocusedApplicationAttribute];
    
    return [applicationWithFocusElement stringValueOfAttribute: kAXTitleAttribute];
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
        
        CFRelease(windowPositionValue);
        CFRelease(windowSizeValue);
        
        result = CGRectMake(windowPosition.x, windowPosition.y, windowSize.width, windowSize.height);
    }
    
    return result;
}

#pragma mark -

- (void)moveWindowRect: (CGRect)windowRect frameOfScreen: (CGRect)frameOfScreen visibleFrameOfScreen: (CGRect)visibleFrameOfScreen frontMostWindowElement: (ZeroKitAccessibilityElement *)frontMostWindowElement action: (SpectacleWindowAction)action {
    NSString *frontMostApplicationName = [self frontMostApplicationName];
    NSString *blacklistedWindowRect = BlacklistedWindowRect(frontMostApplicationName, windowRect);
    
    if ([myBlacklistedWindowRects containsObject: blacklistedWindowRect] || [myBlacklistedApplications containsObject: frontMostApplicationName]) {
        NSBeep();
        
        return;
    }
    
    CGRect previousWindowRect = [self rectOfWindowWithAccessibilityElement: [self frontMostWindowElement]];
    
    [self moveWindowRect: windowRect frontMostWindowElement: frontMostWindowElement];

    CGRect movedWindowRect = [self rectOfWindowWithAccessibilityElement: [self frontMostWindowElement]];
    
    if (MovingToThirdOfDisplay(action) && !CGRectEqualToRect(movedWindowRect, windowRect)) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSBeep();
        
        [myBlacklistedWindowRects addObject: blacklistedWindowRect];
        
        [userDefaults setObject: [myBlacklistedWindowRects allObjects] forKey: SpectacleBlacklistedWindowRectsPreference];
        
        [self moveWindowRect: previousWindowRect frontMostWindowElement: frontMostWindowElement];
        
        return;
    }
    
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
    
    CFRelease(windowRectPositionRef);
    CFRelease(windowRectSizeRef);
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

- (CGRect)findThirdForFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    NSArray *thirds = [self thirdsFromVisibleFrameOfScreen: visibleFrameOfScreen];
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

#pragma mark -

@implementation SpectacleWindowPositionManager (WindowHistory)

- (NSString *)currentWorkspaceKey {
    return [NSString stringWithFormat: @"Workspace%ld", [SpectacleUtilities currentWorkspace]];
}

#pragma mark -

- (NSMutableArray *)currentUndoHistory {
    return myUndoHistory[[self currentWorkspaceKey]];
}

- (NSMutableArray *)currentRedoHistory {
    return myRedoHistory[[self currentWorkspaceKey]];
}

#pragma mark -

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
    if (![self currentUndoHistory]) {
        myUndoHistory[[self currentWorkspaceKey]] = [NSMutableArray new];
    }
    
    if ([[self currentUndoHistory] count] >= SpectacleWindowActionHistorySize) {
        [[self currentUndoHistory] removeObjectAtIndex: 0];
    }
    
    [[self currentUndoHistory] addObject: historyItem];
}

- (void)addHistoryItemToRedoHistory: (SpectacleHistoryItem *)historyItem {
    if (![self currentRedoHistory]) {
        myRedoHistory[[self currentWorkspaceKey]] = [NSMutableArray new];
    }
    
    if ([[self currentRedoHistory] count] >= SpectacleWindowActionHistorySize) {
        [[self currentRedoHistory] removeObjectAtIndex: 0];
    }
    
    [[self currentRedoHistory] addObject: historyItem];
}

@end
