import SwiftUI

// MARK: - CharactersListNavigationDelegate

protocol CharactersListNavigationDelegate: AnyObject {
  func charactersListDidSelectCharacter(_ character: Character)
}

// MARK: - CharactersListViewModel

final class CharactersListViewModel: BaseViewModel, ObservableObject {

  weak var navigationDelegate: CharactersListNavigationDelegate?

  @Published private(set) var characters: [Character] = []

  func selectCharacter(_ character: Character) {
    navigationDelegate?.charactersListDidSelectCharacter(character)
  }
}
