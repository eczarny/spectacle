windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    return SpectacleWindowSizeAdjuster.resizeWindowRect(windowRect, visibleFrameOfDestinationScreen, visibleFrameOfDestinationScreen.width * 0.0625);
}, "SpectacleWindowActionLarger");
