var SpectacleNextOrPreviousDisplay = (function () {
    var moveWindowRectToDisplay = function(windowRect, visibleFrameOfDestinationScreen) {
        var calculatedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        calculatedWindowRect.x = Math.floor(visibleFrameOfDestinationScreen.width / 2.0) - Math.floor(calculatedWindowRect.width / 2.0) + visibleFrameOfDestinationScreen.x;
        calculatedWindowRect.y = Math.floor(visibleFrameOfDestinationScreen.height / 2.0) - Math.floor(calculatedWindowRect.height / 2.0) + visibleFrameOfDestinationScreen.y;
        return calculatedWindowRect;
    };
    return {
        moveWindowRectToDisplay: moveWindowRectToDisplay,
    };
})();
