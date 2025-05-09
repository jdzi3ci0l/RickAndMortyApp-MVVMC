import SwiftUI

// MARK: - CharactersListNavigationDelegate

protocol CharactersListNavigationDelegate: AnyObject {
  func charactersListDidSelectCharacter(_ character: Character)
}

// MARK: - CharactersListViewModel

final class CharactersListViewModel: BaseViewModel, ObservableObject {

  @Published private(set) var isLoading: Bool = false
  @Published private(set) var characters: [Character]? = nil

  weak var navigationDelegate: CharactersListNavigationDelegate?

  private let charactersService: CharactersServiceProtocol

  init(
    charactersService: CharactersServiceProtocol
  ) {
    self.charactersService = charactersService
  }

  func loadCharacters() {
    Task { @MainActor in
      isLoading = true
      defer { isLoading = false }
      do {
        let characters = try await charactersService.fetchCharacters(page: 1)
        self.characters = characters
      } catch {
        print("Error fetching characters: \(error)")
      }
    }
  }

  func reset() {
    self.characters = nil
  }

  func selectCharacter(_ character: Character) {
    navigationDelegate?.charactersListDidSelectCharacter(character)
  }
}
