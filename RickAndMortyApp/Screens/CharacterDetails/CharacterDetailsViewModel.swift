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

  weak var navigationDelegate: CharacterDetailsNavigationDelegate?

  private let episodesService: EpisodesServiceProtocol

  init(
    character: Character,
    episodesService: EpisodesServiceProtocol
  ) {
    self.character = character
    self.episodesService = episodesService
  }

  func openEpisodeDetails(forEpisodeNumber number: Int) async {
    do {
      let episode = try await episodesService.fetchEpisode(withNumber: number)
      navigationDelegate?.characterDetailsDidOpenEpisodeDetails(episode)
    } catch {
      print("Error fetching episode details: \(error)")
    }
  }
}
