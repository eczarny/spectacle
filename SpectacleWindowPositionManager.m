#import "SpectacleWindowPositionManager.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleScreenDetection.h"
#import "SpectacleHistory.h"
#import "SpectacleHistoryItem.h"
#import "SpectacleUtilities.h"
#import "SpectacleConstants.h"
#import "ZKAccessibilityElementAdditions.h"

#define Resizing(action) ((action == SpectacleWindowActionLarger) || (action == SpectacleWindowActionSmaller))

#pragma mark -

#define UndoOrRedo(action) ((action == SpectacleWindowActionUndo) || (action == SpectacleWindowActionRedo))

#pragma mark -

#define BlacklistedWindowRect(applicationName, windowRect) [NSString stringWithFormat: @"%@ - %@", applicationName, WindowRectToString(windowRect)]

#pragma mark -

@interface SpectacleWindowPositionManager ()

@property (nonatomic) NSMutableDictionary *applicationHistories;
@property (nonatomic) NSMutableSet *blacklistedWindowRects;
@property (nonatomic) NSMutableSet *blacklistedApplications;

@end

#pragma mark -

@implementation SpectacleWindowPositionManager

- (id)init {
    if ((self = [super init])) {
        NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
        NSString *path = [NSBundle.mainBundle pathForResource: SpectacleBlacklistedApplicationsPropertyListFile
                                                       ofType: SpectaclePropertyListFileExtension];
        
        _applicationHistories = [NSMutableDictionary new];
        _blacklistedWindowRects = [NSMutableSet setWithArray: [userDefaults arrayForKey: SpectacleBlacklistedWindowRectsPreference]];
        _blacklistedApplications = [NSMutableSet setWithArray: [NSArray arrayWithContentsOfFile: path]];
    }
    
    return self;
}

#pragma mark -

+ (SpectacleWindowPositionManager *)sharedManager {
    static SpectacleWindowPositionManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

#pragma mark -

- (void)moveFrontMostWindowWithAction: (SpectacleWindowAction)action {
    ZKAccessibilityElement *frontMostWindowElement = ZKAccessibilityElement.frontMostWindowElement;
    CGRect frontMostWindowRect = [self rectOfWindowWithAccessibilityElement: frontMostWindowElement];
    CGRect previousFrontMostWindowRect = CGRectNull;
    NSScreen *screenOfDisplay = [SpectacleScreenDetection screenWithAction: action andRect: frontMostWindowRect];
    CGRect frameOfScreen = CGRectNull;
    CGRect visibleFrameOfScreen = CGRectNull;
    SpectacleHistory *history = self.historyForCurrentApplication;
    SpectacleHistoryItem *historyItem = nil;
    
    if (screenOfDisplay) {
        frameOfScreen = NSRectToCGRect([screenOfDisplay frame]);
        visibleFrameOfScreen = NSRectToCGRect([screenOfDisplay visibleFrame]);
    }
    
    if (CGRectIsNull(frontMostWindowRect) || CGRectIsNull(frameOfScreen) || CGRectIsNull(visibleFrameOfScreen) || CGRectEqualToRect(frontMostWindowRect, frameOfScreen)) {
        NSBeep();
        
        return;
    }
    
    if (UndoOrRedo(action)) {
        [self undoOrRedoHistoryWithAction: action];
        
        return;
    }
    
    if ([history isEmpty]) {
        historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement: frontMostWindowElement
                                                                     windowRect: frontMostWindowRect];
        
        [history addHistoryItem: historyItem];
    }
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    if (MovingToNextOrPreviousDisplay(action) && RectFitsInRect(frontMostWindowRect, visibleFrameOfScreen)) {
        action = SpectacleWindowActionCenter;
    }
    
    previousFrontMostWindowRect = frontMostWindowRect;
    
    if (Resizing(action)) {
        CGFloat sizeOffset = ((action == SpectacleWindowActionLarger) ? 1.0 : -1.0) * SpectacleWindowSizeOffset;
        
        frontMostWindowRect = [SpectacleWindowPositionCalculator calculateResizedWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen sizeOffset: sizeOffset];
    } else {
        frontMostWindowRect = [SpectacleWindowPositionCalculator calculateWindowRect: frontMostWindowRect visibleFrameOfScreen: visibleFrameOfScreen action: action];
    }
    
    if (CGRectEqualToRect(previousFrontMostWindowRect, frontMostWindowRect)) {
        NSBeep();
        
        return;
    }
    
    frontMostWindowRect.origin.y = FlipVerticalOriginOfRectInRect(frontMostWindowRect, frameOfScreen);
    
    historyItem = [SpectacleHistoryItem historyItemFromAccessibilityElement: frontMostWindowElement
                                                                 windowRect: frontMostWindowRect];
    
    [history addHistoryItem: historyItem];
    
    [self moveWindowRect: frontMostWindowRect frameOfScreen: frameOfScreen visibleFrameOfScreen: visibleFrameOfScreen frontMostWindowElement: frontMostWindowElement action: action];
}

