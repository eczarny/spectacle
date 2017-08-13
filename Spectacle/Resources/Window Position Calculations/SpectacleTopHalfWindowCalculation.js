windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(
    function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
        if (SpectacleCalculationHelpers.isTopHalf(windowRect, visibleFrameOfDestinationScreen)) {
            return SpectacleCalculationHelpers.copyRect(visibleFrameOfDestinationScreen);
        }

        var r = SpectacleCalculationHelpers.isLeftOrRightHalf(windowRect, visibleFrameOfDestinationScreen) ?
            windowRect : visibleFrameOfDestinationScreen;

        return SpectacleCalculationHelpers.calcTopHalf(r);
}, "SpectacleWindowActionTopHalf");
