import SwiftUI

// MARK: - CharactersListNavigationDelegate

protocol CharactersListNavigationDelegate: AnyObject {

}

// MARK: - CharactersListViewModel

final class CharactersListViewModel: BaseViewModel, ObservableObject {

  weak var navigationDelegate: CharactersListNavigationDelegate?

  @Published private(set) var characters: [Character] = []
}
