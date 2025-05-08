import SwiftUI

class ApplicationCoordinator: BaseCoordinator<UINavigationController> {

  let window: UIWindow

  init(
    window: UIWindow,
    presenter: UINavigationController = UINavigationController()
  ) {
    self.window = window
    super.init(presenter: presenter)
  }

  override func start() {
    window.rootViewController = self.presenter
    window.makeKeyAndVisible()
    let charactersCoordinator = CharactersCoordinator(presenter: self.presenter)
    self.store(coordinator: charactersCoordinator)
    charactersCoordinator.start()
  }
}
