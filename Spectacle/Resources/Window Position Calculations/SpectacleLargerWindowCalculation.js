windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    return SpectacleWindowSizeAdjuster.resizeWindowRect(windowRect, visibleFrameOfScreen, 30.0);
}, "SpectacleWindowActionLarger");
