var SpectacleNextOrPreviousThirds = (function () {
    var findNextThird = function(windowRect, visibleFrameOfScreen) {
        var thirds = thirdsFromVisibleFrameOfScreen(visibleFrameOfScreen);
        var result = thirds[0];
        for (var i = 0; i < thirds.length; i++) {
            var third = thirds[i];
            if (rectCenteredWithinRect(third, windowRect)) {
                var j = i;
                if (++j >= thirds.length) {
                    j = 0;
                }
                result = thirds[j];
                break;
            }
        }
        return result;
    };
    var findPreviousThird = function(windowRect, visibleFrameOfScreen) {
        var thirds = thirdsFromVisibleFrameOfScreen(visibleFrameOfScreen);
        var result = thirds[0];
        for (var i = 0; i < thirds.length; i++) {
            var third = thirds[i];
            if (rectCenteredWithinRect(third, windowRect)) {
                var j = i;
                if (--j < 0) {
                    j = thirds.length - 1;
                }
                result = thirds[j];
                break;
            }
        }
        return result;
    };
    var thirdsFromVisibleFrameOfScreen = function(visibleFrameOfScreen) {
        var thirds = [];
        for (var i = 0; i < 3; i++) {
            var third = {
                x: visibleFrameOfScreen.x,
                y: visibleFrameOfScreen.y,
                width: visibleFrameOfScreen.width,
                height: visibleFrameOfScreen.height,
            };
            third.x = visibleFrameOfScreen.x + (Math.floor(visibleFrameOfScreen.width / 3.0) * i);
            third.width = Math.floor(visibleFrameOfScreen.width / 3.0);
            thirds.push(third);
        }
        for (var i = 0; i < 3; i++) {
            var third = {
                x: visibleFrameOfScreen.x,
                y: visibleFrameOfScreen.y,
                width: visibleFrameOfScreen.width,
                height: visibleFrameOfScreen.height,
            };
            third.y = visibleFrameOfScreen.y + visibleFrameOfScreen.height - (Math.floor(visibleFrameOfScreen.height / 3.0) * (i + 1));
            third.height = Math.floor(visibleFrameOfScreen.height / 3.0);
            thirds.push(third);
        }
        return thirds;
    };
    var rectCenteredWithinRect = function(rect1, rect2) {
        var centeredMidX = Math.abs(CGRectGetMidX(rect2) - CGRectGetMidX(rect1)) <= 1.0;
        var centeredMidY = Math.abs(CGRectGetMidY(rect2) - CGRectGetMidY(rect1)) <= 1.0;
        return CGRectContainsRect(rect1, rect2) && centeredMidX && centeredMidY;
    };
    return {
        findNextThird: findNextThird,
        findPreviousThird: findPreviousThird,
    };
})();
