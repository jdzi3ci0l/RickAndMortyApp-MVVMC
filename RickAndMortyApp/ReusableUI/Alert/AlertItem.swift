import SwiftUI

struct AlertItem {

  var title: String
  var message: String
  var buttons: [Button]

  init(title: String, message: String, buttons: [Button]) {
    self.title = title
    self.message = message
    self.buttons = buttons
  }

  struct Button {
    var title: String
    var role: ButtonRole?
    var action: () -> Void

    init(
      title: String,
      role: ButtonRole? = nil,
      action: @escaping () -> Void
    ) {
      self.title = title
      self.role = role
      self.action = action
    }
  }
}

extension View {
  func alert(
    item: Binding<AlertItem?>
  ) -> some View {
    self
      .alert(
        item.wrappedValue?.title ?? "",
        isPresented: .init(
          get: { item.wrappedValue != nil },
          set: { newValue in if !newValue { item.wrappedValue = nil } }
        ),
        presenting: item.wrappedValue,
        actions: { item in
          ForEach(item.buttons, id: \.title) { button in
            SwiftUI.Button(button.title, role: button.role, action: button.action)
          }
        },
        message: { item in Text(item.message) }
      )
  }
}

extension AlertItem {
  init(fromError error: Error) {
    self.init(
      title: "Error",
      message: error.localizedDescription,
      buttons: [
        Button(title: "OK") {}
      ]
    )
  }
}
