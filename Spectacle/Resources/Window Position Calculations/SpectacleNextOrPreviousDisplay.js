var SpectacleNextOrPreviousDisplay = (function () {
    var moveWindowRectToDisplay = function(windowRect, visibleFrameOfScreen) {
        var calculatedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        calculatedWindowRect.x = Math.floor(visibleFrameOfScreen.width / 2.0) - Math.floor(calculatedWindowRect.width / 2.0) + visibleFrameOfScreen.x;
        calculatedWindowRect.y = Math.floor(visibleFrameOfScreen.height / 2.0) - Math.floor(calculatedWindowRect.height / 2.0) + visibleFrameOfScreen.y;
        return calculatedWindowRect;
    };
    return {
        moveWindowRectToDisplay: moveWindowRectToDisplay,
    };
})();
