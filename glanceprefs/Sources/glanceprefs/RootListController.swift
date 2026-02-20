import SwiftUI
import Comet
import glanceprefsC
import Foundation

class RootListController: CMViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup(content: RootView())
    self.title = ""
    Data.shared.load()
    setupLocalization()
  }
}
