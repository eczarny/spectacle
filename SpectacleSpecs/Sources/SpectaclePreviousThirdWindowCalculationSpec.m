#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

SpecBegin(SpectaclePreviousThirdWindowCalculation)
describe(@"SpectaclePreviousThirdWindowCalculation", ^{
  CGRect visibleFrameSourceScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  CGRect visibleFrameDestinationScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  SpectacleWindowPositionCalculator *windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
    EXP_failure(message);
  }];

  it(@"should calculate a window's CGRect in the first horizontal third of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionPreviousThird];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 480.0f, 873.0f));
  });

  it(@"should calculate a window's CGRect in the last vertical third of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 480.0f, 873.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionPreviousThird];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
  });

  it(@"should calculate a window's CGRect in the second vertical third of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionPreviousThird];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f));
  });

  it(@"should calculate a window's CGRect in the first vertical third of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 295.0f, 1440.0f, 291.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionPreviousThird];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f));
  });

  it(@"should calculate a window's CGRect in the last horizontal third of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionPreviousThird];
    expect(result.windowRect).to.equal(CGRectMake(960.0f, 4.0f, 480.0f, 873.0f));
  });

  it(@"should calculate a window's CGRect in the second horizontal third of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(960.0f, 4.0f, 480.0f, 873.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionPreviousThird];
    expect(result.windowRect).to.equal(CGRectMake(480.0f, 4.0f, 480.0f, 873.0f));
  });
});
SpecEnd
