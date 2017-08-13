windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(
    function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
        if (SpectacleCalculationHelpers.isLeftHalf(windowRect, visibleFrameOfDestinationScreen)) {
            return SpectacleCalculationHelpers.copyRect(visibleFrameOfDestinationScreen);
        }

        var r = SpectacleCalculationHelpers.isTopOrBottomHalf(windowRect, visibleFrameOfDestinationScreen) ?
            windowRect : visibleFrameOfDestinationScreen;

        return SpectacleCalculationHelpers.calcLeftHalf(r);
    }, "SpectacleWindowActionLeftHalf");
