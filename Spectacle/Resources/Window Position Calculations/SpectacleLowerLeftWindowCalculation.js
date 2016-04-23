windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var calculatedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
    calculatedWindowRect.x = visibleFrameOfScreen.x;
    calculatedWindowRect.y = visibleFrameOfScreen.y;
    calculatedWindowRect.width = Math.floor(visibleFrameOfScreen.width / 2.0);
    calculatedWindowRect.height = Math.floor(visibleFrameOfScreen.height / 2.0);
    return calculatedWindowRect;
}, "SpectacleWindowActionLowerLeft");
