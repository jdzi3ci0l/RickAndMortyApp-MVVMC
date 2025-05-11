@testable import RickAndMortyApp

class CharactersListNavigationDelegateSpy: CharactersListNavigationDelegate {

  var didOpenCharacterDetailsWithCharacter: [Character] = []

  func charactersListDidOpenCharacterDetails(_ character: Character) {
    didOpenCharacterDetailsWithCharacter.append(character)
  }
}
