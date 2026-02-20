import GlanceC
import Orion

var currentFocusUUID = ""

var activityManager: FCActivityManager?

class FCActivityManagerHook: ClassHook<FCActivityManager> {
  typealias Group = Hooks15
  
  func _init(withIdentifier: Any) -> Any {
    let res = orig._init(withIdentifier: withIdentifier)
    activityManager = target
    return res
  }
}

struct ActivityManager {
  static func getManager() -> FCActivityManager? {
    if #available(iOS 15.2, *) {
      return FCActivityManager.shared()
    }
    else if #available(iOS 15.0, *) {
      return activityManager
    }
    else {
      return nil
    }
  }

  static func getCurrentFocusUUID() -> String {
    return getManager()?.activeActivity()?.activityUniqueIdentifier().uuidString ?? "no uuid"
  }
}