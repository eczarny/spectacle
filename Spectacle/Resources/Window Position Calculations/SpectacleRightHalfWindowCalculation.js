windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(
    function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
        if (SpectacleCalculationHelpers.isRightHalf(windowRect, visibleFrameOfDestinationScreen)) {
            return SpectacleCalculationHelpers.copyRect(visibleFrameOfDestinationScreen);
        }

        var r = SpectacleCalculationHelpers.isTopOrBottomHalf(windowRect, visibleFrameOfDestinationScreen) ?
            windowRect : visibleFrameOfDestinationScreen;

        return SpectacleCalculationHelpers.calcRightHalf(r);
    }, "SpectacleWindowActionRightHalf");