#pragma mark -

- (void)undoLastWindowAction {
    [self moveFrontMostWindowWithAction: SpectacleWindowActionUndo];
}

- (void)redoLastWindowAction {
    [self moveFrontMostWindowWithAction: SpectacleWindowActionRedo];
}

#pragma mark -

- (SpectacleWindowAction)windowActionForHotKey: (ZKHotKey *)hotKey {
    NSString *name = hotKey.hotKeyName;
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
    } else if ([name isEqualToString: SpectacleWindowActionMakeLarger]) {
        windowAction = SpectacleWindowActionLarger;
    } else if ([name isEqualToString: SpectacleWindowActionMakeSmaller]) {
        windowAction = SpectacleWindowActionSmaller;
    } else if ([name isEqualToString: SpectacleWindowActionUndoLastMove]) {
        windowAction = SpectacleWindowActionUndo;
    } else if ([name isEqualToString: SpectacleWindowActionRedoLastMove]) {
        windowAction = SpectacleWindowActionRedo;
    }
    
    return windowAction;
}

#pragma mark -

- (CGRect)rectOfWindowWithAccessibilityElement: (ZKAccessibilityElement *)accessibilityElement {
    CGRect result = CGRectNull;
    
    if (accessibilityElement) {
        CFTypeRef windowPositionValue = [accessibilityElement valueOfAttribute: kAXPositionAttribute type: kAXValueCGPointType];
        CFTypeRef windowSizeValue = [accessibilityElement valueOfAttribute: kAXSizeAttribute type: kAXValueCGSizeType];
        CGPoint windowPosition;
        CGSize windowSize;
        
        AXValueGetValue(windowPositionValue, kAXValueCGPointType, (void *)&windowPosition);
        AXValueGetValue(windowSizeValue, kAXValueCGSizeType, (void *)&windowSize);
        
        if ((windowPositionValue != NULL) && (windowSizeValue != NULL)) {
            CFRelease(windowPositionValue);
            CFRelease(windowSizeValue);
        
            result = CGRectMake(windowPosition.x, windowPosition.y, windowSize.width, windowSize.height);
        }
    }
    
    return result;
}

#pragma mark -

