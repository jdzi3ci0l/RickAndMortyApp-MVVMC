@testable import RickAndMortyApp

class CharactersListNavigationDelegateSpy: CharactersListNavigationDelegate {

  private(set) var didOpenCharacterDetailsCallsWithCharacter: [Character] = []

  func charactersListDidOpenCharacterDetails(_ character: Character) {
    didOpenCharacterDetailsCallsWithCharacter.append(character)
  }
}
