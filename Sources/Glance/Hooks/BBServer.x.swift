import GlanceC
import Orion
import Intents
import Foundation
import CallKit

func isOnCall() -> Bool {
  for call in CXCallObserver().calls {
    if call.hasEnded == false {
      return true
    }
  }
  return false
}

class NotificationHook: ClassHook<NCBulletinNotificationSource> {
  typealias Group = Hooks

  func observer(_ observer: BBObserver, addBulletin bulletin: BBBulletin, forFeed: UInt64, playLightsAndSirens: Bool, withReply: Any) {
    remLog("observer \(observer) \(bulletin) \(forFeed)")
    remLog("playLightsAndSirens \(playLightsAndSirens)")
    remLog("withReply \(withReply)")
    orig.observer(observer, addBulletin: bulletin, forFeed: forFeed, playLightsAndSirens: playLightsAndSirens, withReply: withReply)

    guard bulletin.turnsOnDisplay else { remLog("not turning on display"); return }
    guard !bulletin.isCallNotification() else { remLog("isCallNotification"); return }
    guard !settings.disabledFocus.contains(ActivityManager.getCurrentFocusUUID()) else { return }
    guard settings.isEnabled else { return }
    guard isOnCall() == false else { return }
    guard !isScreenOn() || NotificationView.shared?.showingNotification ?? false else { return }

    let proxy = LSApplicationProxy.applicationProxy(forIdentifier: bulletin.sectionID, placeholder: false) as? LSApplicationProxy
    let notification = GlanceNotification(title: bulletin.title ?? proxy?.atl_fastDisplayName() ?? "No title", message: bulletin.message ?? "No message", appIdentifier: bulletin.sectionID ?? "com.apple.Preferences", context: NSDictionary(dictionary: bulletin.context ?? [:]))
    
    DispatchQueue.main.async {
      NotificationView.shared?.setup()
      NotificationView.shared?.queueNotification(notification: notification)
    }
  }
}