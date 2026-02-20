import GlanceC
import Orion

var lockscreenWindow: UIWindow?

class SBCoverSheetWindowHook: ClassHook<SBCoverSheetWindow> {
  typealias Group = Hooks
  func didAddSubview(_ subview: UIView) {
    orig.didAddSubview(subview)
    if lockscreenWindow == nil {
      lockscreenWindow = target
    }
  }
}