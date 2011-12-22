#import "SpectacleWindowPositionManager.h"
#import "SpectacleScreenDetection.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleUtilities.h"

#define MovingToCenterRegionOfDisplay(action) (action == SpectacleWindowActionCenter)
#define MovingToTopRegionOfDisplay(action) ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionUpperRight))
#define MovingToUpperOrLowerLeftOfDisplay(action) ((action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionLowerLeft))
#define MovingToUpperOrLowerRightDisplay(action) ((action == SpectacleWindowActionUpperRight) || (action == SpectacleWindowActionLowerRight))

#pragma mark -

#define CurrentWorkspace [SpectacleUtilities currentWorkspace]
#define CurrentWorkspaceKey [NSString stringWithFormat: @"Workspace%d", CurrentWorkspace]

#pragma mark -

#define CurrentUndoHistory [myUndoHistory objectForKey: CurrentWorkspaceKey]
#define CurrentRedoHistory [myRedoHistory objectForKey: CurrentWorkspaceKey]

#pragma mark -

@interface SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (CGRect)rectOfFrontMostWindow;

- (CGRect)rectOfWindowWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

- (void)moveWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

#pragma mark -

- (CGRect)resizeCenteredWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage;

@end

#pragma mark -

@interface SpectacleWindowPositionManager (WindowHistory)

- (void)moveWithHistory: (NSMutableArray *)history withAction: (SpectacleWindowAction)action;

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

#pragma mark -

- (void)addHistoryItemToUndoHistory: (SpectacleHistoryItem *)historyItem;

- (void)addHistoryItemToRedoHistory: (SpectacleHistoryItem *)historyItem;

@end

#pragma mark -

@implementation SpectacleWindowPositionManager

static SpectacleWindowPositionManager *sharedInstance = nil;

- (id)init {
    if ((self = [super init])) {
        myFrontMostWindowElement = nil;
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
    CGRect frontMostWindowRect = [self rectOfFrontMostWindow];
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
    
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement: myFrontMostWindowElement
                                                                 windowRect: frontMostWindowRect];
    
    [self addHistoryItemToUndoHistory: historyItem];
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    if (MovingToDisplay(action) && RectFitsInRect(frontMostWindowRect, visibleFrameOfScreen)) {
        action = SpectacleWindowActionCenter;
    }
    
    previousFrontMostWindowRect = frontMostWindowRect;
    
    frontMostWindowRect = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
    
    if ((action == SpectacleWindowActionCenter) && CGRectEqualToRect(frontMostWindowRect, previousFrontMostWindowRect)) {
        frontMostWindowRect = [self resizeCenteredWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen percentage: 0.05];
    }
    
    if (CGRectIsNull(frontMostWindowRect) || CGRectEqualToRect(previousFrontMostWindowRect, frontMostWindowRect)) {
        NSBeep();
        
        return;
    }
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    [self moveWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
}

#pragma mark -

- (void)undoLastWindowAction {
    [self moveWithHistory: CurrentUndoHistory withAction: SpectacleWindowActionUndo];
}

- (void)redoLastWindowAction {
    [self moveWithHistory: CurrentRedoHistory withAction: SpectacleWindowActionRedo];
}

#pragma mark -

- (void)dealloc {
    [myFrontMostWindowElement release];
    [myUndoHistory release];
    [myRedoHistory release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (CGRect)rectOfFrontMostWindow {
    ZeroKitAccessibilityElement *systemWideElement = [ZeroKitAccessibilityElement systemWideElement];
    ZeroKitAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute: kAXFocusedApplicationAttribute];
    CGRect result = CGRectNull;
    
    if (applicationWithFocusElement) {
        myFrontMostWindowElement = [applicationWithFocusElement elementWithAttribute: kAXFocusedWindowAttribute];
        
        if (myFrontMostWindowElement) {
            result = [self rectOfWindowWithAccessibilityElement: myFrontMostWindowElement];
        } else {
            NSLog(@"Invalid accessibility element provided, unable to determine the size and position of the window.");
        }
    } else {
        NSLog(@"Failed to find the application that currently has focus.");
    }
    
    return result;
}

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

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    if ((action >= SpectacleWindowActionRightHalf) && (action <= SpectacleWindowActionLowerRight)) {
        frontMostWindowRect.origin.x = visibleFrameOfScreen.origin.x + floor(visibleFrameOfScreen.size.width / 2.0f);
    } else if (MovingToCenterRegionOfDisplay(action)) {
        frontMostWindowRect.origin.x = floor(visibleFrameOfScreen.size.width / 2.0f) - floor(frontMostWindowRect.size.width / 2.0f) + visibleFrameOfScreen.origin.x;
    } else {
        frontMostWindowRect.origin.x = visibleFrameOfScreen.origin.x;
    }
    
    if (MovingToTopRegionOfDisplay(action)) {
        frontMostWindowRect.origin.y = visibleFrameOfScreen.origin.y + floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (MovingToCenterRegionOfDisplay(action)) {
        frontMostWindowRect.origin.y = floor(visibleFrameOfScreen.size.height / 2.0f) - floor(frontMostWindowRect.size.height / 2.0f) + visibleFrameOfScreen.origin.y;
    } else {
        frontMostWindowRect.origin.y = visibleFrameOfScreen.origin.y;
    }
    
    if ((action == SpectacleWindowActionLeftHalf) || (action == SpectacleWindowActionRightHalf)) {
        frontMostWindowRect.size.width = floor(visibleFrameOfScreen.size.width / 2.0f);
        frontMostWindowRect.size.height = visibleFrameOfScreen.size.height;
    } else if ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionBottomHalf)) {
        frontMostWindowRect.size.width = visibleFrameOfScreen.size.width;
        frontMostWindowRect.size.height = floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (MovingToUpperOrLowerLeftOfDisplay(action) || MovingToUpperOrLowerRightDisplay(action)) {
        frontMostWindowRect.size.width = floor(visibleFrameOfScreen.size.width / 2.0f);
        frontMostWindowRect.size.height = floor(visibleFrameOfScreen.size.height / 2.0f);
    } else if (!MovingToCenterRegionOfDisplay(action)) {
        frontMostWindowRect.size.width = visibleFrameOfScreen.size.width;
        frontMostWindowRect.size.height = visibleFrameOfScreen.size.height;
    }
    
    if (MovingToTopRegionOfDisplay(action)) {
        if (((visibleFrameOfScreen.size.height / 2.0f) - frontMostWindowRect.size.height) > 0.0f) {
            frontMostWindowRect.origin.y = frontMostWindowRect.origin.y + 1.0f;
        } else {
            frontMostWindowRect.origin.y = frontMostWindowRect.origin.y + 1.0f;
            frontMostWindowRect.size.height = frontMostWindowRect.size.height - 1.0f;
        }
    }
    
    if ((action >= SpectacleWindowActionLeftHalf) && (action <= SpectacleWindowActionLowerLeft)) {
        frontMostWindowRect.size.width = frontMostWindowRect.size.width - 1.0f;
    }
    
    return frontMostWindowRect;
}

- (void)moveWindowRect: (CGRect)windowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    AXValueRef windowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&windowRect.origin);
    AXValueRef windowRectSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&windowRect.size);
    
    [myFrontMostWindowElement setValue: windowRectSizeRef forAttribute: kAXSizeAttribute];
    [myFrontMostWindowElement setValue: windowRectPositionRef forAttribute: kAXPositionAttribute];
    [myFrontMostWindowElement setValue: windowRectSizeRef forAttribute: kAXSizeAttribute];
}

