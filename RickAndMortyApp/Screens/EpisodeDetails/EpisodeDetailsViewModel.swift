import SwiftUI

@MainActor
final class EpisodeDetailsViewModel: BaseViewModel, ObservableObject {

  let episode: Episode

  init(episode: Episode) {
    self.episode = episode
  }
}
