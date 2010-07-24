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

#define FlipVerticalOriginOfRectInRect(a, b) b.size.height - (a.origin.y + a.size.height)

#pragma mark -

typedef enum {
    SpectacleScreenLocationNone = -1,
    SpectacleScreenLocationLeftHalf,
    SpectacleScreenLocationUpperLeft,
    SpectacleScreenLocationLowerLeft,
    SpectacleScreenLocationRightHalf,
    SpectacleScreenLocationUpperRight,
    SpectacleScreenLocationLowerRight,
    SpectacleScreenLocationTopHalf,
    SpectacleScreenLocationBottomHalf
} SpectacleScreenLocation;

#pragma mark -

@interface SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (NSScreen *)screenOfDisplayContainingRect: (CGRect)rect;

#pragma mark -

- (CGRect)rectOfFrontMostWindow;

#pragma mark -

- (CGRect)invokeAction: (SpectacleWindowAction)action withFrontMostWindowRect: (CGRect)frontMostWindowRect andVisibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay;

#pragma mark -

- (CGRect)centerFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay;

- (CGRect)maximizeFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay;

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay toLocation: (SpectacleScreenLocation)location;

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

- (void)adjustFrontMostWindowWithAction: (SpectacleWindowAction)action {
    CGRect frontMostWindowRect = [self rectOfFrontMostWindow];
    NSScreen *screenOfDisplay = [self screenOfDisplayContainingRect: frontMostWindowRect];
    CGRect frameOfDisplay = [screenOfDisplay frame];
    CGRect visibleFrameOfDisplay = [screenOfDisplay visibleFrame];
    
    if (!CGRectIsNull(frontMostWindowRect)) {
        frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfDisplay);
        
        frontMostWindowRect = [self invokeAction: action withFrontMostWindowRect: frontMostWindowRect andVisibleFrameOfDisplay: visibleFrameOfDisplay];
        
        if (!CGRectIsNull(frontMostWindowRect)) {
            AXValueRef frontMostWindowRectPositionRef;
            AXValueRef frontMostWindowRectWindowSizeRef;
            
            frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfDisplay);
            
            frontMostWindowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&frontMostWindowRect.origin);
            frontMostWindowRectWindowSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&frontMostWindowRect.size);
            
            [myFrontMostWindowElement setValue: frontMostWindowRectPositionRef forAttribute: kAXPositionAttribute];
            [myFrontMostWindowElement setValue: frontMostWindowRectWindowSizeRef forAttribute: kAXSizeAttribute];
        }
    } else {
        NSLog(@"Spectacle was unable to determine the size and location of the front most window.");
    }
}

#pragma mark -

- (void)dealloc {
    [myFrontMostWindowElement release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SpectacleWindowPositionManager (SpectacleWindowPositionManagerPrivate)

- (NSScreen *)screenOfDisplayContainingRect: (CGRect)rect {
    return [NSScreen mainScreen];
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

- (CGRect)invokeAction: (SpectacleWindowAction)action withFrontMostWindowRect: (CGRect)frontMostWindowRect andVisibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay {
    SpectacleScreenLocation location = SpectacleScreenLocationNone;
    CGRect result = CGRectNull;
    
    if (CGRectIsNull(visibleFrameOfDisplay)) {
        NSLog(@"The visible frame of the display containing the front most window is null.");
        
        return result;
    }
    
    switch (action) {
        case SpectacleWindowActionCenter:
            result = [self centerFrontMostWindowRect: frontMostWindowRect visibleFrameOfDisplay: visibleFrameOfDisplay];
            
            break;
        case SpectacleWindowActionFullScreen:
            result = [self maximizeFrontMostWindowRect: frontMostWindowRect visibleFrameOfDisplay: visibleFrameOfDisplay];
            
            break;
        case SpectacleWindowActionLeftHalf:
            location = SpectacleScreenLocationLeftHalf;
            
            break;
        case SpectacleWindowActionRightHalf:
            location = SpectacleScreenLocationRightHalf;
            
            break;
        case SpectacleWindowActionTopHalf:
            location = SpectacleScreenLocationTopHalf;
            
            break;
        case SpectacleWindowActionBottomHalf:
            location = SpectacleScreenLocationBottomHalf;
            
            break;
        case SpectacleWindowActionUpperLeft:
            location = SpectacleScreenLocationUpperLeft;
            
            break;
        case SpectacleWindowActionLowerLeft:
            location = SpectacleScreenLocationLowerLeft;
            
            break;
        case SpectacleWindowActionUpperRight:
            location = SpectacleScreenLocationUpperRight;
            
            break;
        case SpectacleWindowActionLowerRight:
            location = SpectacleScreenLocationLowerRight;
            
            break;
        default:
            NSLog(@"The desired window action does not exist.");
    }
    
    if (location != SpectacleScreenLocationNone) {
        result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrameOfDisplay: visibleFrameOfDisplay toLocation: location];
    }
    
    return result;
}

#pragma mark -

- (CGRect)centerFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay {
    frontMostWindowRect.origin.x = (visibleFrameOfDisplay.size.width / 2.0f) - (frontMostWindowRect.size.width / 2.0f);
    frontMostWindowRect.origin.y = (visibleFrameOfDisplay.size.height / 2.0f) - (frontMostWindowRect.size.height / 2.0f) + visibleFrameOfDisplay.origin.y;
    
    return frontMostWindowRect;
}

- (CGRect)maximizeFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay {
    return visibleFrameOfDisplay;
}

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrameOfDisplay: (CGRect)visibleFrameOfDisplay toLocation: (SpectacleScreenLocation)location {
    if ((location >= SpectacleScreenLocationRightHalf) && (location < SpectacleScreenLocationTopHalf)) {
        frontMostWindowRect.origin.x = visibleFrameOfDisplay.origin.x + floor(visibleFrameOfDisplay.size.width / 2.0f);
    } else {
        frontMostWindowRect.origin.x = visibleFrameOfDisplay.origin.x;
    }
    
    if ((location == SpectacleScreenLocationTopHalf) || (location == SpectacleScreenLocationUpperLeft) || (location == SpectacleScreenLocationUpperRight)) {
        frontMostWindowRect.origin.y = visibleFrameOfDisplay.origin.y + ceil(visibleFrameOfDisplay.size.height / 2.0f);
    } else {
        frontMostWindowRect.origin.y = visibleFrameOfDisplay.origin.y;
    }
    
    if ((location == SpectacleScreenLocationLeftHalf) || (location == SpectacleScreenLocationRightHalf)) {
        frontMostWindowRect.size.width = floor(visibleFrameOfDisplay.size.width / 2.0f);
        frontMostWindowRect.size.height = visibleFrameOfDisplay.size.height;
    } else if ((location == SpectacleScreenLocationTopHalf) || (location == SpectacleScreenLocationBottomHalf)) {
        frontMostWindowRect.size.width = visibleFrameOfDisplay.size.width;
        frontMostWindowRect.size.height = floor(visibleFrameOfDisplay.size.height / 2.0f);
    } else {
        frontMostWindowRect.size.width = floor(visibleFrameOfDisplay.size.width / 2.0f);
        frontMostWindowRect.size.height = floor(visibleFrameOfDisplay.size.height / 2.0f);
    }
    
    if ((location == SpectacleScreenLocationLeftHalf) || (location == SpectacleScreenLocationUpperLeft) || (location == SpectacleScreenLocationLowerLeft)) {
        frontMostWindowRect.size.width = frontMostWindowRect.size.width - 1.0f;
    }
    
    return frontMostWindowRect;
}

@end
