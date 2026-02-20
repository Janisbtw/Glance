import GlanceC

extension UIColor {

  /// The HSL (hue, saturation, lightness) components of a color.
  struct HSL: Hashable {

    /// The hue component of the color, in the range [0, 360°].
    var hue: CGFloat
    /// The saturation component of the color, in the range [0, 100%].
    var saturation: CGFloat
    /// The lightness component of the color, in the range [0, 100%].
    var lightness: CGFloat

  }

  /// The HSL (hue, saturation, lightness) components of the color.
  var hsl: HSL {
    var (h, s, b) = (CGFloat(), CGFloat(), CGFloat())
    getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        
    let l = ((2.0 - s) * b) / 2.0

    switch l {
    case 0.0, 1.0:
      s = 0.0
    case 0.0..<0.5:
      s = (s * b) / (l * 2.0)
    default:
      s = (s * b) / (2.0 - l * 2.0)
    }

    return HSL(hue: h * 360.0, saturation: s * 100.0, lightness: l * 100.0)
  }

  /// Initializes a color from HSL (hue, saturation, lightness) components.
  /// - parameter hsl: The components used to initialize the color.
  /// - parameter alpha: The alpha value of the color.
  convenience init(_ hsl: HSL, alpha: CGFloat = 1.0) {
    let h = hsl.hue / 360.0
    var s = hsl.saturation / 100.0
    let l = hsl.lightness / 100.0

    let t = s * ((l < 0.5) ? l : (1.0 - l))
    let b = l + t
    s = (l > 0.0) ? (2.0 * t / b) : 0.0

    self.init(hue: h, saturation: s, brightness: b, alpha: alpha)
  }

}