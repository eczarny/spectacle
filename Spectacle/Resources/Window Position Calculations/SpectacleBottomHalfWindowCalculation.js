windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(
    function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
        if (SpectacleCalculationHelpers.isBottomHalf(windowRect, visibleFrameOfDestinationScreen)) {
            return SpectacleCalculationHelpers.copyRect(visibleFrameOfDestinationScreen);
        }

        var r = SpectacleCalculationHelpers.isLeftOrRightHalf(windowRect, visibleFrameOfDestinationScreen) ?
            windowRect : visibleFrameOfDestinationScreen;

        return SpectacleCalculationHelpers.calcBottomHalf(r);
    }, "SpectacleWindowActionBottomHalf");
