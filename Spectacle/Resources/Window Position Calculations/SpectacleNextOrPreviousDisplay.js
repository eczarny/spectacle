var SpectacleNextOrPreviousDisplay = (function () {
    var moveWindowRectToDisplay = function(windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
        var calculatedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        var relativeSourceDistanceToLeftEdge = Math.abs(CGRectGetMinX(visibleFrameOfSourceScreen) - CGRectGetMinX(windowRect)) / visibleFrameOfSourceScreen.width;
        var relativeSourceDistanceToRightEdge = Math.abs(CGRectGetMaxX(visibleFrameOfSourceScreen) - CGRectGetMaxX(windowRect)) / visibleFrameOfSourceScreen.width;
        var relativeSourceDistanceToTopEdge = Math.abs(CGRectGetMinY(visibleFrameOfSourceScreen) - CGRectGetMinY(windowRect)) / visibleFrameOfSourceScreen.height;
        var relativeSourceDistanceToBottomEdge = Math.abs(CGRectGetMaxY(visibleFrameOfSourceScreen) - CGRectGetMaxY(windowRect)) / visibleFrameOfSourceScreen.height;
        var destinationDistanceToLeftEdge = Math.ceil(visibleFrameOfDestinationScreen.width * relativeSourceDistanceToLeftEdge);
        var destinationDistanceToRightEdge = Math.ceil(visibleFrameOfDestinationScreen.width * relativeSourceDistanceToRightEdge);
        var destinationDistanceToTopEdge = Math.floor(visibleFrameOfDestinationScreen.height * relativeSourceDistanceToTopEdge);
        var destinationDistanceToBottomEdge = Math.floor(visibleFrameOfDestinationScreen.height * relativeSourceDistanceToBottomEdge);
        calculatedWindowRect.x = visibleFrameOfDestinationScreen.x + destinationDistanceToLeftEdge;
        calculatedWindowRect.y = visibleFrameOfDestinationScreen.y + destinationDistanceToTopEdge;
        calculatedWindowRect.width = visibleFrameOfDestinationScreen.width - (destinationDistanceToLeftEdge + destinationDistanceToRightEdge);
        calculatedWindowRect.height = visibleFrameOfDestinationScreen.height - (destinationDistanceToTopEdge + destinationDistanceToBottomEdge);
        return calculatedWindowRect;
    };
    return {
        moveWindowRectToDisplay: moveWindowRectToDisplay,
    };
})();
