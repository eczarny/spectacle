windowPositionCalculationRegistry.registerWindowPositionCalculationWithAction(function (windowRect, visibleFrameOfScreen) {
    var oneHalfRect = SpectacleCalculationHelpers.copyRect(visibleFrameOfScreen);
    oneHalfRect.height = Math.floor(oneHalfRect.height / 2.0);
    oneHalfRect.y += oneHalfRect.height + (visibleFrameOfScreen.height % 2.0);
    if (Math.abs(CGRectGetMidX(windowRect) - CGRectGetMidX(oneHalfRect)) <= 1.0) {
        var twoThirdsRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
        twoThirdsRect.height = Math.floor(visibleFrameOfScreen.height * 2 / 3.0);
        twoThirdsRect.y = visibleFrameOfScreen.y + visibleFrameOfScreen.height - twoThirdsRect.height;
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(oneHalfRect, windowRect)) {
            return twoThirdsRect;
        }
        if (SpectacleCalculationHelpers.rectCenteredWithinRect(twoThirdsRect, windowRect)) {
            var oneThirdRect = SpectacleCalculationHelpers.copyRect(oneHalfRect);
            oneThirdRect.height = Math.floor(visibleFrameOfScreen.height / 3.0);
            oneThirdRect.y = visibleFrameOfScreen.y + visibleFrameOfScreen.height - oneThirdRect.height;
            return oneThirdRect;
        }
    }
    return oneHalfRect;
}, "SpectacleWindowActionTopHalf");
