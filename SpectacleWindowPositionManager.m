// 
// Copyright (c) 2011 Eric Czarny <eczarny@gmail.com>
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

#import "SpectacleWindowPositionManager.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleUtilities.h"

#define FlipVerticalOriginOfRectInRect(a, b) b.size.height - (a.origin.y + a.size.height) + ([[NSScreen mainScreen] frame].size.height - b.size.height)

#pragma mark -

#define AreaOfRect(a) (CGFloat)(a.size.width * a.size.height)

#pragma mark -

#define RectFitsInRect(a, b) (a.size.width < b.size.width) && (a.size.height < b.size.height)

#pragma mark -

#define MovingToCenterRegionOfDisplay(action) action == SpectacleWindowActionCenter
#define MovingToTopRegionOfDisplay(action) (action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionUpperRight)
#define MovingToUpperOrLowerLeftOfDisplay(action) (action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionLowerLeft)
#define MovingToUpperOrLowerRightDisplay(action) (action == SpectacleWindowActionUpperRight) || (action == SpectacleWindowActionLowerRight)

#pragma mark -

#define MovingToDisplay(action) (action >= SpectacleWindowActionLeftDisplay) && (action <= SpectacleWindowActionBottomDisplay)

#pragma mark -

#define RectIsLeftOfRect(a, b) (b.origin.x - a.size.width) == a.origin.x
#define RectIsRightOfRect(a, b) (b.origin.x + b.size.width) == a.origin.x
#define RectIsAboveRect(a, b) (b.origin.y + b.size.height) == a.origin.y
#define RectIsBelowRect(a, b) (b.origin.y - a.size.height) == a.origin.y

#pragma mark -

#define CurrentWorkspace [SpectacleUtilities currentWorkspace]
#define CurrentWorkspaceKey [NSString stringWithFormat: @"Workspace%d", CurrentWorkspace]

#pragma mark -

#define CurrentUndoHistory [myUndoHistory objectForKey: CurrentWorkspaceKey]
#define CurrentRedoHistory [myRedoHistory objectForKey: CurrentWorkspaceKey]

#pragma mark -

@interface SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (NSScreen *)screenWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect;

- (NSScreen *)screenAdjacentToFrameOfScreen: (CGRect)frameOfScreen inDirectionOfAction: (SpectacleWindowAction)action;

- (NSScreen *)screenContainingRect: (CGRect)rect;

#pragma mark -

- (CGFloat)percentageOfRect: (CGRect)rect withinFrameOfScreen: (CGRect)frameOfScreen;

#pragma mark -

- (CGRect)rectOfFrontMostWindow;

- (CGRect)rectOfWindowWithAccessibilityElement: (ZeroKitAccessibilityElement *)accessibilityElement;

#pragma mark -

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen withAction: (SpectacleWindowAction)action;

#pragma mark -

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem;

#pragma mark -

- (void)addHistoryItemToUndoHistory: (SpectacleHistoryItem *)historyItem;

- (void)addHistoryItemToRedoHistory: (SpectacleHistoryItem *)historyItem;

#pragma mark -

- (CGRect)resizeCenteredWindowRect: (CGRect)frontMostWindowRect visibleFrameOfScreen: (CGRect)visibleFrameOfScreen percentage: (CGFloat)percentage;

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
    NSScreen *screenOfDisplay = [self screenWithAction: action andRect: frontMostWindowRect];
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
    
    AXValueRef frontMostWindowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&frontMostWindowRect.origin);
    AXValueRef frontMostWindowRectWindowSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&frontMostWindowRect.size);
    
    [myFrontMostWindowElement setValue: frontMostWindowRectPositionRef forAttribute: kAXPositionAttribute];
    [myFrontMostWindowElement setValue: frontMostWindowRectWindowSizeRef forAttribute: kAXSizeAttribute];
}

#pragma mark -

- (void)undoLastWindowAction {
    SpectacleHistoryItem *historyItem = [CurrentUndoHistory lastObject];
    ZeroKitAccessibilityElement *accessibilityElement = [historyItem accessibilityElement];
    CGRect windowRect = [self rectOfWindowWithAccessibilityElement: accessibilityElement];
    
    if (!CGRectIsNull(windowRect)) {
        [self addHistoryItemToRedoHistory: [SpectacleHistoryItem historyItemFromAccessibilityElement: accessibilityElement
                                                                                          windowRect: windowRect]];
    }
    
    if (![self moveWithHistoryItem: historyItem]) {
        NSBeep();
        
        return;
    }
    
    [CurrentUndoHistory removeLastObject];
}

- (void)redoLastWindowAction {
    SpectacleHistoryItem *historyItem = [CurrentRedoHistory lastObject];
    ZeroKitAccessibilityElement *accessibilityElement = [historyItem accessibilityElement];
    CGRect windowRect = [self rectOfWindowWithAccessibilityElement: accessibilityElement];
    
    if (!CGRectIsNull(windowRect)) {
        [self addHistoryItemToUndoHistory: [SpectacleHistoryItem historyItemFromAccessibilityElement: accessibilityElement
                                                                                          windowRect: windowRect]];
    }
    
    if (![self moveWithHistoryItem: historyItem]) {
        NSBeep();
        
        return;
    }
    
    [CurrentRedoHistory removeLastObject];
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

- (NSScreen *)screenWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect {
    NSScreen *result = [self screenContainingRect: rect];
    
    if (MovingToDisplay(action)) {
        result = [self screenAdjacentToFrameOfScreen: NSRectToCGRect([result frame]) inDirectionOfAction: action];
    }
    
    return result;
}

- (NSScreen *)screenAdjacentToFrameOfScreen: (CGRect)frameOfScreen inDirectionOfAction: (SpectacleWindowAction)action {
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

- (NSScreen *)screenContainingRect: (CGRect)rect {
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

- (CGFloat)percentageOfRect: (CGRect)rect withinFrameOfScreen: (CGRect)frameOfScreen {
    CGRect intersectionOfRectAndFrameOfScreen = CGRectIntersection(rect, frameOfScreen);
    CGFloat result = 0.0f;
    
    if (!CGRectIsNull(intersectionOfRectAndFrameOfScreen)) {
        result = AreaOfRect(intersectionOfRectAndFrameOfScreen) / AreaOfRect(rect);
    }
    
    return result;
}

#pragma mark -

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

#pragma mark -

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem {
    ZeroKitAccessibilityElement *accessibilityElement = [historyItem accessibilityElement];
    CGRect windowRect = CGRectNull;
    
    if (!historyItem || !accessibilityElement) {
        return NO;
    }
    
    windowRect = [historyItem windowRect];
    
    AXValueRef windowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&windowRect.origin);
    AXValueRef windowRectWindowSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&windowRect.size);
    
    [accessibilityElement setValue: windowRectPositionRef forAttribute: kAXPositionAttribute];
    [accessibilityElement setValue: windowRectWindowSizeRef forAttribute: kAXSizeAttribute];
    
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
