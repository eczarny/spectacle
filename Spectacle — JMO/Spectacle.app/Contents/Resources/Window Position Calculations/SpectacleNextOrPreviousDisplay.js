var SpectacleNextOrPreviousDisplay = (function () {
    var moveWindowRectToDisplay = function(windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
        if (SpectacleCalculationHelpers.rectFitsWithinRect(windowRect, visibleFrameOfDestinationScreen)) {
            return SpectacleCenterWindowCalculation.centerWindowRectInVisibleFrameOfScreen(windowRect, visibleFrameOfDestinationScreen);
        } else {
            return visibleFrameOfDestinationScreen;
        }
    };
    return {
        moveWindowRectToDisplay: moveWindowRectToDisplay,
    };
})();
