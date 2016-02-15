#import "SpectacleCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

static CGFloat kWindowSizeOffset = 30.0f;

SpecBegin(windowPositionCalculator)
  describe(@"windowPositionCalculator", ^{
    CGRect visibleFrameScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
    CGRect windowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);
    SpectacleWindowPositionCalculator *windowPositionCalculator = [SpectacleWindowPositionCalculator new];

    it(@"should calculate a centered window's CGRect", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionCenter];

      expect(result.windowRect).to.equal(CGRectMake(438.0f, 248.0f, 564.0f, 384.0f));
    });

    it(@"should calculate a fullscreen window's CGRect", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionFullscreen];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the left half of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionLeftHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 720.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the left 2/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 720.0f, 873.0f)
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionLeftHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 960.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the left 1/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 960.0f, 873.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                           action:SpectacleWindowActionLeftHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 480.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the right half of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                           action:SpectacleWindowActionRightHalf];

      expect(result.windowRect).to.equal(CGRectMake(720.0f, 4.0f, 720.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the right 2/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(720.0f, 4.0f, 720.0f, 873.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                           action:SpectacleWindowActionRightHalf];

      expect(result.windowRect).to.equal(CGRectMake(480.0f, 4.0f, 960.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the right 1/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(480.0f, 4.0f, 960.0f, 873.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                           action:SpectacleWindowActionRightHalf];

      expect(result.windowRect).to.equal(CGRectMake(960.0f, 4.0f, 480.0f, 873.0f));
    });

    it(@"should calculate a window's CGRect in the top half of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionTopHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 441.0f, 1440.0f, 436.0f));
    });

    it(@"should calculate a window's CGRect in the top 2/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 441.0f, 1440.0f, 436.0f)
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionTopHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 295.0f, 1440.0f, 582.0f));
    });

    it(@"should calculate a window's CGRect in the top 1/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 295.0f, 1440.0f, 582.0f)
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionTopHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f));
    });

    it(@"should calculate a window's CGRect in the bottom half of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionBottomHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f));
    });

    it(@"should calculate a window's CGRect in the bottom 2/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f)
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionBottomHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 582.0f));
    });

    it(@"should calculate a window's CGRect in the bottom 1/3 of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 582.0f)
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionBottomHalf];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
    });

    it(@"should calculate a window's CGRect in the upper left corner of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionUpperLeft];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 441.0f, 720.0f, 436.0f));
    });

    it(@"should calculate a window's CGRect in the lower left corner of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionLowerLeft];

      expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 720.0f, 436.0f));
    });

    it(@"should calculate a window's CGRect in the upper right corner of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionUpperRight];

      expect(result.windowRect).to.equal(CGRectMake(720.0f, 441.0f, 720.0f, 436.0f));
    });

    it(@"should calculate a window's CGRect in the lower right corner of the screen", ^{
      SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                    visibleFrameOfScreen:visibleFrameScreen
                                                                                  action:SpectacleWindowActionLowerRight];

      expect(result.windowRect).to.equal(CGRectMake(720.0f, 4.0f, 720.0f, 436.0f));
    });

    describe(@"next thirds", ^{

      it(@"should calculate a window's CGRect in the first horizontal third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionNextThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 480.0f, 873.0f));
      });

      it(@"should calculate a window's CGRect in the second horizontal third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionNextThird];

        expect(result.windowRect).to.equal(CGRectMake(480.0f, 4.0f, 480.0f, 873.0f));
      });

      it(@"should calculate a window's CGRect in the last horizontal third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(480.0f, 4.0f, 480.0f, 873.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionNextThird];

        expect(result.windowRect).to.equal(CGRectMake(960.0f, 4.0f, 480.0f, 873.0f));
      });

      it(@"should calculate a window's CGRect in the first vertical third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionNextThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f));
      });

      it(@"should calculate a window's CGRect in the second vertical third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionNextThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f));
      });

      it(@"should calculate a window's CGRect in the last vertical third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionNextThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
      });
    });

    describe(@"previous thirds", ^{

      it(@"should calculate a window's CGRect in the first horizontal third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:windowRect
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionPreviousThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 480.0f, 873.0f));
      });

      it(@"should calculate a window's CGRect in the last vertical third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionPreviousThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
      });

      it(@"should calculate a window's CGRect in the second vertical third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionPreviousThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f));
      });

      it(@"should calculate a window's CGRect in the first vertical third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionPreviousThird];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f));
      });

      it(@"should calculate a window's CGRect in the last horizontal third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionPreviousThird];

        expect(result.windowRect).to.equal(CGRectMake(960.0f, 4.0f, 480.0f, 873.0f));
      });

      it(@"should calculate a window's CGRect in the second horizontal third of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)
                                                                      visibleFrameOfScreen:visibleFrameScreen
                                                                                    action:SpectacleWindowActionPreviousThird];

        expect(result.windowRect).to.equal(CGRectMake(480.0f, 4.0f, 480.0f, 873.0f));
      });
    });

    describe(@"make larger", ^{

      it(@"should calculate a window's larger CGRect when centered in the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(360.0f, 222.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(345.0f, 207.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(345.0f, 207.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(330.0f, 192.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(330.0f, 192.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(315.0f, 177.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the top edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(402.0f, 441.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(387.0f, 411.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(387.0f, 411.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(372.0f, 381.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(372.0f, 381.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(357.0f, 351.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the bottom edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(238.0f, 4.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(223.0f, 4.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(223.0f, 4.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(208.0f, 4.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(208.0f, 4.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(193.0f, 4.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the left edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 250.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 235.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 235.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 220.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 220.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 205.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the right edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(720.0f, 303.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(690.0f, 288.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(690.0f, 288.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(660.0f, 273.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(660.0f, 273.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(630.0f, 258.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the top and left edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 441.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 411.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 411.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 381.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 381.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 351.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the top and right edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(720.0f, 441.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(690.0f, 411.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(690.0f, 411.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(660.0f, 381.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(660.0f, 381.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(630.0f, 351.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the bottom and left edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 3.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 4.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 4.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the bottom and right edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(720.0f, 4.0f, 720.0f, 436.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(690.0f, 4.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(690.0f, 4.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(660.0f, 4.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(660.0f, 4.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(630.0f, 4.0f, 810.0f, 526.0f));
      });

      it(@"should calculate a window's larger CGRect when against the top and bottom edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(344.0f, 4.0f, 720.0f, 873.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(329.0f, 4.0f, 750.0f, 873.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(329.0f, 4.0f, 750.0f, 873.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(314.0f, 4.0f, 780.0f, 873.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(314.0f, 4.0f, 780.0f, 873.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(299.0f, 4.0f, 810.0f, 873.0f));
      });

      it(@"should calculate a window's larger CGRect when against the left and right edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 285.0f, 1436.0f, 446.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:1.0 * 30.0f
                                                                                           action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 270.0f, 1440.0f, 476.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 270.0f, 1440.0f, 476.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 255.0f, 1440.0f, 506.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 255.0f, 1440.0f, 506.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionLarger];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 240.0f, 1440.0f, 536.0f));
      });
    });

    describe(@"make smaller", ^{

      it(@"should calculate a window's smaller CGRect when centered in the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(315.0f, 177.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(330.0f, 192.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(330.0f, 192.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(345.0f, 207.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(345.0f, 207.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(360.0f, 222.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the top edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(357.0f, 351.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(372.0f, 381.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(372.0f, 381.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(387.0f, 411.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(387.0f, 411.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(402.0f, 441.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the bottom edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(193.0f, 4.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(208.0f, 4.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(208.0f, 4.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(223.0f, 4.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(223.0f, 4.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(238.0f, 4.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the left edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 205.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 220.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 220.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 235.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 235.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 250.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the right edge of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(630.0f, 258.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(660.0f, 273.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(660.0f, 273.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(690.0f, 288.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(690.0f, 288.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(720.0f, 303.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the top and left edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 351.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 381.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 381.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 411.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 411.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 441.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the top and right edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(630.0f, 351.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(660.0f, 381.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(660.0f, 381.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(690.0f, 411.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(690.0f, 411.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(720.0f, 441.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the bottom and left edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 4.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 4.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 4.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the bottom and right edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(630.0f, 4.0f, 810.0f, 526.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(660.0f, 4.0f, 780.0f, 496.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(660.0f, 4.0f, 780.0f, 496.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(690.0f, 4.0f, 750.0f, 466.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(690.0f, 4.0f, 750.0f, 466.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(720.0f, 4.0f, 720.0f, 436.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the top and bottom edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(299.0f, 4.0f, 810.0f, 873.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(314.0f, 4.0f, 780.0f, 873.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(314.0f, 4.0f, 780.0f, 873.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(329.0f, 4.0f, 750.0f, 873.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(329.0f, 4.0f, 750.0f, 873.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(344.0f, 4.0f, 720.0f, 873.0f));
      });

      it(@"should calculate a window's smaller CGRect when against the left and right edges of the screen", ^{
        SpectacleCalculationResult *result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 240.0f, 1440.0f, 536.0f)
                                                                             visibleFrameOfScreen:visibleFrameScreen
                                                                                       sizeOffset:-1.0 * 30.0f
                                                                                           action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 255.0f, 1440.0f, 506.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 255.0f, 1440.0f, 506.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 270.0f, 1440.0f, 476.0f));

        result = [windowPositionCalculator calculateResizedWindowRect:CGRectMake(0.0f, 270.0f, 1440.0f, 476.0f)
                                                 visibleFrameOfScreen:visibleFrameScreen
                                                           sizeOffset:-1.0 * kWindowSizeOffset
                                                               action:SpectacleWindowActionSmaller];

        expect(result.windowRect).to.equal(CGRectMake(0.0f, 285.0f, 1440.0f, 446.0f));
      });
    });
  });
SpecEnd
