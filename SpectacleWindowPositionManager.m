// 
// Copyright (c) 2010 Eric Czarny <eczarny@gmail.com>
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
#import "SpectacleAccessibilityElement.h"

#define FlipVerticalOriginOfRectInRect(a, b) b.size.height - (a.origin.y + a.size.height) + abs([[NSScreen mainScreen] frame].size.height - b.size.height)

#pragma mark -

#define AreaOfRect(a) (CGFloat)(a.size.width * a.size.height)

#pragma mark -

@interface SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (NSScreen *)screenOfDisplayWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect;

- (NSScreen *)screenOfDisplayAdjacentToRect: (CGRect)rect withAction: (SpectacleWindowAction)action;

- (NSScreen *)screenOfDisplayContainingRect: (CGRect)rect;

#pragma mark -

- (CGFloat)percentageOfRect: (CGRect)rect withinFrameOfScreen: (CGRect)frameOfScreen;

#pragma mark -

- (CGRect)rectOfFrontMostWindow;

#pragma mark -

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay withAction: (SpectacleWindowAction)action;

@end

#pragma mark -

@implementation SpectacleWindowPositionManager

static SpectacleWindowPositionManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myFrontMostWindowElement = nil;
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
    NSScreen *screenOfDisplay = [self screenOfDisplayWithAction: action andRect: frontMostWindowRect];
    CGRect frameOfDisplay = CGRectNull;
    CGRect visibleFrameOfDisplay = CGRectNull;
    
    if (screenOfDisplay) {
        frameOfDisplay = NSRectToCGRect([screenOfDisplay frame]);
        visibleFrameOfDisplay = NSRectToCGRect([screenOfDisplay visibleFrame]);
    }
    
    if (CGRectIsNull(frontMostWindowRect) || CGRectIsNull(frameOfDisplay) || CGRectIsNull(visibleFrameOfDisplay)) {
        NSBeep();
        
        return;
    }
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfDisplay);
    
    frontMostWindowRect = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrameOfDisplay: visibleFrameOfDisplay withAction: action];
    
    if (CGRectIsNull(frontMostWindowRect)) {
        NSBeep();
        
        return;
    }
    
    AXValueRef frontMostWindowRectPositionRef;
    AXValueRef frontMostWindowRectWindowSizeRef;
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfDisplay);
    
    frontMostWindowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&frontMostWindowRect.origin);
    frontMostWindowRectWindowSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&frontMostWindowRect.size);
    
    [myFrontMostWindowElement setValue: frontMostWindowRectPositionRef forAttribute: kAXPositionAttribute];
    [myFrontMostWindowElement setValue: frontMostWindowRectWindowSizeRef forAttribute: kAXSizeAttribute];
}

#pragma mark -