#pragma mark -

- (CGRect)resizeCenteredWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage {
    CGRect previousFrontMostWindowRect = frontMostWindowRect;
    SpectacleWindowAction action = SpectacleWindowActionCenter;
    
    frontMostWindowRect.size.width = floor(frontMostWindowRect.size.width + (frontMostWindowRect.size.width * percentage));
    frontMostWindowRect.size.height = floor(frontMostWindowRect.size.height + (frontMostWindowRect.size.height * percentage));
    
    if (frontMostWindowRect.size.width >= visibleFrameOfScreen.size.width) {
        frontMostWindowRect.size.width = previousFrontMostWindowRect.size.width;
    }
    
    if (frontMostWindowRect.size.width == previousFrontMostWindowRect.size.width) {
        frontMostWindowRect.size.width = visibleFrameOfScreen.size.width;
    }
    
    if (frontMostWindowRect.size.height >= visibleFrameOfScreen.size.height) {
        frontMostWindowRect.size.height = previousFrontMostWindowRect.size.height;
    }
    
    if (frontMostWindowRect.size.height == previousFrontMostWindowRect.size.height) {
        frontMostWindowRect.size.height = visibleFrameOfScreen.size.height;
    }
    
    if (CGRectEqualToRect(frontMostWindowRect, previousFrontMostWindowRect)) {
        action = SpectacleWindowActionFullscreen;
    }
    
    return [self moveFrontMostWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (WindowHistory)

- (void)moveWithHistory: (NSMutableArray *)history withAction: (SpectacleWindowAction)action {
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
    
    if (![self moveWithHistoryItem: historyItem visibleFrameOfScreen: visibleFrameOfScreen withAction: action]) {
        NSBeep();
        
        return;
    }
    
    [history removeLastObject];
}

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action {
    ZeroKitAccessibilityElement *accessibilityElement = [historyItem accessibilityElement];
    
    if (!historyItem || !accessibilityElement) {
        return NO;
    }
    
    [self moveWindowRect: [historyItem windowRect] visibleFrameOfScreen: visibleFrameOfScreen withAction: action];
    
    return YES;
}

#pragma mark -

- (void)addHistoryItemToUndoHistory: (SpectacleHistoryItem *)historyItem {
    if (!CurrentUndoHistory) {
        [myUndoHistory setObject: [NSMutableArray array] forKey: CurrentWorkspaceKey];
    }
    
    if ([CurrentUndoHistory count] >= 5) {
        [CurrentUndoHistory removeObjectAtIndex: 0];
    }
    
    [CurrentUndoHistory addObject: historyItem];
}

- (void)addHistoryItemToRedoHistory: (SpectacleHistoryItem *)historyItem {
    if (!CurrentRedoHistory) {
        [myRedoHistory setObject: [NSMutableArray array] forKey: CurrentWorkspaceKey];
    }
    
    if ([CurrentRedoHistory count] >= 5) {
        [CurrentRedoHistory removeObjectAtIndex: 0];
    }
    
    [CurrentRedoHistory addObject: historyItem];
}

@end