- (void)moveWindowRect: (CGRect)windowRect frameOfScreen: (CGRect)frameOfScreen visibleFrameOfScreen: (CGRect)visibleFrameOfScreen frontMostWindowElement: (ZKAccessibilityElement *)frontMostWindowElement action: (SpectacleWindowAction)action {
    NSString *frontMostApplicationName = ZKAccessibilityElement.frontMostApplicationName;
    NSString *blacklistedWindowRect = BlacklistedWindowRect(frontMostApplicationName, windowRect);
    
    if ([_blacklistedWindowRects containsObject: blacklistedWindowRect] || [_blacklistedApplications containsObject: frontMostApplicationName]) {
        NSBeep();
        
        return;
    }
    
    CGRect previousWindowRect = [self rectOfWindowWithAccessibilityElement: frontMostWindowElement];
    
    if (CGRectIsNull(previousWindowRect)) {
        NSBeep();
        
        return;
    }
    
    [self moveWindowRect: windowRect frontMostWindowElement: frontMostWindowElement];
    
    CGRect movedWindowRect = [self rectOfWindowWithAccessibilityElement: frontMostWindowElement];
    
    if (MovingToThirdOfDisplay(action) && !CGRectEqualToRect(movedWindowRect, windowRect)) {
        NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
        
        NSBeep();
        
        [_blacklistedWindowRects addObject: blacklistedWindowRect];
        
        [userDefaults setObject: _blacklistedWindowRects.allObjects forKey: SpectacleBlacklistedWindowRectsPreference];
        
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
        
        movedWindowRect.size = windowRect.size;
        
        movedWindowRect.origin.y = FlipVerticalOriginOfRectInRect(movedWindowRect, frameOfScreen);
        
        [self moveWindowRect: movedWindowRect frontMostWindowElement: frontMostWindowElement];
    }
}

- (void)moveWindowRect: (CGRect)windowRect frontMostWindowElement: (ZKAccessibilityElement *)frontMostWindowElement {
    AXValueRef windowRectPositionRef = AXValueCreate(kAXValueCGPointType, (const void *)&windowRect.origin);
    AXValueRef windowRectSizeRef = AXValueCreate(kAXValueCGSizeType, (const void *)&windowRect.size);
    
    [frontMostWindowElement setValue: windowRectSizeRef forAttribute: kAXSizeAttribute];
    [frontMostWindowElement setValue: windowRectPositionRef forAttribute: kAXPositionAttribute];
    [frontMostWindowElement setValue: windowRectSizeRef forAttribute: kAXSizeAttribute];
    
    CFRelease(windowRectPositionRef);
    CFRelease(windowRectSizeRef);
}

#pragma mark -

- (SpectacleHistory *)historyForCurrentApplication {
    NSString *applicationName = ZKAccessibilityElement.frontMostApplicationName;
    
    if (!applicationName) {
        return nil;
    }
    
    if (!_applicationHistories[applicationName]) {
        _applicationHistories[applicationName] = [SpectacleHistory new];
    }
    
    return _applicationHistories[applicationName];
}

#pragma mark -

- (void)undoOrRedoHistoryWithAction: (SpectacleWindowAction)action {
    SpectacleHistory *history = self.historyForCurrentApplication;
    SpectacleHistoryItem *historyItem = (action == SpectacleWindowActionUndo) ? history.previousHistoryItem : history.nextHistoryItem;
    NSScreen *screenOfDisplay = [SpectacleScreenDetection screenWithAction: action andRect: historyItem.windowRect];
    CGRect visibleFrameOfScreen = CGRectNull;
    
    if (screenOfDisplay) {
        visibleFrameOfScreen = NSRectToCGRect(screenOfDisplay.visibleFrame);
    }
    
    if (![self moveWithHistoryItem: historyItem visibleFrameOfScreen: visibleFrameOfScreen action: action]) {
        NSBeep();
    }
}

- (BOOL)moveWithHistoryItem: (SpectacleHistoryItem *)historyItem visibleFrameOfScreen: (CGRect)visibleFrameOfScreen action: (SpectacleWindowAction)action {
    ZKAccessibilityElement *frontMostWindowElement = historyItem.accessibilityElement;
    CGRect windowRect = historyItem.windowRect;
    
    if (!historyItem || !frontMostWindowElement || CGRectIsNull(windowRect)) {
        return NO;
    }
    
    [self moveWindowRect: windowRect frameOfScreen: CGRectNull visibleFrameOfScreen: visibleFrameOfScreen frontMostWindowElement: frontMostWindowElement action: action];
    
    return YES;
}

@end
