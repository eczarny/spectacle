#import "SpectacleWindowPositionCalculator.h"

SpecBegin(SpectacleWindowPositionCalculator)
    describe(@"SpectacleWindowPositionCalculator", ^{
        CGRect visibleFrameScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
        CGRect windowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);

        it(@"should calculate a centered window's CGRect", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionCenter];

            expect(result.windowRect).to.equal(CGRectMake(438.0f, 248.0f, 564.0f, 384.0f));
        });

        it(@"should calculate a fullscreen window's CGRect", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionFullscreen];

            expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f));
        });

        it(@"should calculate a window's CGRect in the left half of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionLeftHalf];

            expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 720.0f, 873.0f));
        });

        it(@"should calculate a window's CGRect in the right half of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionRightHalf];

            expect(result.windowRect).to.equal(CGRectMake(720.0f, 4.0f, 720.0f, 873.0f));
        });

        it(@"should calculate a window's CGRect in the top half of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionTopHalf];

            expect(result.windowRect).to.equal(CGRectMake(0.0f, 441.0f, 1440.0f, 436.0f));
        });

        it(@"should calculate a window's CGRect in the bottom half of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionBottomHalf];

            expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f));
        });

        it(@"should calculate a window's CGRect in the upper left corner of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionUpperLeft];

            expect(result.windowRect).to.equal(CGRectMake(0.0f, 441.0f, 720.0f, 436.0f));
        });

        it(@"should calculate a window's CGRect in the lower left corner of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionLowerLeft];

            expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 720.0f, 436.0f));
        });

        it(@"should calculate a window's CGRect in the upper right corner of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionUpperRight];

            expect(result.windowRect).to.equal(CGRectMake(720.0f, 441.0f, 720.0f, 436.0f));
        });

        it(@"should calculate a window's CGRect in the lower right corner of the screen", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionLowerRight];

            expect(result.windowRect).to.equal(CGRectMake(720.0f, 4.0f, 720.0f, 436.0f));
        });

        describe(@"next thirds", ^{

            it(@"should calculate a window's CGRect in the first horizontal third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionNextThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 480.0f, 873.0f));
            });

            it(@"should calculate a window's CGRect in the second horizontal third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionNextThird];

                expect(result.windowRect).to.equal(CGRectMake(480.0f, 4.0f, 480.0f, 873.0f));
            });

            it(@"should calculate a window's CGRect in the last horizontal third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(480.0f, 4.0f, 480.0f, 873.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionNextThird];

                expect(result.windowRect).to.equal(CGRectMake(960.0f, 4.0f, 480.0f, 873.0f));
            });

            it(@"should calculate a window's CGRect in the first vertical third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionNextThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f));
            });

            it(@"should calculate a window's CGRect in the second vertical third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionNextThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f));
            });

            it(@"should calculate a window's CGRect in the last vertical third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionNextThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
            });
        });

        describe(@"previous thirds", ^{

            it(@"should calculate a window's CGRect in the first horizontal third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionPreviousThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 480.0f, 873.0f));
            });

            it(@"should calculate a window's CGRect in the last vertical third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionPreviousThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
            });

            it(@"should calculate a window's CGRect in the second vertical third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionPreviousThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f));
            });

            it(@"should calculate a window's CGRect in the first vertical third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionPreviousThird];

                expect(result.windowRect).to.equal(CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f));
            });

            it(@"should calculate a window's CGRect in the last horizontal third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionPreviousThird];

                expect(result.windowRect).to.equal(CGRectMake(960.0f, 4.0f, 480.0f, 873.0f));
            });

            it(@"should calculate a window's CGRect in the second horizontal third of the screen", ^{
                SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)
                                                                                       visibleFrameOfScreen: visibleFrameScreen
                                                                                                     action: SpectacleWindowActionPreviousThird];

                expect(result.windowRect).to.equal(CGRectMake(480.0f, 4.0f, 480.0f, 873.0f));
            });
        });
    });
SpecEnd
