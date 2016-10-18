windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    var oneQuartRect = SpectacleCalculationHelpers.copyRect(visibleFrameOfDestinationScreen);
    oneQuartRect.width = Math.floor(visibleFrameOfDestinationScreen.width / 2.0);
    oneQuartRect.height = Math.floor(visibleFrameOfDestinationScreen.height / 2.0);
    oneQuartRect.x += oneQuartRect.width;

    if (Math.abs(CGRectGetMidY(windowRect) - CGRectGetMidY(oneQuartRect)) <= 1.0) {
        var twoThirdRect = SpectacleCalculationHelpers.copyRect(oneQuartRect);
        twoThirdRect.width = Math.floor(visibleFrameOfDestinationScreen.width * 2 / 3.0);
        twoThirdRect.x = visibleFrameOfDestinationScreen.x + visibleFrameOfDestinationScreen.width - twoThirdRect.width;
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(oneQuartRect, windowRect)) {
            return twoThirdRect;
        }
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(twoThirdRect, windowRect)) {
            var oneThirdsRect = SpectacleCalculationHelpers.copyRect(oneQuartRect);
            oneThirdsRect.width = Math.floor(visibleFrameOfDestinationScreen.width / 3.0);
            oneThirdsRect.x = visibleFrameOfDestinationScreen.x + visibleFrameOfDestinationScreen.width - oneThirdsRect.width;
            return oneThirdsRect;
        }
    }

    return oneQuartRect;
}, "SpectacleWindowActionLowerRight");