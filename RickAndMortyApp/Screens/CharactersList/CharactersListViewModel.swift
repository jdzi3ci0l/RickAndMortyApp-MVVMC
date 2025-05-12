import SwiftUI

// MARK: - CharactersListNavigationDelegate

@MainActor
protocol CharactersListNavigationDelegate: AnyObject {
  func charactersListDidOpenCharacterDetails(_ character: Character)
}

// MARK: - CharactersListViewModel

@MainActor
final class CharactersListViewModel: BaseViewModel, ObservableObject {

  @Published private(set) var isLoading: Bool = false
  @Published private(set) var characters: [Character]? = nil
  @Published private(set) var hasMorePages: Bool = true

  @Published private(set) var favouriteCharacterIds: Set<Int> = []

  private(set) var currentPage: Int = 1

  weak var navigationDelegate: CharactersListNavigationDelegate?

  private let charactersService: CharactersServiceProtocol
  private let persistenceManager: PersistenceManaging

  init(
    charactersService: CharactersServiceProtocol,
    persistenceManager: PersistenceManaging
  ) {
    self.charactersService = charactersService
    self.persistenceManager = persistenceManager
  }

  func onViewAppear() {
    refreshFavourites()
  }

  func loadCharacters() async {
    guard !isLoading else { return }
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

  func loadMoreCharactersIfNeeded(currentCharacterId: Int) async {
    guard
      let characters = characters,
      !isLoading,
      hasMorePages,
      characters.last?.id == currentCharacterId
    else {
      return
    }
    currentPage += 1
    await loadCharacters()
  }

  func reset() {
    characters = nil
    currentPage = 1
    hasMorePages = true
  }

  func selectCharacter(_ character: Character) {
    navigationDelegate?.charactersListDidOpenCharacterDetails(character)
  }

  var isPerformingInitialLoad: Bool {
    characters == nil && isLoading
  }

  func isFavouriteBinding(for character: Character) -> Binding<Bool> {
    .init(
      get: { self.favouriteCharacterIds.contains(character.id) },
      set: { isFavourite in
        if isFavourite {
          self.favouriteCharacterIds.insert(character.id)
        } else {
          self.favouriteCharacterIds.remove(character.id)
        }
        self.updateFavourites()
      }
    )
  }

  private func refreshFavourites() {
    do {
      favouriteCharacterIds = try persistenceManager.load(from: Storages.favouriteCharacterIds)
    } catch {
      print("Error loading favourite character IDs: \(error)")
    }
  }

  private func updateFavourites() {
    do {
      try persistenceManager.save(favouriteCharacterIds, in: Storages.favouriteCharacterIds)
    } catch {
      print("Error updating favourites: \(error)")
    }
  }
}
