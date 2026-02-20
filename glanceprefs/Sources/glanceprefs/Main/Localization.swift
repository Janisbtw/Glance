import glanceprefsC
import libroot

var bundle: Bundle?

func setupLocalization() {
  bundle = Bundle(path: jbRootPath("/Library/Tweak Support/Glance/Localization.bundle"))
}

func getLocalizedString(_ key: String) -> String {
  let localizedString = bundle!.localizedString(forKey: key, value: "Localization missing", table: nil)
  return localizedString
}