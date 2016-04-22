windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var calculatedWindowRect = windowRect;
    calculatedWindowRect.x = visibleFrameOfScreen.x;
    calculatedWindowRect.y = visibleFrameOfScreen.y;
    calculatedWindowRect.width = Math.floor(visibleFrameOfScreen.width / 2.0);
    calculatedWindowRect.height = visibleFrameOfScreen.height;
    return calculatedWindowRect;
}, "SpectacleWindowActionLeftHalf");
