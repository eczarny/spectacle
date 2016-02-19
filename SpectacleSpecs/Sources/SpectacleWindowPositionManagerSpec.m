#import "SpectacleAccessibilityElement.h"
#import "SpectacleCalculationResult.h"
#import "SpectacleScreenDetector.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionManager.h"

SpecBegin(SpectacleWindowPositionManager)
  describe(@"SpectacleWindowPositionManager", ^{
    CGRect frameOfScreen = CGRectMake(0.0f, 0.0f, 1440.0f, 900.0f);
    CGRect visibleFrameOfScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
    CGRect frontmostWindowRect = CGRectMake(165.0f, 245.0f, 564.0f, 384.0f);

    __block NSScreen *mockMainScreen;
    __block SpectacleScreenDetector *mockScreenDetector;
    __block SpectacleWindowPositionCalculator *mockWindowPositionCalculator;
    __block NSWorkspace *mockSharedWorkspace;
    __block NSRunningApplication *mockFrontmostApplication;
    __block SpectacleWindowPositionManager *windowPositionManager;
    __block SpectacleCalculationResult *mockCalculationResult;

    beforeEach(^{
      mockMainScreen = mock([NSScreen class]);
      mockScreenDetector = mock([SpectacleScreenDetector class]);
      mockWindowPositionCalculator = mock([SpectacleWindowPositionCalculator class]);
      mockSharedWorkspace = mock([NSWorkspace class]);
      mockFrontmostApplication = mock([NSRunningApplication class]);
      mockCalculationResult = mock([SpectacleCalculationResult class]);

      [given([mockMainScreen frame]) willReturnStruct:&frameOfScreen objCType:@encode(NSRect)];
      [given([mockMainScreen visibleFrame]) willReturnStruct:&visibleFrameOfScreen objCType:@encode(NSRect)];

      MKTOngoingStubbing *ongoingWindowPositionCalculatorStubbing =
        given([mockWindowPositionCalculator calculateWindowRect:CGRectNull
                                           visibleFrameOfScreen:CGRectNull
                                                         action:SpectacleWindowActionNone]);

      ongoingWindowPositionCalculatorStubbing = [ongoingWindowPositionCalculatorStubbing withMatcher:anything()
                                                                                         forArgument:0];

      ongoingWindowPositionCalculatorStubbing = [ongoingWindowPositionCalculatorStubbing withMatcher:anything()
                                                                                         forArgument:1];

      ongoingWindowPositionCalculatorStubbing = [ongoingWindowPositionCalculatorStubbing withMatcher:anything()
                                                                                         forArgument:2];

      [ongoingWindowPositionCalculatorStubbing willReturn:mockCalculationResult];

      MKTOngoingStubbing *ongoingScreenDetectorStubbing =
        given([mockScreenDetector screenWithAction:SpectacleWindowActionNone
                            frontmostWindowElement:anything()
                                           screens:anything()
                                        mainScreen:anything()]);

      ongoingScreenDetectorStubbing = [ongoingScreenDetectorStubbing withMatcher:anything()
                                                                     forArgument:0];

      ongoingScreenDetectorStubbing = [ongoingScreenDetectorStubbing withMatcher:anything()
                                                                     forArgument:1];

      [ongoingScreenDetectorStubbing willReturn:mockMainScreen];

      [given([mockFrontmostApplication bundleIdentifier]) willReturn:@"com.divisiblebyzero.SpectacleSpecs"];

      [given([mockSharedWorkspace frontmostApplication]) willReturn:mockFrontmostApplication];

      windowPositionManager = [[SpectacleWindowPositionManager alloc] initWithScreenDetector:mockScreenDetector
                                                                    windowPositionCalculator:mockWindowPositionCalculator
                                                                             sharedWorkspace:mockSharedWorkspace
                                                                             failureFeedback:^() {}
                                                                                 windowMover:nil];
    });

    it(@"should do nothing if the frontmost window is a sheet", ^{
      SpectacleAccessibilityElement *mockAccessibilityElemenet = mock([SpectacleAccessibilityElement class]);

      [given([mockAccessibilityElemenet rectOfElement]) willReturnStruct:&frontmostWindowRect objCType:@encode(CGRect)];
      [given([mockAccessibilityElemenet isSheet]) willReturnBool:YES];

      [windowPositionManager moveFrontmostWindowElement:mockAccessibilityElemenet
                                                 action:SpectacleWindowActionNone
                                                screens:@[mockMainScreen]
                                             mainScreen:mockMainScreen];

      [verify(mockAccessibilityElemenet) rectOfElement];
      [verify(mockAccessibilityElemenet) isSheet];
      [verifyCount(mockAccessibilityElemenet, never()) isSystemDialog];

      [verifyCount(mockWindowPositionCalculator, never()) calculateWindowRect:CGRectNull
                                                         visibleFrameOfScreen:CGRectNull
                                                                       action:SpectacleWindowActionNone];
    });

    it(@"should do nothing if the frontmost window is a system dialog", ^{
      SpectacleAccessibilityElement *mockAccessibilityElemenet = mock([SpectacleAccessibilityElement class]);

      [given([mockAccessibilityElemenet rectOfElement]) willReturnStruct:&frontmostWindowRect objCType:@encode(CGRect)];
      [given([mockAccessibilityElemenet isSheet]) willReturnBool:NO];
      [given([mockAccessibilityElemenet isSystemDialog]) willReturnBool:YES];

      [windowPositionManager moveFrontmostWindowElement:mockAccessibilityElemenet
                                                 action:SpectacleWindowActionNone
                                                screens:@[mockMainScreen]
                                             mainScreen:mockMainScreen];

      [verify(mockAccessibilityElemenet) rectOfElement];
      [verify(mockAccessibilityElemenet) isSheet];
      [verify(mockAccessibilityElemenet) isSystemDialog];

      [verifyCount(mockWindowPositionCalculator, never()) calculateWindowRect:CGRectNull
                                                         visibleFrameOfScreen:CGRectNull
                                                                       action:SpectacleWindowActionNone];
    });

    it(@"should do nothing if the frontmost window rect is unavailable", ^{
      SpectacleAccessibilityElement *mockAccessibilityElemenet = mock([SpectacleAccessibilityElement class]);

      [given([mockAccessibilityElemenet rectOfElement]) willReturnStruct:&CGRectNull objCType:@encode(CGRect)];
      [given([mockAccessibilityElemenet isSheet]) willReturnBool:NO];
      [given([mockAccessibilityElemenet isSystemDialog]) willReturnBool:YES];

      [windowPositionManager moveFrontmostWindowElement:mockAccessibilityElemenet
                                                 action:SpectacleWindowActionNone
                                                screens:@[mockMainScreen]
                                             mainScreen:mockMainScreen];

      [verify(mockAccessibilityElemenet) rectOfElement];
      [verify(mockAccessibilityElemenet) isSheet];
      [verify(mockAccessibilityElemenet) isSystemDialog];

      [verifyCount(mockWindowPositionCalculator, never()) calculateWindowRect:CGRectNull
                                                         visibleFrameOfScreen:CGRectNull
                                                                       action:SpectacleWindowActionNone];
    });

    it(@"should do nothing if screen detection fails", ^{
      SpectacleAccessibilityElement *mockAccessibilityElemenet = mock([SpectacleAccessibilityElement class]);

      [given([mockAccessibilityElemenet rectOfElement]) willReturnStruct:&frontmostWindowRect
                                                                                               objCType:@encode(CGRect)];
      [given([mockAccessibilityElemenet isSheet]) willReturnBool:NO];
      [given([mockAccessibilityElemenet isSystemDialog]) willReturnBool:YES];

      [given([mockScreenDetector screenWithAction:SpectacleWindowActionCenter
                           frontmostWindowElement:anything()
                                          screens:anything()
                                       mainScreen:anything()]) willReturn:nil];

      [windowPositionManager moveFrontmostWindowElement:mockAccessibilityElemenet
                                                 action:SpectacleWindowActionNone
                                                screens:@[mockMainScreen]
                                             mainScreen:mockMainScreen];

      [verify(mockAccessibilityElemenet) rectOfElement];
      [verify(mockAccessibilityElemenet) isSheet];
      [verify(mockAccessibilityElemenet) isSystemDialog];

      [verifyCount(mockWindowPositionCalculator, never()) calculateWindowRect:CGRectNull
                                                         visibleFrameOfScreen:CGRectNull
                                                                       action:SpectacleWindowActionNone];
    });

    it(@"should do nothing if the window position calculation returns the same results", ^{
      SpectacleAccessibilityElement *mockAccessibilityElemenet = mock([SpectacleAccessibilityElement class]);

      [given([mockAccessibilityElemenet rectOfElement]) willReturnStruct:&frontmostWindowRect objCType:@encode(CGRect)];
      [given([mockAccessibilityElemenet isSheet]) willReturnBool:NO];
      [given([mockAccessibilityElemenet isSystemDialog]) willReturnBool:NO];

      [given([mockCalculationResult action]) willReturnInteger:SpectacleWindowActionCenter];

      CGRect flippedFrontmostWindowRect = frontmostWindowRect;

      [given([mockCalculationResult windowRect]) willReturnStruct:&flippedFrontmostWindowRect objCType:@encode(CGRect)];

      [windowPositionManager moveFrontmostWindowElement:mockAccessibilityElemenet
                                                 action:SpectacleWindowActionCenter
                                                screens:@[mockMainScreen]
                                             mainScreen:mockMainScreen];

      [(SpectacleCalculationResult *)verify(mockCalculationResult) action];
      [verify(mockCalculationResult) windowRect];

      [[verifyCount(mockAccessibilityElemenet, never()) withMatcher:anything()] setRectOfElement:CGRectNull];
    });
  });
SpecEnd
