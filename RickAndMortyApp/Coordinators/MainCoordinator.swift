import SwiftUI

class MainCoordinator: BaseCoordinator<UINavigationController> {

  override func start() {
    showCharacterListScreen()
  }

  private func showCharacterListScreen() {
    let charactersCoordinator = CharactersCoordinator(presenter: self.presenter)
    charactersCoordinator.start()
  }
}
