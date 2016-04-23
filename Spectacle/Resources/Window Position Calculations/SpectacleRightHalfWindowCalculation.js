windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var oneHalfRect = SpectacleCalculationHelpers.copyRect(visibleFrameOfScreen);
    oneHalfRect.width = Math.floor(oneHalfRect.width / 2.0);
    oneHalfRect.x += oneHalfRect.width;
    if (Math.abs(CGRectGetMidY(windowRect) - CGRectGetMidY(oneHalfRect)) <= 1.0) {
        var twoThirdRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
        twoThirdRect.width = Math.floor(visibleFrameOfScreen.width * 2 / 3.0);
        twoThirdRect.x = visibleFrameOfScreen.x + visibleFrameOfScreen.width - twoThirdRect.width;
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(oneHalfRect, windowRect)) {
            return twoThirdRect;
        }
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(twoThirdRect, windowRect)) {
            var oneThirdsRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
            oneThirdsRect.width = Math.floor(visibleFrameOfScreen.width / 3.0);
            oneThirdsRect.x = visibleFrameOfScreen.x + visibleFrameOfScreen.width - oneThirdsRect.width;
            return oneThirdsRect;
        }
    }
    return oneHalfRect;
}, "SpectacleWindowActionRightHalf");
