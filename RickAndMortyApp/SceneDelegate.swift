import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  private var applicationCoordinator: ApplicationCoordinator?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)

    applicationCoordinator = ApplicationCoordinator(
      window: window,
      container: DIContainer.prepareLiveDependencies()
    )

    applicationCoordinator?.start()
  }
}
