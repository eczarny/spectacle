var SpectacleWindowSizeAdjuster = (function () {
    var resizeWindowRect = function(windowRect, visibleFrameOfScreen, sizeOffset) {
        var resizedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        resizedWindowRect.width = resizedWindowRect.width + sizeOffset;
        resizedWindowRect.x = resizedWindowRect.x - Math.floor(sizeOffset / 2.0);
        if (againstTheRightEdgeOfScreen(windowRect, visibleFrameOfScreen)) {
            resizedWindowRect.x = CGRectGetMaxX(visibleFrameOfScreen) - resizedWindowRect.width;
            if (againstTheLeftEdgeOfScreen(windowRect, visibleFrameOfScreen)) {
                resizedWindowRect.width = visibleFrameOfScreen.width;
            }
        }
        if (againstTheLeftEdgeOfScreen(windowRect, visibleFrameOfScreen)) {
            resizedWindowRect.x = visibleFrameOfScreen.x;
        }
        if (resizedWindowRect.width >= visibleFrameOfScreen.width) {
            resizedWindowRect.width = visibleFrameOfScreen.width;
        }
        resizedWindowRect.height = resizedWindowRect.height + sizeOffset;
        resizedWindowRect.y = resizedWindowRect.y - Math.floor(sizeOffset / 2.0);
        if (againstTheTopEdgeOfScreen(windowRect, visibleFrameOfScreen)) {
            resizedWindowRect.y = CGRectGetMaxY(visibleFrameOfScreen) - resizedWindowRect.height;
            if (againstTheBottomEdgeOfScreen(windowRect, visibleFrameOfScreen)) {
                resizedWindowRect.height = visibleFrameOfScreen.height;
            }
        }
        if (againstTheBottomEdgeOfScreen(windowRect, visibleFrameOfScreen)) {
            resizedWindowRect.y = visibleFrameOfScreen.y;
        }
        if (resizedWindowRect.height >= visibleFrameOfScreen.height) {
            resizedWindowRect.height = visibleFrameOfScreen.height;
            resizedWindowRect.y = windowRect.y;
        }
        if (CGRectEqualToRect(windowRect, visibleFrameOfScreen) && (sizeOffset < 0)) {
            resizedWindowRect.width = windowRect.width + sizeOffset;
            resizedWindowRect.x = windowRect.x - Math.floor(sizeOffset / 2.0);
            resizedWindowRect.height = windowRect.height + sizeOffset;
            resizedWindowRect.y = windowRect.y - Math.floor(sizeOffset / 2.0);
        }
        if (resizedWindowRectIsTooSmallRelativeToVisibleFrameOfScreen(resizedWindowRect, visibleFrameOfScreen)) {
            resizedWindowRect = windowRect;
        }
        return resizedWindowRect;
    };
    var againstEdgeOfScreen = function(gap) {
        return Math.abs(gap) <= 5.0;
    };
    var againstTheLeftEdgeOfScreen = function(windowRect, visibleFrameOfScreen) {
        return againstEdgeOfScreen(windowRect.x - visibleFrameOfScreen.x);
    };
    var againstTheRightEdgeOfScreen = function(windowRect, visibleFrameOfScreen) {
        return againstEdgeOfScreen(CGRectGetMaxX(windowRect) - CGRectGetMaxX(visibleFrameOfScreen));
    };
    var againstTheTopEdgeOfScreen = function(windowRect, visibleFrameOfScreen) {
        return againstEdgeOfScreen(CGRectGetMaxY(windowRect) - CGRectGetMaxY(visibleFrameOfScreen));
    };
    var againstTheBottomEdgeOfScreen = function(windowRect, visibleFrameOfScreen) {
        return againstEdgeOfScreen(windowRect.y - visibleFrameOfScreen.y);
    };
    var resizedWindowRectIsTooSmallRelativeToVisibleFrameOfScreen = function(windowRect, visibleFrameOfScreen) {
        var minimumWindowRectWidth = Math.floor(visibleFrameOfScreen.width / 4.0);
        var minimumWindowRectHeight = Math.floor(visibleFrameOfScreen.height / 4.0);
        return (windowRect.width <= minimumWindowRectWidth) || (windowRect.height <= minimumWindowRectHeight);
    };
    return {
        resizeWindowRect: resizeWindowRect,
    };
})();
