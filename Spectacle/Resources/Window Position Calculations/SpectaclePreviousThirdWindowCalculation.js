windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    return SpectacleNextOrPreviousThirds.findPreviousThird(windowRect, visibleFrameOfScreen);
}, "SpectacleWindowActionPreviousThird");
