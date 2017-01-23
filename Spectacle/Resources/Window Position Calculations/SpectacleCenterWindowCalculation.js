var SpectacleCenterWindowCalculation = (function () {
    var centerWindowRectInVisibleFrameOfScreen = function(windowRect, visibleFrameOfScreen) {
        var calculatedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
        calculatedWindowRect.x = Math.round((visibleFrameOfScreen.width - windowRect.width) / 2.0) + visibleFrameOfScreen.x;
        calculatedWindowRect.y = Math.round((visibleFrameOfScreen.height - windowRect.height) / 2.0) + visibleFrameOfScreen.y;
        return calculatedWindowRect;
    };
    return {
        centerWindowRectInVisibleFrameOfScreen: centerWindowRectInVisibleFrameOfScreen,
    };
})();

windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    return SpectacleCenterWindowCalculation.centerWindowRectInVisibleFrameOfScreen(windowRect, visibleFrameOfDestinationScreen);
}, "SpectacleWindowActionCenter");
