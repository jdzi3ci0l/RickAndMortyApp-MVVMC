import SwiftUI

final class CharactersCoordinator: BaseCoordinator<UINavigationController> {

  override func start() {
    let viewModel = CharactersListViewModel()
    let view = CharactersListView(viewModel: viewModel)
    let hostingController = HostingController(rootView: view, viewModel: viewModel)
    hostingController.title = "Characters"
    presenter.setViewControllers([hostingController], animated: true)
  }
}
