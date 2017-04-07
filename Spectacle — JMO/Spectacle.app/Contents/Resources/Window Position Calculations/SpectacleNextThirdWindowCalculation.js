windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    return SpectacleNextOrPreviousThirds.findNextThird(windowRect, visibleFrameOfDestinationScreen);
}, "SpectacleWindowActionNextThird");
