import SwiftUI

// MARK: - CharacterDetailsNavigationDelegate

@MainActor
protocol CharacterDetailsNavigationDelegate: AnyObject {
  func characterDetailsDidOpenEpisodeDetails(_ episode: Episode)
}

// MARK: - CharacterDetailsViewModel

@MainActor
final class CharacterDetailsViewModel: BaseViewModel, ObservableObject {

  let character: Character

  @Published private(set) var isLoading: Bool = false
  @Published var isFavourite: Bool = false {
    didSet {
      guard isFavourite != oldValue, !isRefreshingFavourites else { return }
      updateFavourites()
    }
  }

  private var isRefreshingFavourites: Bool = false

  weak var navigationDelegate: CharacterDetailsNavigationDelegate?

  private let episodesService: EpisodesServiceProtocol
  private let persistenceManager: PersistenceManaging

  init(
    character: Character,
    episodesService: EpisodesServiceProtocol,
    persistenceManager: PersistenceManaging
  ) {
    self.character = character
    self.episodesService = episodesService
    self.persistenceManager = persistenceManager
  }

  func onViewAppear() {
    refreshFavourites()
  }

  func openEpisodeDetails(forEpisodeNumber number: Int) async {
    guard !isLoading else { return }
    isLoading = true
    defer { isLoading = false }
    do {
      let episode = try await episodesService.fetchEpisode(withNumber: number)
      navigationDelegate?.characterDetailsDidOpenEpisodeDetails(episode)
    } catch {
      print("Error fetching episode details: \(error)")
    }
  }

  private func refreshFavourites() {
    isRefreshingFavourites = true
    do {
      let favouriteIds = try persistenceManager.load(from: Storages.favouriteCharacterIds)
      isFavourite = favouriteIds.contains(character.id)
    } catch {
      print("Error loading favourites: \(error)")
    }
    isRefreshingFavourites = false
  }

  private func updateFavourites() {
    do {
      let favouriteIds = try persistenceManager.load(from: Storages.favouriteCharacterIds)
      var ids = favouriteIds
      if isFavourite {
        guard !ids.contains(character.id) else { return }
        ids.insert(character.id)
      } else {
        guard ids.contains(character.id) else { return }
        ids.remove(character.id)
      }
      try persistenceManager.save(ids, in: Storages.favouriteCharacterIds)
    } catch {
      print("Error updating favourites: \(error)")
    }
  }
}
