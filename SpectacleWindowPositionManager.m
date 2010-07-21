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

- (CGRect)visibleFrameOfScreenContainingRect: (CGRect)rect;

#pragma mark -

- (CGRect)rectOfFrontMostWindow;

#pragma mark -

- (CGRect)invokeAction: (SpectacleWindowAction)action withFrontMostWindowRect: (CGRect)frontMostWindowRect;

#pragma mark -

- (CGRect)centerFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrame: (CGRect)visibleFrame;

- (CGRect)maximizeFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrame: (CGRect)visibleFrame;

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrame: (CGRect)visibleFrame toLocation: (SpectacleScreenLocation)location;

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
    
    if (!CGRectIsNull(frontMostWindowRect)) {
        CGRect adjustedRect = [self invokeAction: action withFrontMostWindowRect: frontMostWindowRect];
        
        if (!CGRectIsNull(adjustedRect)) {
            AXValueRef adjustedPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&adjustedRect.origin);
            AXValueRef adjustedSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&adjustedRect.size);
            
            [myFrontMostWindowElement setValue: adjustedPositionRef forAttribute: kAXPositionAttribute];
            [myFrontMostWindowElement setValue: adjustedSizeRef forAttribute: kAXSizeAttribute];
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

- (CGRect)visibleFrameOfScreenContainingRect: (CGRect)rect {
    return NSRectToCGRect([[NSScreen mainScreen] visibleFrame]);
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

- (CGRect)invokeAction: (SpectacleWindowAction)action withFrontMostWindowRect: (CGRect)frontMostWindowRect {
    CGRect visibleFrame = [self visibleFrameOfScreenContainingRect: frontMostWindowRect];
    CGRect result;
    
    switch (action) {
        case SpectacleWindowActionCenter:
            result = [self centerFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame];
            
            break;
        case SpectacleWindowActionFullScreen:
            result = [self maximizeFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame];
            
            break;
        case SpectacleWindowActionLeftHalf:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationLeftHalf];
            
            break;
        case SpectacleWindowActionRightHalf:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationRightHalf];
            
            break;
        case SpectacleWindowActionTopHalf:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationTopHalf];
            
            break;
        case SpectacleWindowActionBottomHalf:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationBottomHalf];
            
            break;
        case SpectacleWindowActionUpperLeft:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationUpperLeft];
            
            break;
        case SpectacleWindowActionLowerLeft:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationLowerLeft];
            
            break;
        case SpectacleWindowActionUpperRight:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationUpperRight];
            
            break;
        case SpectacleWindowActionLowerRight:
            result = [self moveFrontMostWindowRect: frontMostWindowRect visibleFrame: visibleFrame toLocation: SpectacleScreenLocationLowerRight];
            
            break;
        default:
            NSLog(@"The desired window action does not exist.");
            
            return CGRectNull;
    }
    
    return result;
}

#pragma mark -

- (CGRect)centerFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrame: (CGRect)visibleFrame {
    frontMostWindowRect.origin.x = visibleFrame.origin.x + (visibleFrame.size.width / 2.0f) - (frontMostWindowRect.size.width / 2.0f);
    frontMostWindowRect.origin.y = (visibleFrame.size.height / 2.0f) - (frontMostWindowRect.size.height / 2.0f);
    
    return frontMostWindowRect;
}

- (CGRect)maximizeFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrame: (CGRect)visibleFrame {
    CGFloat adjustedVisibleFrameY = (visibleFrame.origin.y > 0.0f) ? 0.0f : visibleFrame.origin.y;
    
    frontMostWindowRect.origin.x = visibleFrame.origin.x;
    frontMostWindowRect.origin.y = adjustedVisibleFrameY;
    
    frontMostWindowRect.size.width = visibleFrame.size.width;
    frontMostWindowRect.size.height = visibleFrame.size.height;
    
    return frontMostWindowRect;
}

- (CGRect)moveFrontMostWindowRect: (CGRect)frontMostWindowRect visibleFrame: (CGRect)visibleFrame toLocation: (SpectacleScreenLocation)location {
    CGFloat adjustedVisibleFrameY = (visibleFrame.origin.y > 0.0f) ? 0.0f : visibleFrame.origin.y;
    
    if ((location >= SpectacleScreenLocationRightHalf) && (location < SpectacleScreenLocationTopHalf)) {
        frontMostWindowRect.origin.x = visibleFrame.origin.x + floor(visibleFrame.size.width / 2.0f);
    } else {
        frontMostWindowRect.origin.x = visibleFrame.origin.x;
    }
    
    if ((location == SpectacleScreenLocationBottomHalf) || (location == SpectacleScreenLocationLowerLeft) || (location == SpectacleScreenLocationLowerRight)) {
        frontMostWindowRect.origin.y = adjustedVisibleFrameY + floor(visibleFrame.size.height / 2.0f) + [[NSStatusBar systemStatusBar] thickness];
    } else {
        frontMostWindowRect.origin.y = adjustedVisibleFrameY;
    }
    
    if ((location == SpectacleScreenLocationLeftHalf) || (location == SpectacleScreenLocationRightHalf)) {
        frontMostWindowRect.size.width = visibleFrame.size.width / 2.0f;
        frontMostWindowRect.size.height = visibleFrame.size.height;
    } else if ((location == SpectacleScreenLocationTopHalf) || (location == SpectacleScreenLocationBottomHalf)) {
        frontMostWindowRect.size.width = visibleFrame.size.width;
        frontMostWindowRect.size.height = visibleFrame.size.height / 2.0f;
    } else {
        frontMostWindowRect.size.width = visibleFrame.size.width / 2.0f;
        frontMostWindowRect.size.height = visibleFrame.size.height / 2.0f;
    }
    
    if ((location == SpectacleScreenLocationLeftHalf) || (location == SpectacleScreenLocationUpperLeft) || (location == SpectacleScreenLocationLowerLeft)) {
        frontMostWindowRect.size.width = frontMostWindowRect.size.width - 1.0f;
    }
    
    if ((location == SpectacleScreenLocationBottomHalf) || (location == SpectacleScreenLocationLowerLeft) || (location == SpectacleScreenLocationLowerRight)) {
        frontMostWindowRect.origin.y = frontMostWindowRect.origin.y + 2.0f;
        frontMostWindowRect.size.height = frontMostWindowRect.size.height - 2.0f;
    }
    
    return frontMostWindowRect;
}

@end
