import GlanceC

extension UIView {
  func removeAllConstraints() {
    let superViewConstraints = superview?.constraints.filter{ $0.firstItem === self || $0.secondItem === self } ?? []

    superview?.removeConstraints(superViewConstraints + constraints)
  }
}