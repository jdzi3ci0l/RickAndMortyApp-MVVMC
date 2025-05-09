import SwiftUI

struct ActionButtonStyle: ButtonStyle {

  let backgroundColor: Color
  let foregroundColor: Color

  init(
    backgroundColor: Color,
    foregroundColor: Color
  ) {
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title2.weight(.semibold))
      .foregroundStyle(foregroundColor)
      .padding(8)
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .cornerRadius(8)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
  }
}

extension ActionButtonStyle {
  static let primary = ActionButtonStyle(
    backgroundColor: Color.accentPrimary,
    foregroundColor: Color.textOnAccent
  )
}
