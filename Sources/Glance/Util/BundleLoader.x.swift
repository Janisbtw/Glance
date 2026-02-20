import GlanceC
import Orion

var contactPhotoProviders: [String: ContactPhotoProvider] = [:]

func loadBundles(atPath: String) {
  guard FileManager.default.fileExists(atPath: atPath) else { return }
  remLog("Searching at \(atPath)")
  do {
    let bundleNames = try FileManager.default.contentsOfDirectory(atPath: atPath)
    for bundleName in bundleNames {
      let bundle = Bundle(path: "\(atPath)/\(bundleName)")
      guard FileManager.default.fileExists(atPath: "\(atPath)/\(bundleName)/Info.plist") else { continue }
      let plist = FileManager.default.contents(atPath: "\(atPath)/\(bundleName)/Info.plist")
      bundle?.load()

      let info = try PropertyListDecoder().decode(BundleInfo.self, from: plist!)

      for (key, value) in info.ProviderClasses {
        remLog("\(bundleName.replacingOccurrences(of: ".bundle", with: "")).\(key)")
        let instance = createInstance(ofClass: "\(bundleName.replacingOccurrences(of: ".bundle", with: "")).\(key)")
        for id in value {
          registerContactPhotoProvider(appIdentifier: id, providerInstance: instance)
        }
      }
    }
  } catch {
    remLog("Error: \(error)")
  }
}

func createInstance(ofClass: String) -> ContactPhotoProvider {
  return Dynamic(ofClass).alloc(interface: ContactPhotoProvider.self)
}

func registerContactPhotoProvider(appIdentifier: String, providerInstance: ContactPhotoProvider) {
  remLog("Registering \(appIdentifier) with \(providerInstance)")
  contactPhotoProviders[appIdentifier] = providerInstance
}

struct BundleInfo: Codable {
  let CFBundleDisplayName: String
  let ProviderClasses: [String: [String]]
  let APIVersion: Int
}