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
    window.rootViewController = presenter
    window.makeKeyAndVisible()
    let mainCoordinator = MainCoordinator(presenter: presenter)
    mainCoordinator.start()
    self.store(coordinator: mainCoordinator)
  }
}
