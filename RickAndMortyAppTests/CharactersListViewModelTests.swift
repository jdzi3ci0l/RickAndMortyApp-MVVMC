import Testing
@testable import RickAndMortyApp

@MainActor
final class CharactersListViewModelTests {

  private var service: MockCharactersService!
  private var delegate: CharactersListNavigationDelegateSpy!
  private var sut: CharactersListViewModel!

  init() {
    service = MockCharactersService()
    delegate = CharactersListNavigationDelegateSpy()
    sut = CharactersListViewModel(charactersService: service)
    sut.navigationDelegate = delegate
  }

  deinit {
    service = nil
    delegate = nil
    sut = nil
  }

  @Test
  func initial_state() {
    #expect(sut.characters == nil)
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == true)
    #expect(sut.currentPage == 1)
  }

  @Test
  func loadCharacters_success() async {
    service.fetchCharactersResult = .success([.stubRick, .stubMorty])
    await sut.loadCharacters()

    #expect(service.fetchCharactersCallsWithPage == [1])
    #expect(sut.characters == [.stubRick, .stubMorty])
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == true)
  }

  @Test
  func loadCharacters_failure() async {
    service.fetchCharactersResult = .failure(APIError.serverError(statusCode: 500))
    await sut.loadCharacters()

    #expect(service.fetchCharactersCallsWithPage == [1])
    #expect(sut.characters == nil, "Expected characters to remain nil")
    // TODO: Test that error is handled properly
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == true)
  }

  @Test("loadCharacters sets characters to empty array and hasMorePages to false when response is empty")
  func loadCharacters_empty_response() async {
    service.fetchCharactersResult = .success([])
    await sut.loadCharacters()

    #expect(sut.characters == [])
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == false)
  }

  @Test("loadCharacters allows only one concurrent call")
  func test_loadCharacters_allows_only_one_concurrent_call() async {
    async let first: () = sut.loadCharacters()
    async let second: () = sut.loadCharacters()

    _ = await (first, second)

    #expect(service.fetchCharactersCallsWithPage.count == 1, "Expected only one fetch to happen")
  }

  @Test
  func loadMoreCharactersIfNeeded_not_last_id() async {
    await sut.loadCharacters() // Loading Rick and Morty
    await sut.loadMoreCharactersIfNeeded(currentCharacterId: Character.stubRick.id)

    #expect(service.fetchCharactersCallsWithPage == [1], "Expected only one fetch to happen")
    #expect(sut.currentPage == 1)
  }

  @Test
  func loadMoreCharactersIfNeeded_last_id() async {
    await sut.loadCharacters() // Loading Rick and Morty
    await sut.loadMoreCharactersIfNeeded(currentCharacterId: Character.stubMorty.id)

    #expect(service.fetchCharactersCallsWithPage == [1, 2], "Expected two fetches to happen")
    #expect(sut.currentPage == 2)
  }

  @Test("selectCharacter calls navigation delegate")
  func selectCharacter_calls_navigation_delegate() {
    let character = Character.stubRick
    sut.selectCharacter(character)
    #expect(delegate.didSelectCharacterCallsWithCharacter == [character])
  }

  @Test("reset resets state correctly")
  func reset() async {
    await sut.loadCharacters() // Loading Rick and Morty
    service.fetchCharactersResult = .success([])
    await sut.loadMoreCharactersIfNeeded(currentCharacterId: Character.stubMorty.id)

    #expect(sut.characters == [.stubRick, .stubMorty])
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == false)

    sut.reset()

    #expect(sut.characters == nil)
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == true)
  }
}
