import GlanceC

class NotificationViewController: UIViewController {
  // Allow NotificationViewController to be visible while device is locked
  override func _canShowWhileLocked() -> Bool {
    return true
  }
}
