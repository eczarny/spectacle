windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var oneHalfRect = SpectacleCalculationHelpers.copyRect(visibleFrameOfScreen);
    oneHalfRect.height = Math.floor(oneHalfRect.height / 2.0);
    if (Math.abs(CGRectGetMidX(windowRect) - CGRectGetMidX(oneHalfRect)) <= 1.0) {
        var twoThirdsRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
        twoThirdsRect.height = Math.floor(visibleFrameOfScreen.height * 2 / 3.0);
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(oneHalfRect, windowRect)) {
            return twoThirdsRect;
        }
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(twoThirdsRect, windowRect)) {
            var oneThirdRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
            oneThirdRect.height = Math.floor(visibleFrameOfScreen.height / 3.0);
            return oneThirdRect;
        }
    }
    return oneHalfRect;
}, "SpectacleWindowActionBottomHalf");
