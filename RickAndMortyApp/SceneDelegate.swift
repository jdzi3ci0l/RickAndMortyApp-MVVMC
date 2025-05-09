import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  private var applicationCoordinator: ApplicationCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)

    let container = prepareDependencies()
    applicationCoordinator = ApplicationCoordinator(window: window, container: container)
    applicationCoordinator?.start()
  }

  func prepareDependencies() -> DIContainer {
    let container = DIContainer()
    container.register(APIClientProtocol.self) { _ in
      RickAndMortyAPIClient()
    }
    container.register(CharactersServiceProtocol.self) { resolver in
      CharactersService(apiClient: resolver.resolve(APIClientProtocol.self))
    }
    return container
  }
}
