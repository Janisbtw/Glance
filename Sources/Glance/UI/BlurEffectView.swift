import GlanceC

class BlurEffectView: UIVisualEffectView {
    
  var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
  override func didMoveToSuperview() {
    guard let superview = superview else { return }
    backgroundColor = .clear
    frame = superview.bounds //Or setup constraints instead
    setupBlur()
  }
    
  private func setupBlur() {
    animator.stopAnimation(true)
    effect = nil

    animator.addAnimations { [weak self] in
      self?.effect = UIBlurEffect(style: .dark)
    }
    animator.fractionComplete = settings.blurIntensity   //This is your blur intensity in range 0 - 1
  }

  public func setBlurIntensity(intensity: CGFloat) {
    animator.fractionComplete = intensity
  }
    
  deinit {
    animator.stopAnimation(true)
  }
}