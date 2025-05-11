import UIKit

class BaseCoordinator<ControllerType> where ControllerType: UIViewController {

  let id = UUID()

  var presenter: ControllerType

  private(set) var childCoordinators: [UUID: Any] = [:]

  init(presenter: ControllerType) {
    self.presenter = presenter
  }

  @MainActor
  func start() {
    preconditionFailure("Start method not implemented")
  }

  // MARK: Child coordinators management

  func store<U: UIViewController>(coordinator: BaseCoordinator<U>) {
    let coordinatorExists = childCoordinators[coordinator.id] != nil
    guard !coordinatorExists else { return }
    childCoordinators[coordinator.id] = coordinator
  }

  func free<U: UIViewController>(coordinator: BaseCoordinator<U>) {
    childCoordinators[coordinator.id] = nil
  }

  func freeAllChildCoordinators() {
    childCoordinators = [:]
  }

  func childCoordinator<T>(forKey key: UUID) -> T? {
    childCoordinators[key] as? T
  }
}
