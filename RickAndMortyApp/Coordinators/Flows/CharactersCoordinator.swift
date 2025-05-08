import SwiftUI

// MARK: - CharactersCoordinator

final class CharactersCoordinator: BaseCoordinator<UINavigationController> {

  override func start() {
    let viewModel = CharactersListViewModel()
    viewModel.navigationDelegate = self
    let view = CharactersListView(viewModel: viewModel)
    let hostingController = HostingController(rootView: view, viewModel: viewModel)
    hostingController.title = "Characters"
    presenter.setViewControllers([hostingController], animated: true)
  }
}

// MARK: - CharactersListNavigationDelegate

extension CharactersCoordinator: CharactersListNavigationDelegate {
  func charactersListDidSelectCharacter(_ character: Character) {
    let viewModel = CharacterDetailsViewModel(character: character)
    viewModel.navigationDelegate = self
    let view = CharacterDetailsView(viewModel: viewModel)
    let hostingController = HostingController(rootView: view, viewModel: viewModel)
    hostingController.title = character.name
    presenter.pushViewController(hostingController, animated: true)
  }
}

// MARK: - CharacterDetailsNavigationDelegate

extension CharactersCoordinator: CharacterDetailsNavigationDelegate {
  func characterDetailsDidSelectEpisode() {
    fatalError("Not implemented")
  }
}
