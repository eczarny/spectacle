windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var calculatedWindowRect = windowRect;
    calculatedWindowRect.x = Math.floor(visibleFrameOfScreen.width / 2.0);
    calculatedWindowRect.y = visibleFrameOfScreen.y;
    calculatedWindowRect.width = Math.floor(visibleFrameOfScreen.width / 2.0);
    calculatedWindowRect.height = visibleFrameOfScreen.height;
    return calculatedWindowRect;
}, "SpectacleWindowActionRightHalf");
