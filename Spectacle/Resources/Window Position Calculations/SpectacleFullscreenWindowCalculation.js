windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var calculatedWindowRect = windowRect;
    calculatedWindowRect.x = visibleFrameOfScreen.x;
    calculatedWindowRect.y = visibleFrameOfScreen.y;
    calculatedWindowRect.width = visibleFrameOfScreen.width;
    calculatedWindowRect.height = visibleFrameOfScreen.height;
    return calculatedWindowRect;
}, 2 /*SpectacleWindowActionFullscreen*/);
