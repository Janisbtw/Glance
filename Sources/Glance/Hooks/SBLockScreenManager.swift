import GlanceC
import Orion

class SBLockScreenManagerHook: ClassHook<SBLockScreenManager> {
  typealias Group = Hooks
  
  func lockUI(fromSource source: UInt) {
    remLog("lockUIFromSource")
    orig.lockUI(fromSource: source)
  }
}

struct Screen {
  static func turnOn() {
    remLog("Turning on screen")
    (SpringBoard.shared as! SpringBoard)._turnScreenOnOnDashBoard(withCompletion: nil)
  }
}