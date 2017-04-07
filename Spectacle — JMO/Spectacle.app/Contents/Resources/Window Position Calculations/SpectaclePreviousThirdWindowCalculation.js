windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    return SpectacleNextOrPreviousThirds.findPreviousThird(windowRect, visibleFrameOfDestinationScreen);
}, "SpectacleWindowActionPreviousThird");
