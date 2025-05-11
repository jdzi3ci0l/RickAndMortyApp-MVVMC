@testable import RickAndMortyApp

class CharactersListNavigationDelegateSpy: CharactersListNavigationDelegate {

  var didSelectCharacterCallsWithCharacter: [Character] = []

  func charactersListDidSelectCharacter(_ character: Character) {
    didSelectCharacterCallsWithCharacter.append(character)
  }
}
