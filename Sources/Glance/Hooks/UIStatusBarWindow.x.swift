import GlanceC
import Orion

var statusBarWindow: UIStatusBarWindow?

class StatusBarHook: ClassHook<UIStatusBarWindow> {
  typealias Group = Hooks
  
  func setStatusBar(_ statusBar: Any) {
    remLog(statusBar.self)
    statusBarWindow = target
    orig.setStatusBar(statusBar)
  }
}
struct StatusBar {
  static func hide() {
    statusBarWindow?.isHidden = true
  }

  static func show() {
    statusBarWindow?.isHidden = false
  }
}