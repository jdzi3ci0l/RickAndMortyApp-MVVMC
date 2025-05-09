import SwiftUI

// MARK: - CharactersListNavigationDelegate

protocol CharactersListNavigationDelegate: AnyObject {
  func charactersListDidSelectCharacter(_ character: Character)
}

// MARK: - CharactersListViewModel

final class CharactersListViewModel: BaseViewModel, ObservableObject {

  weak var navigationDelegate: CharactersListNavigationDelegate?

  @Published private(set) var isLoading: Bool = false
  @Published private(set) var characters: [Character]? = nil

  func loadCharacters() {
    self.isLoading = true
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
    self.characters = characters
  }

  func reset() {
    self.isLoading = false
    self.characters = nil
  }

  func selectCharacter(_ character: Character) {
    navigationDelegate?.charactersListDidSelectCharacter(character)
  }
}
