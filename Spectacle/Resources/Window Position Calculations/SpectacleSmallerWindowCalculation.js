windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    return SpectacleWindowSizeAdjuster.resizeWindowRect(windowRect, visibleFrameOfDestinationScreen, -30.0);
}, "SpectacleWindowActionSmaller");
