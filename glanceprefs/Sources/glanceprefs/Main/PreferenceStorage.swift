import Foundation
import Comet
import libroot
import Combine

// MARK: - Internal

var verified = false

@available(iOS 13.0, *)
final class PreferenceStorage: ObservableObject {
    private static let registry: String = jbRootPath("/var/mobile/Library/Preferences/de.janis.glance.prefs.plist")
    /// Welcome to Comet
    /// By @ginsudev
    ///
    /// Mark your preferences with `@Published(key: "someKey", registry: PreferenceStorage.registry)`.
    /// When the value of these properties are changed, they are also saved into the preferences file on disk to persist changes.
    ///
    /// The initial value you initialise your property with is the fallback / default value that will be used if there is no present value for the
    /// given key.
    ///
    /// `@Published(key: _ registry:_)` properties can only store Foundational types that conform
    /// to `Codable` (i.e. `String, Data, Int, Bool, Double, Float`, etc).

    // Preferences
    @Published(key: "isEnabled", registry: registry) var isEnabled = false
    @Published(key: "hideStatusBar", registry: registry) var hideStatusBar = true
    @Published(key: "disabledFocus", registry: registry) var disabledFocus = [] as [String]

    @Published(key: "showIcon", registry: registry) var showIcon = true
    @Published(key: "showTitle", registry: registry) var showTitle = true
    @Published(key: "showContent", registry: registry) var showContent = true
    @Published(key: "lockAfter", registry: registry) var lockAfter = true
    @Published(key: "adjustBrightness", registry: registry) var adjustBrightness = true
    @Published(key: "brightnessLevel", registry: registry) var brightnessLevel: Double = 100
    @Published(key: "blackout", registry: registry) var blackout = true

    @Published(key: "iconSize", registry: registry) var iconSize: Double = 100
    @Published(key: "titleFontSize", registry: registry) var titleFontSize = 20
    @Published(key: "titleFontWeight", registry: registry) var titleFontWeight = "bold"
    @Published(key: "coloredTitle", registry: registry) var coloredTitle = true
    @Published(key: "contentFontSize", registry: registry) var contentFontSize = 16
    @Published(key: "contentFontWeight", registry: registry) var contentFontWeight = "light"
    @Published(key: "coloredContent", registry: registry) var coloredContent = false
    @Published(key: "colorBasedOnProfilePicture", registry: registry) var colorBasedOnProfilePicture = false

    @Published(key: "animationDuration", registry: registry) var animationDuration: Double = 5
    @Published(key: "openClose", registry: registry) var openClose: Double = 5
    @Published(key: "fadeInOut", registry: registry) var fadeInOut: Double = 2

    @Published(key: "blurIntensity", registry: registry) var blurIntensity: Double = 100

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
      self.objectWillChange
        .sink { _ in
          let center = CFNotificationCenterGetDarwinNotifyCenter()
          let name = "de.janis.glance.prefs/Update" as CFString
          let object = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
          CFNotificationCenterPostNotification(center, .init(name), object, nil, true)
        }
        .store(in: &cancellables)
    }
}
