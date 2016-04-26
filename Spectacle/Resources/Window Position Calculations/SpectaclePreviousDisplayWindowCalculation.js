windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    return SpectacleNextOrPreviousDisplay.moveWindowRectToDisplay(windowRect, visibleFrameOfScreen);
}, "SpectacleWindowActionPreviousDisplay");
