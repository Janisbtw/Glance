import SwiftUI
import Comet
import glanceprefsC

struct SelectFocusView: View {
  var preferenceStorage: PreferenceStorage
  @ObservedObject var data = Data.shared

  var body: some View {
    Form {
      Section {
        List {
          ForEach(data.userInfo?["focusList"] as? [String] ?? [], id: \.self) { focus in
            let parts = focus.split(separator: ":")
            let uuid = String(describing: parts[0])
            let label = String(describing: parts[1])
            
            FocusToggle(uuid: uuid, label: label, initialState: preferenceStorage.disabledFocus.contains(uuid), preferenceStorage: preferenceStorage)
          }
        }
      } footer: {
        Text(getLocalizedString("ENABLING_WILL_DISABLE_GLANCE_WHILE_FOCUS"))
      }
    }
  }
}

struct FocusToggle: View {
  var uuid: String
  var label: String
  var preferenceStorage: PreferenceStorage

  @State private var on: Bool

  init(uuid: String, label: String, initialState: Bool, preferenceStorage: PreferenceStorage) {
    self.uuid = uuid
    self.label = label
    self.on = initialState
    self.preferenceStorage = preferenceStorage
  }

  var body: some View {
    Toggle(label, isOn: $on).onChange(of: on) { value in
      if on {
        preferenceStorage.disabledFocus.append(uuid)
      } else {
        preferenceStorage.disabledFocus.removeAll(where: { $0 == uuid })
      }
    }
  }
}