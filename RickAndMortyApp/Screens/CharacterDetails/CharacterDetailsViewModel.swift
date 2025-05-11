import SwiftUI

// MARK: - CharacterDetailsNavigationDelegate

@MainActor
protocol CharacterDetailsNavigationDelegate: AnyObject {
  func characterDetailsDidSelectEpisode()
}

// MARK: - CharacterDetailsViewModel

@MainActor
final class CharacterDetailsViewModel: BaseViewModel, ObservableObject {

  weak var navigationDelegate: CharacterDetailsNavigationDelegate?

  let character: Character

  init(character: Character) {
    self.character = character
  }
}