- (void)dealloc {
    [myFrontMostWindowElement release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (NSScreen *)screenOfDisplayWithAction: (SpectacleWindowAction)action andRect: (CGRect)rect {
    NSScreen *result = [self screenOfDisplayContainingRect: rect];
    
    if ((action >= SpectacleWindowActionLeftDisplay) && (action <= SpectacleWindowActionBottomDisplay)) {
        result = [self screenOfDisplayAdjacentToRect: NSRectToCGRect([result frame]) withAction: action];
    }
    
    return result;
}

- (NSScreen *)screenOfDisplayAdjacentToRect: (CGRect)rect withAction: (SpectacleWindowAction)action {
    NSScreen *result = nil;
    
    for (NSScreen *screen in [NSScreen screens]) {
        CGRect frameOfScreen = NSRectToCGRect([screen frame]);
        
        if (action == SpectacleWindowActionLeftDisplay) {
            if (frameOfScreen.origin.x < rect.origin.x) {
                result = screen;
                
                break;
            } else if (frameOfScreen.origin.x > rect.origin.x) {
                result = screen;
                
                continue;
            }
        } else if (action == SpectacleWindowActionRightDisplay) {
            if (frameOfScreen.origin.x < rect.origin.x) {
                result = screen;
                
                continue;
            } else if (frameOfScreen.origin.x > rect.origin.x) {
                result = screen;
                
                break;
            }
        } else if (action == SpectacleWindowActionTopDisplay) {
            if (frameOfScreen.origin.y > rect.origin.y) {
                result = screen;
                
                break;
            } else if (frameOfScreen.origin.y < rect.origin.y) {
                result = screen;
                
                continue;
            }
        } else if (action == SpectacleWindowActionBottomDisplay) {
            if (frameOfScreen.origin.y > rect.origin.y) {
                result = screen;
                
                continue;
            } else if (frameOfScreen.origin.y < rect.origin.y) {
                result = screen;
                
                break;
            }
        }
    }
    
    return result;
}

- (NSScreen *)screenOfDisplayContainingRect: (CGRect)rect {
    CGFloat largestPercentageOfRectWithinFrameOfScreen = 0.0f;
    NSScreen *result = [NSScreen mainScreen];
    
    for (NSScreen *screen in [NSScreen screens]) {
        CGRect frameOfScreen = NSRectToCGRect([screen frame]);
        CGRect flippedRect = rect;
        CGFloat percentageOfRectWithinFrameOfScreen = 0.0f;
        
        flippedRect.origin.y = FlipVerticalOriginOfRectInRect(flippedRect, frameOfScreen);
        
        if (CGRectContainsRect(frameOfScreen, flippedRect)) {
            result = screen;
            
            break;
        }
        
        percentageOfRectWithinFrameOfScreen = [self percentageOfRect: flippedRect withinFrameOfScreen: frameOfScreen];
        
        if (percentageOfRectWithinFrameOfScreen > largestPercentageOfRectWithinFrameOfScreen) {
            largestPercentageOfRectWithinFrameOfScreen = percentageOfRectWithinFrameOfScreen;
            
            result = screen;
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
    SpectacleAccessibilityElement *systemWideElement = [SpectacleAccessibilityElement systemWideElement];
    SpectacleAccessibilityElement *applicationWithFocusElement = [systemWideElement elementWithAttribute: kAXFocusedApplicationAttribute];
    CGRect result = CGRectNull;
    
    if (applicationWithFocusElement) {
        myFrontMostWindowElement = [applicationWithFocusElement elementWithAttribute: kAXFocusedWindowAttribute];
        
        if (myFrontMostWindowElement) {
            CFTypeRef windowPositionValue = [myFrontMostWindowElement valueOfAttribute: kAXPositionAttribute type: kAXValueCGPointType];
            CFTypeRef windowSizeValue = [myFrontMostWindowElement valueOfAttribute: kAXSizeAttribute type: kAXValueCGSizeType];
            CGPoint windowPosition;
            CGSize windowSize;
            
            AXValueGetValue(windowPositionValue, kAXValueCGPointType, (void *)&windowPosition);
            AXValueGetValue(windowSizeValue, kAXValueCGSizeType, (void *)&windowSize);
            
            result = CGRectMake(windowPosition.x, windowPosition.y, windowSize.width, windowSize.height);
        } else {
            NSLog(@"Failed to determine position of the window that currently has focus.");
        }
    } else {
        NSLog(@"Failed to find the application that currently has focus.");
    }
    
    return result;
}

#pragma mark -

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay withAction: (SpectacleWindowAction)action {
    if ((action >= SpectacleWindowActionRightHalf) && (action <= SpectacleWindowActionLowerRight)) {
        frontMostWindowRect.origin.x = visibleFrameOfDisplay.origin.x + floor(visibleFrameOfDisplay.size.width / 2.0f);
    } else if (action == SpectacleWindowActionCenter) {
        frontMostWindowRect.origin.x = (visibleFrameOfDisplay.size.width / 2.0f) - (frontMostWindowRect.size.width / 2.0f) + visibleFrameOfDisplay.origin.x;
    } else {
        frontMostWindowRect.origin.x = visibleFrameOfDisplay.origin.x;
    }
    
    if ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionUpperRight)) {
        frontMostWindowRect.origin.y = visibleFrameOfDisplay.origin.y + ceil(visibleFrameOfDisplay.size.height / 2.0f);
    } else if (action == SpectacleWindowActionCenter) {
        frontMostWindowRect.origin.y = (visibleFrameOfDisplay.size.height / 2.0f) - (frontMostWindowRect.size.height / 2.0f) + visibleFrameOfDisplay.origin.y;
    } else {
        frontMostWindowRect.origin.y = visibleFrameOfDisplay.origin.y;
    }
    
    if ((action == SpectacleWindowActionLeftHalf) || (action == SpectacleWindowActionRightHalf)) {
        frontMostWindowRect.size.width = floor(visibleFrameOfDisplay.size.width / 2.0f);
        frontMostWindowRect.size.height = visibleFrameOfDisplay.size.height;
    } else if ((action == SpectacleWindowActionTopHalf) || (action == SpectacleWindowActionBottomHalf)) {
        frontMostWindowRect.size.width = visibleFrameOfDisplay.size.width;
        frontMostWindowRect.size.height = floor(visibleFrameOfDisplay.size.height / 2.0f);
    } else if ((action != SpectacleWindowActionCenter) && (action != SpectacleWindowActionFullScreen)) {
        frontMostWindowRect.size.width = floor(visibleFrameOfDisplay.size.width / 2.0f);
        frontMostWindowRect.size.height = floor(visibleFrameOfDisplay.size.height / 2.0f);
    } else if (action != SpectacleWindowActionCenter) {
        frontMostWindowRect.size.width = visibleFrameOfDisplay.size.width;
        frontMostWindowRect.size.height = visibleFrameOfDisplay.size.height;
    }
    
    if ((action == SpectacleWindowActionLeftHalf) || (action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionLowerLeft)) {
        frontMostWindowRect.size.width = frontMostWindowRect.size.width - 1.0f;
    }
    
    return frontMostWindowRect;
}

@end
