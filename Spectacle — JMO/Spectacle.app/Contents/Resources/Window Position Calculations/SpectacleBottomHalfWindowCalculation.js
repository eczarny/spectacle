windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfSourceScreen, visibleFrameOfDestinationScreen) {
    var oneHalfRect = SpectacleCalculationHelpers.copyRect(visibleFrameOfDestinationScreen);
    oneHalfRect.height = Math.floor(oneHalfRect.height / 2.0);
    if (Math.abs(CGRectGetMidX(windowRect) - CGRectGetMidX(oneHalfRect)) <= 1.0) {
        var twoThirdsRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
        twoThirdsRect.height = Math.floor(visibleFrameOfDestinationScreen.height * 2 / 3.0);
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(oneHalfRect, windowRect)) {
            return twoThirdsRect;
        }
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(twoThirdsRect, windowRect)) {
            var oneThirdRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
            oneThirdRect.height = Math.floor(visibleFrameOfDestinationScreen.height / 3.0);
            return oneThirdRect;
        }
    }
    return oneHalfRect;
}, "SpectacleWindowActionBottomHalf");
