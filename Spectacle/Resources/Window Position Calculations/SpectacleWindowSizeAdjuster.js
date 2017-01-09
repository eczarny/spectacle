var SpectacleWindowSizeAdjuster = (function () {
    var resizeWindowRect = function(windowRect, visibleFrameOfDestinationScreen, sizeOffset) {
        var resizedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        resizedWindowRect.width = resizedWindowRect.width + sizeOffset;
        resizedWindowRect.x = resizedWindowRect.x - Math.floor(sizeOffset / 2.0);
        resizedWindowRect = adjustedWindowRectAgainstLeftAndRightEdgesOfScreen(windowRect,
                                                                               resizedWindowRect,
                                                                               visibleFrameOfDestinationScreen);
        if (resizedWindowRect.width >= visibleFrameOfDestinationScreen.width) {
            resizedWindowRect.width = visibleFrameOfDestinationScreen.width;
        }
        resizedWindowRect.height = resizedWindowRect.height + sizeOffset;
        resizedWindowRect.y = resizedWindowRect.y - Math.floor(sizeOffset / 2.0);
        resizedWindowRect = adjustedWindowRectAgainstTopAndBottomEdgesOfScreen(windowRect,
                                                                               resizedWindowRect,
                                                                               visibleFrameOfDestinationScreen);
        if (resizedWindowRect.height >= visibleFrameOfDestinationScreen.height) {
            resizedWindowRect.height = visibleFrameOfDestinationScreen.height;
            resizedWindowRect.y = windowRect.y;
        }
        if (againstAllEdgesOfScreen(windowRect, visibleFrameOfDestinationScreen) && (sizeOffset < 0)) {
            resizedWindowRect.width = windowRect.width + sizeOffset;
            resizedWindowRect.x = windowRect.x - Math.floor(sizeOffset / 2.0);
            resizedWindowRect.height = windowRect.height + sizeOffset;
            resizedWindowRect.y = windowRect.y - Math.floor(sizeOffset / 2.0);
        }
        if (resizedWindowRectIsTooSmall(resizedWindowRect, visibleFrameOfDestinationScreen)) {
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
    var againstAllEdgesOfScreen = function(windowRect, visibleFrameOfDestinationScreen) {
        return (againstTheLeftEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)
                && againstTheRightEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)
                && againstTheTopEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen)
                && againstTheBottomEdgeOfScreen(windowRect, visibleFrameOfDestinationScreen));
    };
    var adjustedWindowRectAgainstLeftAndRightEdgesOfScreen = function(originalWindowRect, resizedWindowRect, visibleFrameOfDestinationScreen) {
        var adjustedWindowRect = SpectacleCalculationHelpers.copyRect(resizedWindowRect);
        if (againstTheRightEdgeOfScreen(originalWindowRect, visibleFrameOfDestinationScreen)) {
            adjustedWindowRect.x = CGRectGetMaxX(visibleFrameOfDestinationScreen) - adjustedWindowRect.width;
            if (againstTheLeftEdgeOfScreen(originalWindowRect, visibleFrameOfDestinationScreen)) {
                adjustedWindowRect.width = visibleFrameOfDestinationScreen.width;
            }
        }
        if (againstTheLeftEdgeOfScreen(originalWindowRect, visibleFrameOfDestinationScreen)) {
            adjustedWindowRect.x = visibleFrameOfDestinationScreen.x;
        }
        return adjustedWindowRect;
    };
    var adjustedWindowRectAgainstTopAndBottomEdgesOfScreen = function(originalWindowRect, resizedWindowRect, visibleFrameOfDestinationScreen) {
        var adjustedWindowRect = SpectacleCalculationHelpers.copyRect(resizedWindowRect);
        if (againstTheTopEdgeOfScreen(originalWindowRect, visibleFrameOfDestinationScreen)) {
            adjustedWindowRect.y = CGRectGetMaxY(visibleFrameOfDestinationScreen) - adjustedWindowRect.height;
            if (againstTheBottomEdgeOfScreen(originalWindowRect, visibleFrameOfDestinationScreen)) {
                adjustedWindowRect.height = visibleFrameOfDestinationScreen.height;
            }
        }
        if (againstTheBottomEdgeOfScreen(originalWindowRect, visibleFrameOfDestinationScreen)) {
            adjustedWindowRect.y = visibleFrameOfDestinationScreen.y;
        }
        return adjustedWindowRect;
    };
    var resizedWindowRectIsTooSmall = function(windowRect, visibleFrameOfDestinationScreen) {
        var minimumWindowRectWidth = Math.floor(visibleFrameOfDestinationScreen.width / 4.0);
        var minimumWindowRectHeight = Math.floor(visibleFrameOfDestinationScreen.height / 4.0);
        return (windowRect.width <= minimumWindowRectWidth) || (windowRect.height <= minimumWindowRectHeight);
    };
    return {
        resizeWindowRect: resizeWindowRect,
    };
})();
