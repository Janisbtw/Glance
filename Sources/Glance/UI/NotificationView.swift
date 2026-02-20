import GlanceC

class NotificationView: UIView {
  static var shared: NotificationView?

  var showingNotification = false
  var currentBundleIdentifier: String?
  var queuedNotifications: [GlanceNotification] = []

  let contentStack = UIStackView()

  var blurEffectView = BlurEffectView()

  let iconView = UIImageView()
  let smallIconView = UIImageView()
  let titleLabel = UILabel()
  let messageLabel = UILabel()

  let badgeView = UIView()
  let badgeLabel = UILabel()

  var setupDone = false
  var quitEarly = false

  var previousBrightness: CGFloat = 0.0

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func show() {
    isHidden = false
    if settings.hideStatusBar {
      StatusBar.hide()
    }
    UIView.animate(withDuration: settings.openClose, animations: {
      self.alpha = 1.0
    }) {_ in
      Screen.turnOn()
      if settings.adjustBrightness {
        Brightness.setBrightness(settings.brightnessLevel)
      }
      LockScreen.blockIdleTimer()
      self.restyleLabels()
    }
  }

  @objc public func forceClose() {
    queuedNotifications.removeAll()
    
    quitEarly = true
    close(didTimeout: false)
  }

  @objc private func close(didTimeout: Bool = true) {
    remLog("Closing with \(settings.openClose)")
    remLog("close() called with \(didTimeout)")
    if settings.lockAfter && didTimeout {
      remLog("Turning off display")
      UserAgent.lockDevice()
    }
    remLog("Hiding view with delay of \((settings.lockAfter && didTimeout ? 0.5 : 0.0)) seconds")
    DispatchQueue.main.asyncAfter(deadline: .now() + (settings.lockAfter && didTimeout ? 0.5 : 0.0)) {
      if settings.adjustBrightness {
        Brightness.restoreBrightness()
      }
      if settings.hideStatusBar {
        remLog("Unhiding status bar")
        StatusBar.show()
      }
      remLog("Hiding view in \(settings.openClose) seconds...")
      UIView.animate(withDuration: settings.openClose, animations: {
        self.alpha = 0.0
      }) { _ in
        remLog("Hiding view now")
        self.badgeView.isHidden = true
        self.badgeLabel.text = "1"
        self.isHidden = true
        self.queuedNotifications.removeAll()
        self.showingNotification = false
        DispatchQueue.main.asyncAfter(deadline: .now()) {
          remLog("Unlocking idle timer")
          LockScreen.unblockIdleTimer()
        }
      }
    }
  }

