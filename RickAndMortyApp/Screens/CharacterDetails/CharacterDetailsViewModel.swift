import SwiftUI

// MARK: - CharacterDetailsNavigationDelegate

protocol CharacterDetailsNavigationDelegate: AnyObject {
  func characterDetailsDidSelectEpisode()
}

// MARK: - CharacterDetailsViewModel

final class CharacterDetailsViewModel: BaseViewModel, ObservableObject {

  weak var navigationDelegate: CharacterDetailsNavigationDelegate?

  let character: Character

  init(character: Character) {
    self.character = character
  }
}
