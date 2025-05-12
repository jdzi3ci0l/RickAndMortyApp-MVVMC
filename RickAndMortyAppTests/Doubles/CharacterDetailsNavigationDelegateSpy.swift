@testable import RickAndMortyApp

class CharacterDetailsNavigationDelegateSpy: CharacterDetailsNavigationDelegate {

  private(set) var didOpenEpisodeDetailsCallsWithEpisode: [Episode] = []

  func characterDetailsDidOpenEpisodeDetails(_ episode: Episode) {
    didOpenEpisodeDetailsCallsWithEpisode.append(episode)
  }
}
