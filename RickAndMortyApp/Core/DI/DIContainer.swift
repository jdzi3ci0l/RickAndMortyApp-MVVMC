/// NOTE: I would normally use `Swinject` for dependency injection in Swift, but I wasn't sure
/// if third party libraries were allowed for this task.
class DIContainer {

  private var factories: [String: (DIContainer) -> Any] = [:]

  func register<T>(_ type: T.Type, factory: @escaping (DIContainer) -> T) {
    let key = String(describing: type)
    factories[key] = factory
  }

  func resolve<T>(_ type: T.Type) -> T {
    let key = String(describing: type)
    guard let factory = factories[key] else {
      fatalError("No registered factory for type \(key).")
    }
    return factory(self) as! T
  }
}

extension DIContainer {

  static func prepareLiveDependencies() -> DIContainer {
    let container = DIContainer()
    container.register(APIClientProtocol.self) { _ in
      RickAndMortyAPIClient()
    }
    container.register(CharactersServiceProtocol.self) { resolver in
      CharactersService(apiClient: resolver.resolve(APIClientProtocol.self))
    }
    container.register(EpisodesServiceProtocol.self) { resolver in
      EpisodesService(apiClient: resolver.resolve(APIClientProtocol.self))
    }
    container.register(PersistenceManaging.self) { _ in
      UserDefaultsPersistenceManager()
    }
    return container
  }

}
