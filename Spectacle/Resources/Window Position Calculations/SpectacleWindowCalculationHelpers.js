var SpectacleCalculationHelpers = (function () {
    var copyRect = function(rect) {
        return {
            x: rect.x,
            y: rect.y,
            width: rect.width,
            height: rect.height,
        };
    };
    var rectCenteredWithinRect = function(rect1, rect2) {
        var centeredMidX = Math.abs(CGRectGetMidX(rect2) - CGRectGetMidX(rect1)) <= 1.0;
        var centeredMidY = Math.abs(CGRectGetMidY(rect2) - CGRectGetMidY(rect1)) <= 1.0;
        return CGRectContainsRect(rect1, rect2) && centeredMidX && centeredMidY;
    };
    return {
        copyRect: copyRect,
        rectCenteredWithinRect: rectCenteredWithinRect,
    };
})();
