import GlanceC

public extension UIFont {
  static func weightForString(_ weight: String) -> UIFont.Weight {
    switch weight {
    case "ultralight":
      return .ultraLight
    case "thin":
      return .thin
    case "light":
      return .light
    case "regular":
      return .regular
    case "medium":
      return .medium
    case "semibold":
      return .semibold
    case "bold":
      return .bold
    case "heavy":
      return .heavy
    case "black":
      return .black
    default:
      return .regular
    }
  }
}