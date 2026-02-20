import GlanceC
import Orion
import SwiftUI
import Foundation
import libroot

typealias PrefData = [String: Any]

let bundlePath = jbRootPath("/Library/Glance/Plugins/ContactPhotoProviders/")

struct Hooks: HookGroup {}

// hooks that only work on iOS >= 15
struct Hooks15: HookGroup {}

class WakeGestureHook: ClassHook<CMWakeGestureManager> {
  func forceDetected() {
    remLog("Force detected")
  }
}

final class Glance: Tweak {
  static func handleError(_ error: OrionHookError) {
    remLog("Error: \(error)")
    DefaultTweak.handleError(error)
  }

  init() {
    Hooks().activate()

    if #available(iOS 15.0, *) {
      Hooks15().activate()
    }

    DispatchQueue.main.asyncAfter(deadline: .now()) {
      reloadPreferences()
      NotificationView.shared = NotificationView(frame: UIScreen.main.bounds)
      loadBundles(atPath: bundlePath)

      let center = CFNotificationCenterGetDarwinNotifyCenter()
      let updateName = "de.janis.glance.prefs/Update" as CFString
      let reloadName = "de.janis.glance.prefs/ReloadBundles" as CFString
      let observer = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())

      CFNotificationCenterAddObserver(center, observer, { center, observer, name, object, userInfo in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
          reloadPreferences()
          NotificationView.shared?.restyleLabels()
          NotificationView.shared?.updateIconSize()
          NotificationView.shared?.updateBlur()
        })
      }, updateName, nil, .deliverImmediately)

      CFNotificationCenterAddObserver(center, observer, { center, observer, name, object, userInfo in
        contactPhotoProviders.removeAll()
        loadBundles(atPath: bundlePath)
        DistributedCenter.shared.postData()
      }, reloadName, nil, .deliverImmediately)

      DistributedCenter.shared.load()
    }
  }
}

func reloadPreferences() {
  do {
    try PreferenceManager.shared.loadSettings()
  } catch {
    remLog("Error: \(error)")
  }
}

func isScreenOn() -> Bool {
  let lockScreenManager = SBLockScreenManager.sharedInstance()
  let isOn: Bool? = Ivars(lockScreenManager!)[safelyAccessing: "_isScreenOn"]
  return isOn ?? true
}

@objc(GlanceSettings) class GlanceSettings: NSObject {
  @objc class func isActive() -> Bool {
    guard settings.isEnabled else { return false }
    guard !settings.disabledFocus.contains(ActivityManager.getCurrentFocusUUID()) else { return false }
    return true
  }
}