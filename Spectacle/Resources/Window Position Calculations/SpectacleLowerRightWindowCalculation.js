windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    var calculatedWindowRect = SpectacleCalculationHelpers.copyRect(windowRect);
    calculatedWindowRect.x = visibleFrameOfDestinationScreen.x + Math.floor(visibleFrameOfDestinationScreen.width / 2.0);
    calculatedWindowRect.y = visibleFrameOfDestinationScreen.y;
    calculatedWindowRect.width = Math.floor(visibleFrameOfDestinationScreen.width / 2.0);
    calculatedWindowRect.height = Math.floor(visibleFrameOfDestinationScreen.height / 2.0);
    return calculatedWindowRect;
}, "SpectacleWindowActionLowerRight");
