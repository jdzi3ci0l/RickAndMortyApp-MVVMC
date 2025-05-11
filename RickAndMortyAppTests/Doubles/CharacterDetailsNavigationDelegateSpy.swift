@testable import RickAndMortyApp

class CharacterDetailsNavigationDelegateSpy: CharacterDetailsNavigationDelegate {

  var didOpenEpisodeDetailsCallsWithEpisode: [Episode] = []

  func characterDetailsDidOpenEpisodeDetails(_ episode: Episode) {
    didOpenEpisodeDetailsCallsWithEpisode.append(episode)
  }
}
