windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    return SpectacleNextOrPreviousThirds.findNextThird(windowRect, visibleFrameOfScreen);
}, "SpectacleWindowActionNextThird");
