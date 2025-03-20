import SwiftUI

struct CharactersListView: View {

  @ObservedObject private var viewModel: CharactersListViewModel

  init(viewModel: CharactersListViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    Text("Hello, World!")
  }
}

#Preview {
  CharactersListView(viewModel: .init())
}
