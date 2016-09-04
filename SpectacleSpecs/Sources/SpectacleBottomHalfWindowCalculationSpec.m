#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

SpecBegin(SpectacleBottomHalfWindowCalculation)
describe(@"SpectacleBottomHalfWindowCalculation", ^{
  CGRect visibleFrameSourceScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  CGRect visibleFrameDestinationScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  SpectacleWindowPositionCalculator *windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
    EXP_failure(message);
  }];

  it(@"should calculate a window's CGRect in the bottom half of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionBottomHalf];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f));
  });

  it(@"should calculate a window's CGRect in the bottom 2/3 of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 436.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionBottomHalf];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 582.0f));
  });

  it(@"should calculate a window's CGRect in the bottom 1/3 of the screen", ^{
    SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 4.0f, 1440.0f, 582.0f)
                                                                          visibleFrameOfSourceScreen:visibleFrameSourceScreen
                                                                     visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
                                                                                              action:kSpectacleWindowActionBottomHalf];
    expect(result.windowRect).to.equal(CGRectMake(0.0f, 4.0f, 1440.0f, 291.0f));
  });
});
SpecEnd
