import GlanceC
import Orion

var currentOrientation: Int64 = 0

class UIDeviceHook: ClassHook<UIDevice> {
  typealias Group = Hooks
  
  func setOrientation(_ orientation: Int64, animated: Bool) {
    remLog("setOrientation \(orientation) animated \(animated)")
    orig.setOrientation(orientation, animated: animated)
    remLog("currentOrientation \(currentOrientation) -> \(orientation)")
    if currentOrientation == 5 && orientation != 5 && NotificationView.shared?.showingNotification ?? false {
      NotificationView.shared?.forceClose()
    }
    currentOrientation = orientation
  }
}
