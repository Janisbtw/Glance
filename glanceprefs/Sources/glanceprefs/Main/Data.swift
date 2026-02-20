import Comet
import CoreFoundation
import glanceprefsC
import SwiftUI

typealias PrefData = [String: [String]]

class Data: ObservableObject {
  static var shared = Data()

  @Published var userInfo: PrefData? = nil

  var center: CPDistributedNotificationCenter

  init() {
    center = CPDistributedNotificationCenter(named: "de.janis.glance")
    center.startDeliveringNotificationsToMainThread()
    NotificationCenter.default.addObserver(self, selector: #selector(gotData), name: Notification.Name("Data"), object: nil)
  }

  @objc func gotData(_ note: Notification) {
    self.userInfo = note.userInfo as? PrefData
    objectWillChange.send()
  }

  func load() {
    remLog("...")
    // Empty function to get it to load before tapping on focus
  }
}