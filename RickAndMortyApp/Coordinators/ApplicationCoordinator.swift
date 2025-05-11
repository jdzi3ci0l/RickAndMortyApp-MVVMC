import SwiftUI

class ApplicationCoordinator: BaseCoordinator<UINavigationController> {

  let window: UIWindow
  private let container: DIContainer

  init(
    window: UIWindow,
    presenter: UINavigationController = UINavigationController(),
    container: DIContainer
  ) {
    self.window = window
    self.container = container
    super.init(presenter: presenter)
  }

  override func start() {
    window.rootViewController = presenter
    window.makeKeyAndVisible()
    let charactersCoordinator = CharactersCoordinator(presenter: presenter, container: container)
    self.store(coordinator: charactersCoordinator)
    charactersCoordinator.start()
  }
}
