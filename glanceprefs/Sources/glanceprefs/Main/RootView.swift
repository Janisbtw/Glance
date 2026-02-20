import SwiftUI
import Comet
import libroot

let credits = [
  "rugmj": "https://github.com/rugmj",
  "Leptos": "https://github.com/leptos-null",
  "Lightmann": "https://github.com/L1ghtmann",
  "Luki120": "https://github.com/Luki120",
  "yan": "https://github.com/yandevelop",
  "Nightwind": "https://github.com/NightwindDev"
]

@available(iOS 14.0, *)
struct RootView: View {
  @StateObject private var preferenceStorage = PreferenceStorage()

  @State private var isLoading = false

  var body: some View {
    Form {
      HeaderView()
      Section {
        Toggle(getLocalizedString("ENABLED"), isOn: $preferenceStorage.isEnabled)
        .foregroundColor(preferenceStorage.isEnabled ? .primary : .secondary)

        Toggle(getLocalizedString("HIDE_STATUS_BAR"), isOn: $preferenceStorage.hideStatusBar)
        if #available(iOS 15.0, *) {
          NavigationLink(getLocalizedString("FOCUS_SETTINGS")) {
            SelectFocusView(preferenceStorage: preferenceStorage)
          }
        }
        NavigationLink(getLocalizedString("LOADED_PHOTO_PROVIDERS")) {
          BundleList()
        }
      } header: {
        Text(getLocalizedString("GENERAL"))
      }

      Section {
        VStack(alignment: .leading) {
          Text(getLocalizedString("ICON_SIZE"))
          HStack {
            Slider(value: $preferenceStorage.iconSize, in: 50...200, step: 1)
            Text(String.init(preferenceStorage.iconSize) + "px")
          }
        }
        Toggle(getLocalizedString("SHOW_APP_ICON_AND_PROFILE_PICTURE"), isOn: $preferenceStorage.showIcon)
        Toggle(getLocalizedString("SHOW_NOTIFICATION_TITLE"), isOn: $preferenceStorage.showTitle)
        Toggle(getLocalizedString("SHOW_NOTIFICATION_CONTENT"), isOn: $preferenceStorage.showContent)
        Toggle(getLocalizedString("LOCK_AFTER_GLANCE"), isOn: $preferenceStorage.lockAfter)
        Toggle(getLocalizedString("ADJUST_BRIGHTNESS"), isOn: $preferenceStorage.adjustBrightness)
        if(preferenceStorage.adjustBrightness) {
          HStack {
            Slider(value: $preferenceStorage.brightnessLevel, in: 0...100, step: 1)
            Text(String.init(preferenceStorage.brightnessLevel) + "%")
          }
        }
        Toggle(getLocalizedString("BLACKOUT"), isOn: $preferenceStorage.blackout)
      } header: {
        Text(getLocalizedString("APPEARANCE"))
      } footer: {
        Text(getLocalizedString("DISABLING_BLACKOUT_BLUR_INSTEAD"))
      }

      Section {
        Toggle(getLocalizedString("COLORED_TITLE"), isOn: $preferenceStorage.coloredTitle)
        Toggle(getLocalizedString("COLORED_CONTENT"), isOn: $preferenceStorage.coloredContent)
        if preferenceStorage.coloredTitle || preferenceStorage.coloredContent {
          Picker(getLocalizedString("COLOR"), selection: $preferenceStorage.colorBasedOnProfilePicture) {
            Text(getLocalizedString("APP_ICON")).tag(false)
            Text(getLocalizedString("PROFILE_PICTURE_APP_ICON")).tag(true)
          }.pickerStyle(.segmented)
        }
      } header: {
        Text(getLocalizedString("COLOR"))
      }

      Section {
        Group {
          Text(getLocalizedString("TITLE_FONT_SIZE"))
          Picker("Title Font Size", selection: $preferenceStorage.titleFontSize) {
            Text("12px").tag(12)
            Text("16px").tag(16)
            Text("20px").tag(20)
            Text("24px").tag(24)
            Text("28px").tag(28)
          }.pickerStyle(.segmented)

          Text(getLocalizedString("TITLE_FONT_WEIGHT"))
          Picker("Title Font Weight", selection: $preferenceStorage.titleFontWeight) {
            Text(getLocalizedString("REGULAR")).tag("regular")
            Text(getLocalizedString("BOLD")).tag("bold")
            Text(getLocalizedString("HEAVY")).tag("heavy")
            Text(getLocalizedString("BLACK")).tag("black")
          }.pickerStyle(.segmented)
        }

        Group {
          Text(getLocalizedString("CONTENT_FONT_SIZE"))
          Picker("Content Font Size", selection: $preferenceStorage.contentFontSize) {
            Text("8px").tag(8)
            Text("12px").tag(12)
            Text("16px").tag(16)
            Text("20px").tag(20)
          }.pickerStyle(.segmented)

          Text(getLocalizedString("CONTENT_FONT_WEIGHT"))
          Picker("Content Font Weight", selection: $preferenceStorage.contentFontWeight) {
            Text(getLocalizedString("THIN")).tag("thin")
            Text(getLocalizedString("LIGHT")).tag("light")
            Text(getLocalizedString("REGULAR")).tag("regular")
            Text(getLocalizedString("BOLD")).tag("bold")
          }.pickerStyle(.segmented)
        }
      } header: {
        Text(getLocalizedString("FONT"))
      }

      if !preferenceStorage.blackout {
        Section {
          VStack {
            VStack(alignment: .leading) {
              Text(getLocalizedString("BLUR_INTENSITY"))
              HStack {
                Slider(value: $preferenceStorage.blurIntensity, in: 0...100, step: 1.0)
                Text(String.init(preferenceStorage.blurIntensity) + "%")
              }
            }
          }
        } header: {
          Text(getLocalizedString("EFFECTS"))
        }
      }

      Section {
        VStack {
          VStack(alignment: .leading) {
            Text(getLocalizedString("DISPLAY_DURATION"))
            HStack {
              Slider(value: $preferenceStorage.animationDuration, in: 0...10, step: 0.5)
              Text(String.init(preferenceStorage.animationDuration) + "s")
            }
          }

          Divider()

          VStack(alignment: .leading) {
            Text(getLocalizedString("OPEN_CLOSE_DURATION"))
            HStack {
              Slider(value: $preferenceStorage.openClose, in: 0...10, step: 1)
              Text(String.init(preferenceStorage.openClose / 10) + "s")
            }
          }

          Divider()

          VStack(alignment: .leading) {
            Text(getLocalizedString("FADE_IN_OUT_DURATION"))
            HStack {
              Slider(value: $preferenceStorage.fadeInOut, in: 0...10, step: 1)
              Text(String.init(preferenceStorage.fadeInOut / 10) + "s")
            }
          }
        }
      } header: {
        Text(getLocalizedString("ANIMATIONS"))
      }

      Section {
        ForEach(credits.sorted(by: <), id: \.key) { key, value in
          Link(key, destination: URL(string: value)!)
        }
      } header: {
        Text("Credits")
      }
    }
  }
}


