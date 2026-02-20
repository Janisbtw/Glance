import GlanceC
import Orion

var idleTimerController: SBDashBoardIdleTimerController?
var idleTimerProvider: SBDashBoardIdleTimerProvider?

@objc protocol SBIdleTimerCoordinating {
  func setIdleTimerCoordinator(_ coordinator: SBIdleTimerCoordinating)
}

class SBDashBoardIdleTimerControllerHook: ClassHook<SBDashBoardIdleTimerController> {
  typealias Group = Hooks
  
  func setIdleTimerCoordinator(_ coordinator: SBIdleTimerCoordinating) {
    idleTimerController = target
    orig.setIdleTimerCoordinator(coordinator)
  }
}

struct LockScreen {
  static func blockIdleTimer() {
    remLog("blockIdleTimer")
    idleTimerController?.addIdleTimerDisabledAssertionReason("GlanceBlock")
  }

  static func unblockIdleTimer() {
    remLog("unblockIdleTimer")
    idleTimerController?.removeIdleTimerDisabledAssertionReason("GlanceBlock")
  }
}