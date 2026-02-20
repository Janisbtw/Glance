import GlanceC
import Orion

// attempt to fix apple watch stuff
class NSNotificationOptionsHook: ClassHook<NCNotificationOptions> {
  func canTurnOnDisplay() -> Bool {
    return true
  }
}