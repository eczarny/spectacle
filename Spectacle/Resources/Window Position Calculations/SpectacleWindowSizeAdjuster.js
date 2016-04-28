var SpectacleWindowSizeAdjuster = (function () {
    var resizeWindowRect = function(windowRect, visibleFrameOfDestinationScreen, sizeOffset) {
        var resizedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        resizedWindowRect.width = resizedWindowRect.width + sizeOffset;
        resizedWindowRect.x = resizedWindowRect.x - Math.floor(sizeOffset / 2.0);
        if (againstTheRightEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)) {
            resizedWindowRect.x = CGRectGetMaxX(visibleFrameOfDestinationScreen) - resizedWindowRect.width;
            if (againstTheLeftEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)) {
                resizedWindowRect.width = visibleFrameOfDestinationScreen.width;
            }
        }
        if (againstTheLeftEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)) {
            resizedWindowRect.x = visibleFrameOfDestinationScreen.x;
        }
        if (resizedWindowRect.width >= visibleFrameOfDestinationScreen.width) {
            resizedWindowRect.width = visibleFrameOfDestinationScreen.width;
        }
        resizedWindowRect.height = resizedWindowRect.height + sizeOffset;
        resizedWindowRect.y = resizedWindowRect.y - Math.floor(sizeOffset / 2.0);
        if (againstTheTopEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)) {
            resizedWindowRect.y = CGRectGetMaxY(visibleFrameOfDestinationScreen) - resizedWindowRect.height;
            if (againstTheBottomEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)) {
                resizedWindowRect.height = visibleFrameOfDestinationScreen.height;
            }
        }
        if (againstTheBottomEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)) {
            resizedWindowRect.y = visibleFrameOfDestinationScreen.y;
        }
        if (resizedWindowRect.height >= visibleFrameOfDestinationScreen.height) {
            resizedWindowRect.height = visibleFrameOfDestinationScreen.height;
            resizedWindowRect.y = windowRect.y;
        }
        if (CGRectEqualToRect(windowRect, visibleFrameOfDestinationScreen) && (sizeOffset < 0)) {
            resizedWindowRect.width = windowRect.width + sizeOffset;
            resizedWindowRect.x = windowRect.x - Math.floor(sizeOffset / 2.0);
            resizedWindowRect.height = windowRect.height + sizeOffset;
            resizedWindowRect.y = windowRect.y - Math.floor(sizeOffset / 2.0);
        }
        if (resizedWindowRectIsTooSmallRelativeToVisibleFrameOfScreen(resizedWindowRect, visibleFrameOfDestinationScreen)) {
            resizedWindowRect = windowRect;
        }
        return resizedWindowRect;
    };
    var againstEdgeOfScreen = function(gap) {
        return Math.abs(gap) <= 5.0;
    };
    var againstTheLeftEdgeOfScreen = function(windowRect, visibleFrameOfDestinationScreen) {
        return againstEdgeOfScreen(windowRect.x - visibleFrameOfDestinationScreen.x);
    };
    var againstTheRightEdgeOfScreen = function(windowRect, visibleFrameOfDestinationScreen) {
        return againstEdgeOfScreen(CGRectGetMaxX(windowRect) - CGRectGetMaxX(visibleFrameOfDestinationScreen));
    };
    var againstTheTopEdgeOfScreen = function(windowRect, visibleFrameOfDestinationScreen) {
        return againstEdgeOfScreen(CGRectGetMaxY(windowRect) - CGRectGetMaxY(visibleFrameOfDestinationScreen));
    };
    var againstTheBottomEdgeOfScreen = function(windowRect, visibleFrameOfDestinationScreen) {
        return againstEdgeOfScreen(windowRect.y - visibleFrameOfDestinationScreen.y);
    };
    var resizedWindowRectIsTooSmallRelativeToVisibleFrameOfScreen = function(windowRect, visibleFrameOfDestinationScreen) {
        var minimumWindowRectWidth = Math.floor(visibleFrameOfDestinationScreen.width / 4.0);
        var minimumWindowRectHeight = Math.floor(visibleFrameOfDestinationScreen.height / 4.0);
        return (windowRect.width <= minimumWindowRectWidth) || (windowRect.height <= minimumWindowRectHeight);
    };
    return {
        resizeWindowRect: resizeWindowRect,
    };
})();