  public func setup() {
    guard !setupDone else { return }
    guard let lockscreen = lockscreenWindow else { return }
    alpha = 0.0
    backgroundColor = .black
    isHidden = true
    isUserInteractionEnabled = true

    // setup tap gesture
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forceClose))
    addGestureRecognizer(tapGesture)

    // add to root
    lockscreen.addSubview(self)

    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
    leadingAnchor.constraint(equalTo: superview!.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true

    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.insertSubview(blurEffectView, at: 0)

    setupSubviews()
    setupLabels()

    reloadPreferences()

    setupDone = true
  }

  func updateBlur() {
    blurEffectView.setBlurIntensity(intensity: CGFloat(settings.blurIntensity))
  }

  func updateIconSize() {
    iconView.constraints.forEach { constraint in
      if constraint.identifier == "iconWidthAnchor" || constraint.identifier == "iconHeightAnchor" {
        constraint.constant = CGFloat(settings.iconSize)
      }
    }

    let smallIconSize: Float = Float(Float(settings.iconSize) / Float(100) * 35)
    smallIconView.constraints.forEach { constraint in
      if constraint.identifier == "smallIconWidthAnchor" || constraint.identifier == "smallIconHeightAnchor" {
        constraint.constant = CGFloat(smallIconSize)
      }
    }

    let badgeSize = Float(Float(settings.iconSize) / Float(100) * 40)
    badgeView.constraints.forEach { constraint in
      if constraint.identifier == "badgeWidthAnchor" || constraint.identifier == "badgeHeightAnchor" {
        constraint.constant = CGFloat(badgeSize)
      }
    }
  }

  func setupSubviews() {
    addSubview(contentStack)

    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .vertical
    contentStack.alignment = .center
    contentStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    contentStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    contentStack.addArrangedSubview(iconView)
    contentStack.setCustomSpacing(10, after: iconView)
    addSubview(smallIconView)
    contentStack.addArrangedSubview(titleLabel)
    contentStack.setCustomSpacing(0, after: titleLabel)

    contentStack.addArrangedSubview(messageLabel)

    addSubview(badgeView)

    badgeView.addSubview(badgeLabel)

    contentStack.distribution = .fill
    contentStack.spacing = 5

    let iconWidthAnchor = iconView.widthAnchor.constraint(equalToConstant: CGFloat(settings.iconSize))
    iconWidthAnchor.identifier = "iconWidthAnchor"
    iconWidthAnchor.isActive = true

    let iconHeightAnchor = iconView.heightAnchor.constraint(equalToConstant: CGFloat(settings.iconSize))
    iconHeightAnchor.identifier = "iconHeightAnchor"
    iconHeightAnchor.isActive = true

    iconView.isHidden = false

    smallIconView.translatesAutoresizingMaskIntoConstraints = false

    let smallIconSize: Float = Float(Float(settings.iconSize) / Float(100) * 35)

    let smallIconWidthAnchor = smallIconView.widthAnchor.constraint(equalToConstant: CGFloat(smallIconSize))
    smallIconWidthAnchor.identifier = "smallIconWidthAnchor"
    smallIconWidthAnchor.isActive = true

    let smallIconHeightAnchor = smallIconView.heightAnchor.constraint(equalToConstant: CGFloat(smallIconSize))
    smallIconHeightAnchor.identifier = "smallIconHeightAnchor"
    smallIconHeightAnchor.isActive = true

    smallIconView.centerXAnchor.constraint(equalTo: iconView.trailingAnchor, constant: -10).isActive = true
    smallIconView.centerYAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -10).isActive = true
    restyleLabels()

    iconView.isHidden = true
  }

  func restyleLabels() {
    titleLabel.font = .systemFont(ofSize: CGFloat(settings.titleFontSize), weight: UIFont.weightForString(settings.titleFontWeight))
    messageLabel.font = .systemFont(ofSize: CGFloat(settings.contentFontSize), weight: UIFont.weightForString(settings.contentFontWeight))
  }

  func setupLabels() {
    titleLabel.textColor = .white
    titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    messageLabel.textColor = .white
    messageLabel.font = .systemFont(ofSize: 16, weight: .light)
    messageLabel.textAlignment = .center
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.numberOfLines = 0
    messageLabel.lineBreakMode = .byWordWrapping

    messageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
  }

  func fadeOut() {
    // fade out icon and badge
    UIView.animate(withDuration: settings.fadeInOut, animations: {
      self.iconView.alpha = 0.0
      self.smallIconView.alpha = 0.0
      self.titleLabel.alpha = 0.0
      self.messageLabel.alpha = 0.0
      self.badgeView.alpha = 0.0
    }) {_ in
      self.smallIconView.isHidden = true
    }
  }

  func createBadge(count: Int) {
    guard settings.showIcon else { return }

    badgeView.backgroundColor = .red

    badgeView.translatesAutoresizingMaskIntoConstraints = false

    let badgeSize = Float(Float(settings.iconSize) / Float(100) * 40)

    let badgeWidthAnchor = badgeView.widthAnchor.constraint(equalToConstant: CGFloat(badgeSize))
    badgeWidthAnchor.identifier = "badgeWidthAnchor"
    badgeWidthAnchor.isActive = true

    let badgeHeightAnchor = badgeView.heightAnchor.constraint(equalToConstant: CGFloat(badgeSize))
    badgeHeightAnchor.identifier = "badgeHeightAnchor"
    badgeHeightAnchor.isActive = true

    badgeView.centerXAnchor.constraint(equalTo: iconView.trailingAnchor).isActive = true
    badgeView.centerYAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
    badgeView.layer.cornerRadius = CGFloat(Float(Float(settings.iconSize) / Float(100) * 20))

    badgeLabel.text = String(count)
    badgeLabel.textColor = .white
    badgeLabel.font = .systemFont(ofSize: CGFloat(Float(Float(settings.iconSize) / Float(100) * 16)))
    badgeLabel.sizeToFit()

    badgeLabel.translatesAutoresizingMaskIntoConstraints = false
    badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor).isActive = true
    badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor).isActive = true

    badgeView.isHidden = false
    badgeView.alpha = 1.0

    addSubview(badgeView)

    badgeView.addSubview(badgeLabel)
  }

  func updateTitle(_ title: String) {
    titleLabel.text = title
    titleLabel.sizeToFit()
    restyleLabels()
  }

  func updateMessage(_ message: String) {
    messageLabel.text = message
    messageLabel.sizeToFit()
  }

  func updateIcon(_ notification: GlanceNotification) {
    iconView.isHidden = !settings.showIcon
    self.smallIconView.isHidden = true
    guard settings.showIcon else { return }

    let appIcon = UIImage._applicationIconImage(forBundleIdentifier: currentBundleIdentifier, format: 3, scale: 3)
    var image = appIcon
    var contactPhoto: UIImage?
    if(contactPhotoProviders.keys.contains(notification.appIdentifier)) {
      contactPhoto = notification.image ?? contactPhotoProviders[notification.appIdentifier]?.getImage(title: notification.title, message: notification.message, appIdentifier: notification.appIdentifier, context: notification.context)
      if(contactPhoto != nil) {
        smallIconView.image = appIcon
        image = contactPhoto?.roundedImage()
        self.smallIconView.isHidden = false
        UIView.animate(withDuration: settings.fadeInOut, animations: {
          self.smallIconView.alpha = 1.0
        })
      }
    }
    notification.image = image
    iconView.image = image
  }

  func queueNotification(notification: GlanceNotification) {
    remLog("Queued notification from \(notification.appIdentifier) with title: \(notification.title) and message: \(notification.message)")
    remLog("Queueing")

    if(isHidden) {
      remLog("Unhiding view now")
      show()
    }

    backgroundColor = settings.blackout ? .black : .clear
    blurEffectView.isHidden = settings.blackout

    if(!showingNotification) {
      remLog("Setting up notification with title \(notification.title) now")
      showingNotification = true
      currentBundleIdentifier = notification.appIdentifier

      updateIcon(notification)

      // cleanup from previous notification
      titleLabel.textColor = .white
      messageLabel.textColor = .white

      var color: UIColor?

      if(settings.coloredTitle || settings.coloredContent) {
        if settings.colorBasedOnProfilePicture {
          color = notification.image?.medianColor
        }
        else {
          color = UIImage._applicationIconImage(forBundleIdentifier: notification.appIdentifier, format: 3, scale: 3).medianColor
        }
      }

      if settings.coloredTitle {
        titleLabel.textColor = color
      }
      if settings.coloredContent {
        messageLabel.textColor = color
      }

      UIView.animate(withDuration: settings.fadeInOut, animations: {
        if settings.showIcon {
          self.iconView.alpha = 1.0
        }
        if settings.showTitle {
          self.titleLabel.alpha = 1.0
        }
        if settings.showContent {
          self.messageLabel.alpha = 1.0
        }
      }) {_ in
        // check if anymore notifications exist with same bundleIdentifier and create badge for it
        var badgeCount = 1
        for _ in 0..<self.queuedNotifications.count {
          if(self.queuedNotifications[0].appIdentifier == notification.appIdentifier) {
            self.queuedNotifications.remove(at: 0)
            badgeCount += 1
          }
          else {
            break
          }
        }
        if(badgeCount != 1) {
          self.createBadge(count: badgeCount)
        }
      }

      updateTitle(notification.title)
      updateMessage(notification.message)
      titleLabel.isHidden = !settings.showTitle
      messageLabel.isHidden = !settings.showContent
      restyleLabels()

      remLog("Setup done, waiting for \(settings.animationDuration) seconds")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + settings.animationDuration) {
        remLog("Animation done, closing now")
        if(self.quitEarly && !self.showingNotification) {
          remLog("User interrupted the notification, already closed; doing nothing")
          self.quitEarly = false
          return
        }
        else if (self.quitEarly) {
          remLog("User interrupted the notification, but still showing; closing now")
          self.quitEarly = false
          self.close()
          return
        }
        
        // when it is empty, just close the view
        if(self.queuedNotifications.isEmpty) {
          remLog("No more notifications, checking status...")
          if self.showingNotification {
            remLog("Still showing notification, closing now")
            self.close()
          }
        }

        // otherwise, show the next notification
        else {
          remLog("More notifications, preparing to load next one now")
          // get ready for next notification
          self.showingNotification = false

          let nextNotification = self.queuedNotifications.removeFirst()

          self.fadeOut()

          remLog("Waiting for \(settings.fadeInOut) seconds before showing next notification")

          DispatchQueue.main.asyncAfter(deadline: .now() + settings.fadeInOut) {
            remLog("Showing next notification now")
            self.badgeView.isHidden = true
            self.queueNotification(notification: nextNotification)
          }
        }
      }
    }
    else {
      if(currentBundleIdentifier == notification.appIdentifier) {
        remLog("Updating icon, title, message and badge count")
        updateIcon(notification)
        updateTitle(notification.title)
        updateMessage(notification.message)

        createBadge(count: Int(badgeLabel.text ?? "1")! + 1)
      }
      else {
        remLog("Queing and preloading icon...")
        notification.preloadImage()
        queuedNotifications.append(notification)
      }
    }
  }
}
