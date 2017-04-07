windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    return visibleFrameOfDestinationScreen;
}, "SpectacleWindowActionFullscreen");
