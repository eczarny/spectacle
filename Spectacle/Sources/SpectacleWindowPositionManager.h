#import <Cocoa/Cocoa.h>

#import "SpectacleMacros.h"
#import "SpectacleWindowAction.h"

typedef void (^SpectacleFailureFeedback)(void);

@class SpectacleAccessibilityElement;
@class SpectacleScreenDetector;
@class SpectacleShortcut;
@class SpectacleWindowPositionCalculator;

@protocol SpectacleWindowMover;

@interface SpectacleWindowPositionManager : NSObject

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace
                       failureFeedback:(SpectacleFailureFeedback)failureFeedback
                           windowMover:(id<SpectacleWindowMover>)windowMover NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithScreenDetector:(SpectacleScreenDetector *)screenDetector
              windowPositionCalculator:(SpectacleWindowPositionCalculator *)windowPositionCalculator
                       sharedWorkspace:(NSWorkspace *)sharedWorkspace;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction *)action
                           screens:(NSArray<NSScreen *> *)screens
                        mainScreen:(NSScreen *)mainScreen;

- (void)moveFrontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                            action:(SpectacleWindowAction *)action;

- (void)undoLastWindowAction;
- (void)redoLastWindowAction;

typedef enum {
    kCoreDockOrientationTop = 1,
    kCoreDockOrientationBottom = 2,
    kCoreDockOrientationLeft = 3,
    kCoreDockOrientationRight = 4
} CoreDockOrientation;

typedef enum {
    kCoreDockPinningStart = 1,
    kCoreDockPinningMiddle = 2,
    kCoreDockPinningEnd = 3
} CoreDockPinning;

typedef enum {
    kCoreDockEffectGenie = 1,
    kCoreDockEffectScale = 2,
    kCoreDockEffectSuck = 3
} CoreDockEffect;

// Tile size ranges from 0.0 to 1.0.
extern float CoreDockGetTileSize(void);
extern void CoreDockSetTileSize(float tileSize);

extern void CoreDockGetOrientationAndPinning(CoreDockOrientation *outOrientation, CoreDockPinning *outPinning);
// If you only want to set one, use 0 for the other.
extern void CoreDockSetOrientationAndPinning(CoreDockOrientation orientation, CoreDockPinning pinning);

extern void CoreDockGetEffect(CoreDockEffect *outEffect);
extern void CoreDockSetEffect(CoreDockEffect effect);

extern Boolean CoreDockGetAutoHideEnabled(void);
extern void CoreDockSetAutoHideEnabled(Boolean flag);

extern Boolean CoreDockIsMagnificationEnabled(void);
extern void CoreDockSetMagnificationEnabled(Boolean flag);

// Magnification ranges from 0.0 to 1.0.
extern float CoreDockGetMagnificationSize(void);
extern void CoreDockSetMagnificationSize(float newSize);

extern Boolean CoreDockGetWorkspacesEnabled(void);
extern void CoreDockSetWorkspacesEnabled(Boolean); // This works, but wipes out all of the other spaces prefs. An alternative is to use the ScriptingBridge which works just fine.

extern void CoreDockGetWorkspacesCount(int *rows, int *cols);
extern void CoreDockSetWorkspacesCount(int rows, int cols);
@end
