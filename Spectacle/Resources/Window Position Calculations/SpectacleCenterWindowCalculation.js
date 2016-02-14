windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var calculatedWindowRect = windowRect;
    calculatedWindowRect.x = Math.floor(visibleFrameOfScreen.width / 2.0) - Math.floor(calculatedWindowRect.width / 2.0) + visibleFrameOfScreen.x;
    calculatedWindowRect.y = Math.floor(visibleFrameOfScreen.height / 2.0) - Math.floor(calculatedWindowRect.height / 2.0) + visibleFrameOfScreen.y;
    return new SpectacleWindowPositionCalculationResult(1 /*SpectacleWindowActionCenter*/, calculatedWindowRect);
}, 1 /*SpectacleWindowActionCenter*/);
