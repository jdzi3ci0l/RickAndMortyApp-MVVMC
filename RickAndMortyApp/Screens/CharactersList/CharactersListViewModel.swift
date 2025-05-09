import SwiftUI

// MARK: - CharactersListNavigationDelegate

protocol CharactersListNavigationDelegate: AnyObject {
  func charactersListDidSelectCharacter(_ character: Character)
}

// MARK: - CharactersListViewModel

final class CharactersListViewModel: BaseViewModel, ObservableObject {

  @Published private(set) var isLoading: Bool = false
  @Published private(set) var characters: [Character]? = nil
  @Published private(set) var hasMorePages: Bool = true

  private var currentPage: Int = 1
  weak var navigationDelegate: CharactersListNavigationDelegate?

  private let charactersService: CharactersServiceProtocol

  init(
    charactersService: CharactersServiceProtocol
  ) {
    self.charactersService = charactersService
  }

  func loadCharacters() {
    guard !isLoading else { return }
    Task { @MainActor in
      isLoading = true
      defer { isLoading = false }
      do {
        let response = try await charactersService.fetchCharacters(page: currentPage)
        if currentPage == 1 {
          self.characters = response
        } else {
          self.characters?.append(contentsOf: response)
        }
        hasMorePages = !response.isEmpty
      } catch {
        print("Error fetching characters: \(error)")
      }
    }
  }

  func loadMoreCharactersIfNeeded(currentCharacterId: Int) {
    guard
      let characters = characters,
      !isLoading,
      hasMorePages,
      characters.last?.id == currentCharacterId
    else {
      return
    }
    currentPage += 1
    loadCharacters()
  }

  func reset() {
    characters = nil
    currentPage = 1
    hasMorePages = true
  }

  func selectCharacter(_ character: Character) {
    navigationDelegate?.charactersListDidSelectCharacter(character)
  }

  var shouldUseFullScreenLoadingOverlay: Bool {
    characters == nil && isLoading
  }
}
