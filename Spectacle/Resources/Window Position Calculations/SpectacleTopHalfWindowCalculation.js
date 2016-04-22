windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var calculatedWindowRect = windowRect;
    calculatedWindowRect.x = visibleFrameOfScreen.x;
    calculatedWindowRect.y = visibleFrameOfScreen.y + Math.floor(visibleFrameOfScreen.height / 2.0) + (visibleFrameOfScreen.height % 2.0);
    calculatedWindowRect.width = visibleFrameOfScreen.width;
    calculatedWindowRect.height = Math.floor(visibleFrameOfScreen.height / 2.0);
    return calculatedWindowRect;
}, "SpectacleWindowActionTopHalf");
