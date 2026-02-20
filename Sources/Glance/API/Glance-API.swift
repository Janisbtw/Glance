import GlanceC

@objcMembers public class GlanceNotification: NSObject {
  public var title: String
  public var message: String
  public var appIdentifier: String
  public var context: NSDictionary
  @nonobjc var image: UIImage?

  public init(title: String, message: String, appIdentifier: String, context: NSDictionary) {
    self.title = title
    self.message = message
    self.appIdentifier = appIdentifier
    self.context = context
  }
  
  @nonobjc func preloadImage() {
    guard contactPhotoProviders.keys.contains(appIdentifier) else { return }
    DispatchQueue.main.async {
      self.image = contactPhotoProviders[self.appIdentifier]?.getImage(title: self.title, message: self.message, appIdentifier: self.appIdentifier, context: self.context)
    }
  }
}

@objc public protocol ContactPhotoProvider {
  @objc func getImage(title: String, message: String, appIdentifier: String, context: NSDictionary) -> UIImage?
}