import GlanceC
import Orion

var userAgent: SBUserAgent?

class SBUserAgentHook: ClassHook<SBUserAgent> {
  typealias Group = Hooks
  
  func `init`() -> Target {
    let result = orig.`init`()
    userAgent = target
    return result
  }
}

struct UserAgent {
  static func lockDevice() {
    userAgent?.lockAndDimDevice()
  }
}