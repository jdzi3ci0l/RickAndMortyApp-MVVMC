import SwiftUI

struct CharacterDetailsView: View {

  @ObservedObject private var viewModel: CharacterDetailsViewModel

  init(viewModel: CharacterDetailsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    Text("Character Details")
  }
}

#if DEBUG
#Preview {
  CharacterDetailsView(viewModel: .init(character: .stubRick))
}
#endif
