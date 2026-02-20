import GlanceC
import Orion

extension String {
  func appendToURL(fileURL: URL) throws {
    let data = self.data(using: String.Encoding.utf8)!
    try data.append(fileURL: fileURL)
  }
}
extension Data {
  func append(fileURL: URL) throws {
    if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
      defer {
        fileHandle.closeFile()
      }
      fileHandle.seekToEndOfFile()
      fileHandle.write(self)
    } else {
      try write(to: fileURL, options: .atomic)
    }
  }
}

func writeToLogFile(_ message: String) {
}

func getFocusList() -> [String] {
  let manager = ActivityManager.getManager()
  if manager == nil {
    return ["123:No manager"]
  }
  let activities = manager?._availableActivities()
  if activities == nil {
    return ["123:No activities"]
  }
  let focusList = activities?.map {
    return $0.activityUniqueIdentifier().uuidString + ":" + $0.activityDisplayName()
  }
  return focusList ?? ["123:Some other error"]
}

func getPhotoProviders() -> [String] {
  return contactPhotoProviders.keys.map { $0 }
}

class DistributedCenter: NSObject {
  static let shared = DistributedCenter()
  var distributedCenter: CPDistributedNotificationCenter

  override init() {
    distributedCenter = CPDistributedNotificationCenter(named: "de.janis.glance")!
    super.init()

    distributedCenter.runServer()

    NotificationCenter.default.addObserver(self, selector: #selector(clientDidStartListening), name: NSNotification.Name("CPDistributedNotificationCenterClientDidStartListeningNotification"), object: distributedCenter)
  }

  @objc func clientDidStartListening(_ note: Notification) {
    let center = (note.object as? CPDistributedNotificationCenter)!
    remLog("Trying to post \(center.self)")
    postData()
    remLog("did post")
  }

  func postData() {
    let focusList: [String] = getFocusList()
    distributedCenter.postNotificationName("Data", userInfo: ["focusList": focusList, "photoProviders": getPhotoProviders()])
  }

  func load() {
    remLog("Loaded DistributedCenter")
  }
}