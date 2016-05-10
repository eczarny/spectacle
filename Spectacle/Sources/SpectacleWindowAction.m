#import "SpectacleWindowAction.h"

SpectacleWindowAction *const kSpectacleWindowActionUndo = @"SpectacleWindowActionUndo";
SpectacleWindowAction *const kSpectacleWindowActionRedo = @"SpectacleWindowActionRedo";
SpectacleWindowAction *const kSpectacleWindowActionLarger = @"SpectacleWindowActionLarger";
SpectacleWindowAction *const kSpectacleWindowActionSmaller = @"SpectacleWindowActionSmaller";
SpectacleWindowAction *const kSpectacleWindowActionNone = @"SpectacleWindowActionNone";
SpectacleWindowAction *const kSpectacleWindowActionCenter = @"SpectacleWindowActionCenter";
SpectacleWindowAction *const kSpectacleWindowActionFullscreen = @"SpectacleWindowActionFullscreen";
SpectacleWindowAction *const kSpectacleWindowActionLeftHalf = @"SpectacleWindowActionLeftHalf";
SpectacleWindowAction *const kSpectacleWindowActionUpperLeft = @"SpectacleWindowActionUpperLeft";
SpectacleWindowAction *const kSpectacleWindowActionLowerLeft = @"SpectacleWindowActionLowerLeft";
SpectacleWindowAction *const kSpectacleWindowActionRightHalf = @"SpectacleWindowActionRightHalf";
SpectacleWindowAction *const kSpectacleWindowActionUpperRight = @"SpectacleWindowActionUpperRight";
SpectacleWindowAction *const kSpectacleWindowActionLowerRight = @"SpectacleWindowActionLowerRight";
SpectacleWindowAction *const kSpectacleWindowActionUpperThirdRight = @"SpectacleWindowActionUpperThirdRight";
SpectacleWindowAction *const kSpectacleWindowActionMiddleThirdRight = @"SpectacleWindowActionMiddleThirdRight";
SpectacleWindowAction *const kSpectacleWindowActionLowerThirdRight = @"SpectacleWindowActionLowerThirdRight";
SpectacleWindowAction *const kSpectacleWindowActionUpperThirdLeft = @"SpectacleWindowActionUpperThirdLeft";
SpectacleWindowAction *const kSpectacleWindowActionMiddleThirdLeft = @"SpectacleWindowActionMiddleThirdLeft";
SpectacleWindowAction *const kSpectacleWindowActionLowerThirdLeft = @"SpectacleWindowActionLowerThirdLeft";
SpectacleWindowAction *const kSpectacleWindowActionTopHalf = @"SpectacleWindowActionTopHalf";
SpectacleWindowAction *const kSpectacleWindowActionBottomHalf = @"SpectacleWindowActionBottomHalf";
SpectacleWindowAction *const kSpectacleWindowActionNextDisplay = @"SpectacleWindowActionNextDisplay";
SpectacleWindowAction *const kSpectacleWindowActionPreviousDisplay = @"SpectacleWindowActionPreviousDisplay";
SpectacleWindowAction *const kSpectacleWindowActionNextThird = @"SpectacleWindowActionNextThird";
SpectacleWindowAction *const kSpectacleWindowActionPreviousThird = @"SpectacleWindowActionPreviousThird";

extern BOOL SpectacleIsUndoWindowAction(SpectacleWindowAction *action)
{
  return [action isEqualToString:kSpectacleWindowActionUndo];
}

extern BOOL SpectacleIsRedoWindowAction(SpectacleWindowAction *action)
{
  return [action isEqualToString:kSpectacleWindowActionRedo];
}

BOOL SpectacleIsNextDisplayWindowAction(SpectacleWindowAction *action)
{
  return [action isEqualToString:kSpectacleWindowActionNextDisplay];
}

BOOL SpectacleIsPreviousDisplayWindowAction(SpectacleWindowAction *action)
{
  return [action isEqualToString:kSpectacleWindowActionPreviousDisplay];
}

BOOL SpectacleIsMovingToDisplayWindowAction(SpectacleWindowAction *action)
{
  return SpectacleIsNextDisplayWindowAction(action) || SpectacleIsPreviousDisplayWindowAction(action);
}
