@testable import RickAndMortyApp

class CharactersListNavigationDelegateSpy: CharactersListNavigationDelegate {

  var didOpenCharacterDetailsCallsWithCharacter: [Character] = []

  func charactersListDidOpenCharacterDetails(_ character: Character) {
    didOpenCharacterDetailsCallsWithCharacter.append(character)
  }
}
