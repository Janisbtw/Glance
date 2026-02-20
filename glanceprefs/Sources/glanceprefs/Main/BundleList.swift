import SwiftUI
import Comet
import glanceprefsC

struct BundleList: View {
  @EnvironmentObject var preferenceStorage: PreferenceStorage
  @ObservedObject var data = Data.shared

  var body: some View {
    Form {
      Section {
        if((data.userInfo?["photoProviders"] as? [String] ?? []).count == 0) {
          Text(getLocalizedString("NO_BUNDLES_FOUND"))
        }
        else {
          List {
            ForEach(data.userInfo?["photoProviders"] as? [String] ?? [], id: \.self) { bundle in
              Label {
                Text(bundle)
              } icon: {
                Image(uiImage: UIImage._applicationIconImage(forBundleIdentifier: bundle, format: 0, scale: 0))
              }
            }
          }
        }
      } header: {
        Text(getLocalizedString("PROVIDERS"))
      }
      Button(getLocalizedString("RELOAD")) {
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let name = "de.janis.glance.prefs/ReloadBundles" as CFString
        CFNotificationCenterPostNotification(center, .init(name), nil, nil, true)
      }
      Link(getLocalizedString("GET_BUNDLES_HERE"), destination: URL(string: "https://janisbtw.github.io/repo")!)
    }
  }
}