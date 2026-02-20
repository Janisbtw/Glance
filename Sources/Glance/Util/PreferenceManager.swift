import libroot
import Foundation

var settings: Settings = Settings()

final class PreferenceManager {
  static let shared = PreferenceManager()

  private let preferencesFilePath = jbRootPath("/var/mobile/Library/Preferences/de.janis.glance.prefs.plist")

  func loadSettings() throws {
    if let data = FileManager.default.contents(atPath: preferencesFilePath) {
      do {
        remLog("Loading settings")
        settings = try PropertyListDecoder().decode(Settings.self, from: data)
      }
      catch {
        remLog("Error: \(error)")
        settings = Settings()
      }
    } else {
      settings = Settings()
    }
    // Divide by 10 to avoid weird double (float) behavior when using a slider in the settings
    // The slider has a range of 0 to 10, but it should be 0 to 1
    // The user only sees the corrected value of 0 to 1
    settings.openClose = settings.openClose / 10
    settings.fadeInOut = settings.fadeInOut / 10

    // Same as above, but scaled up by 100
    settings.blurIntensity = settings.blurIntensity / 100
  }
}

class Settings: Codable {
  var isEnabled: Bool = false
  var hideStatusBar: Bool = true
  var disabledFocus: [String] = []

  var showIcon: Bool = true
  var showTitle: Bool = true
  var showContent: Bool = true
  var lockAfter: Bool = true
  var adjustBrightness: Bool = true
  var brightnessLevel: Double = 100
  var blackout: Bool = true

  var iconSize: Int = 100
  var titleFontSize: Int = 20
  var titleFontWeight: String = "bold"
  var coloredTitle: Bool = true
  var contentFontSize: Int = 16
  var contentFontWeight: String = "light"
  var coloredContent: Bool = false
  var colorBasedOnProfilePicture: Bool = false

  var animationDuration: Double = 5.0
  var openClose: Double = 5.0
  var fadeInOut: Double = 2.0

  var blurIntensity: Double = 100.0

  init() {}

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
    self.hideStatusBar = try container.decode(Bool.self, forKey: .hideStatusBar)
    self.disabledFocus = try container.decode([String].self, forKey: .disabledFocus)

    self.showContent = try container.decode(Bool.self, forKey: .showContent)
    self.showIcon = try container.decode(Bool.self, forKey: .showIcon)
    self.showTitle = try container.decode(Bool.self, forKey: .showTitle)
    self.lockAfter = try container.decode(Bool.self, forKey: .lockAfter)
    self.adjustBrightness = try container.decode(Bool.self, forKey: .adjustBrightness)
    self.brightnessLevel = try container.decode(Double.self, forKey: .brightnessLevel)
    self.blackout = try container.decode(Bool.self, forKey: .blackout)

    self.iconSize = try container.decode(Int.self, forKey: .iconSize)
    self.titleFontSize = try container.decode(Int.self, forKey: .titleFontSize)
    self.titleFontWeight = try container.decode(String.self, forKey: .titleFontWeight)
    self.coloredTitle = try container.decode(Bool.self, forKey: .coloredTitle)
    self.contentFontSize = try container.decode(Int.self, forKey: .contentFontSize)
    self.contentFontWeight = try container.decode(String.self, forKey: .contentFontWeight)
    self.coloredContent = try container.decode(Bool.self, forKey: .coloredContent)
    self.colorBasedOnProfilePicture = try container.decode(Bool.self, forKey: .colorBasedOnProfilePicture)

    self.animationDuration = try container.decode(Double.self, forKey: .animationDuration)
    self.openClose = try container.decode(Double.self, forKey: .openClose)
    self.fadeInOut = try container.decode(Double.self, forKey: .fadeInOut)

    self.blurIntensity = try container.decode(Double.self, forKey: .blurIntensity)
  }
}