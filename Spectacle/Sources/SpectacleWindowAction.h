#import <Foundation/Foundation.h>

#define MovingToCenterRegionOfDisplay(action) (action == SpectacleWindowActionCenter)

#define MovingToTopRegionOfDisplay(action) \
  ((action == SpectacleWindowActionTopHalf) \
  || (action == SpectacleWindowActionUpperLeft) \
  || (action == SpectacleWindowActionUpperRight))

#define MovingToUpperOrLowerLeftOfDisplay(action) \
  ((action == SpectacleWindowActionUpperLeft) || (action == SpectacleWindowActionLowerLeft))

#define MovingToUpperOrLowerRightDisplay(action) \
  ((action == SpectacleWindowActionUpperRight) || (action == SpectacleWindowActionLowerRight))

#pragma mark -

#define MovingToNextOrPreviousDisplay(action) \
  ((action == SpectacleWindowActionNextDisplay) || (action == SpectacleWindowActionPreviousDisplay))

#pragma mark -

#define MovingToThirdOfDisplay(action) \
  ((action == SpectacleWindowActionNextThird) || (action == SpectacleWindowActionPreviousThird))

typedef NS_ENUM(NSInteger, SpectacleWindowAction) {
  SpectacleWindowActionUndo = -4,
  SpectacleWindowActionRedo,
  SpectacleWindowActionLarger,
  SpectacleWindowActionSmaller,
  SpectacleWindowActionNone,
  SpectacleWindowActionCenter,
  SpectacleWindowActionFullscreen,
  SpectacleWindowActionSetDimensions,
  SpectacleWindowActionLeftHalf,
  SpectacleWindowActionUpperLeft,
  SpectacleWindowActionLowerLeft,
  SpectacleWindowActionRightHalf,
  SpectacleWindowActionUpperRight,
  SpectacleWindowActionLowerRight,
  SpectacleWindowActionTopHalf,
  SpectacleWindowActionBottomHalf,
  SpectacleWindowActionNextDisplay,
  SpectacleWindowActionPreviousDisplay,
  SpectacleWindowActionNextThird,
  SpectacleWindowActionPreviousThird
};
