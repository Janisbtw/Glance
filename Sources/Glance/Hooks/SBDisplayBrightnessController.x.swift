import GlanceC
import Orion

var brightnessController: SBDisplayBrightnessController!
var previousBrightness = 1337.0

struct Brightness {
  static func setBrightness(_ level: Double) {
    if brightnessController == nil {
      brightnessController = Dynamic("SBDisplayBrightnessController").alloc(interface: SBDisplayBrightnessController.self)
    }

    previousBrightness = UIScreen.main.brightness
    remLog("Previous brightness: \(previousBrightness)")

    brightnessController.noteValueUpdatesWillBegin()
    brightnessController.setBrightnessLevel(Float(level) / 100.0, animated: false)
    brightnessController.noteValueUpdatesDidEnd()
  }

  static func restoreBrightness() {
    if brightnessController == nil {
      brightnessController = Dynamic("SBDisplayBrightnessController").alloc(interface: SBDisplayBrightnessController.self)
    }

    if previousBrightness == 1337.0 {
      return
    }

    brightnessController.noteValueUpdatesWillBegin()
    remLog("Restoring brightness to \(previousBrightness)")
    brightnessController.setBrightnessLevel(Float(previousBrightness), animated: false)
    brightnessController.noteValueUpdatesDidEnd()
  }
}