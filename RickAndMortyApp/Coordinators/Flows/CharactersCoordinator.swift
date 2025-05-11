import SwiftUI

// MARK: - CharactersCoordinator

final class CharactersCoordinator: BaseCoordinator<UINavigationController> {

  private let container: DIContainer

  init(
    presenter: UINavigationController,
    container: DIContainer
  ) {
    self.container = container
    super.init(presenter: presenter)
  }

  override func start() {
    let viewModel = CharactersListViewModel(
      charactersService: container.resolve(CharactersServiceProtocol.self)
    )
    viewModel.navigationDelegate = self
    let view = CharactersListView(viewModel: viewModel)
    let hostingController = HostingController(rootView: view, viewModel: viewModel)
    hostingController.title = "Characters"
    presenter.setViewControllers([hostingController], animated: true)
  }
}

// MARK: - CharactersListNavigationDelegate

extension CharactersCoordinator: CharactersListNavigationDelegate {
  func charactersListDidOpenCharacterDetails(_ character: Character) {
    let viewModel = CharacterDetailsViewModel(
      character: character,
      episodesService: container.resolve(EpisodesServiceProtocol.self)
    )
    viewModel.navigationDelegate = self
    let view = CharacterDetailsView(viewModel: viewModel)
    let hostingController = HostingController(rootView: view, viewModel: viewModel)
    hostingController.title = character.name
    presenter.pushViewController(hostingController, animated: true)
  }
}

// MARK: - CharacterDetailsNavigationDelegate

extension CharactersCoordinator: CharacterDetailsNavigationDelegate {
  func characterDetailsDidOpenEpisodeDetails(_ episode: Episode) {
    let viewModel = EpisodeDetailsViewModel(episode: episode)
    let view = EpisodeDetailsView(viewModel: viewModel)
    let hostingController = HostingController(rootView: view, viewModel: viewModel)
    hostingController.title = "Episode \(episode.id)"
    presenter.pushViewController(hostingController, animated: true)
  }
}
