import SwiftUI

struct CharactersListView: View {

  @ObservedObject private var viewModel: CharactersListViewModel

  let characters: [Character] = [
    Character(
      id: 1,
      name: "Rick Sanchez",
      gender: .male,
      origin: .init(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137"),
      lastKnownLocation: .init(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137"),
      imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      episodesUrlStrings: []
    ),
    Character(
      id: 2,
      name: "Morty",
      gender: .male,
      origin: .init(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137"),
      lastKnownLocation: .init(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137"),
      imageUrlString: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
      episodesUrlStrings: []
    )
  ]

  init(viewModel: CharactersListViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 12) {
        ForEach(characters) { character in
          Button {
            viewModel.selectCharacter(character)
          } label: {
            CharactersListRowView(character: character)
              .frame(height: 81)
          }
        }
      }
      .padding(16)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.background.ignoresSafeArea())
  }
}

#if DEBUG
#Preview {
  NavigationView {
    CharactersListView(viewModel: .init())
      .navigationTitle("Characters")
  }
}
#endif
