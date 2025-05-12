import Testing
@testable import RickAndMortyApp

@MainActor
final class CharactersListViewModelTests {

  private var service: MockCharactersService!
  private var persistenceManager: MockPersistenceManager!
  private var delegate: CharactersListNavigationDelegateSpy!
  private var sut: CharactersListViewModel!

  init() {
    service = MockCharactersService()
    persistenceManager = MockPersistenceManager()
    delegate = CharactersListNavigationDelegateSpy()
    sut = CharactersListViewModel(
      charactersService: service,
      persistenceManager: persistenceManager
    )
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
    #expect(sut.favouriteCharacterIds == [])
    #expect(sut.isLoading == false)
    #expect(sut.hasMorePages == true)
    #expect(sut.currentPage == 1)
  }

  @Test("onViewAppear refreshes favourites from Storage")
  func onViewAppear() throws {
    try persistenceManager.save([1, 2], in: Storages.favouriteCharacterIds)
    sut.onViewAppear()
    #expect(persistenceManager.loadCallsWithStorageKeys == [Storages.favouriteCharacterIds.key])
    #expect(sut.favouriteCharacterIds == [1, 2])
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

  @Test("selectCharacter calls navigationDelegate")
  func selectCharacter_calls_navigation_delegate() {
    let character = Character.stubRick
    sut.selectCharacter(character)
    #expect(delegate.didOpenCharacterDetailsCallsWithCharacter == [character])
  }

  @Test("resetCharacters resets characters and hasMorePages")
  func reset() async {
    await sut.loadCharacters() // Loading Rick and Morty
    service.fetchCharactersResult = .success([])
    await sut.loadMoreCharactersIfNeeded(currentCharacterId: Character.stubMorty.id)

    #expect(sut.characters == [.stubRick, .stubMorty])
    #expect(sut.hasMorePages == false)

    sut.resetCharacters()

    #expect(sut.characters == nil)
    #expect(sut.hasMorePages == true)
  }

  @Test("reset does not reset favouriteCharacterIds")
  func reset_does_not_reset_favouriteCharacterIds() throws {
    try persistenceManager.save([1, 2], in: Storages.favouriteCharacterIds)
    sut.onViewAppear()
    sut.resetCharacters()
    #expect(sut.favouriteCharacterIds == [1, 2])
  }

  @Test
  func isFavouriteBinding_getter() throws {
    let character = Character.stubRick
    #expect(sut.isFavouriteBinding(for: character).wrappedValue == false)

    try persistenceManager.save([character.id], in: Storages.favouriteCharacterIds)
    sut.onViewAppear()

    #expect(sut.isFavouriteBinding(for: character).wrappedValue == true)
  }

  @Test
  func isFavouriteBinding_setter() throws {
    let character = Character.stubRick
    #expect(sut.isFavouriteBinding(for: character).wrappedValue == false)

    sut.isFavouriteBinding(for: character).wrappedValue = true
    #expect(sut.favouriteCharacterIds == [character.id])
    #expect(persistenceManager.saveCallsWithValueAndStorageKeys.count == 1)
    let firstSaveCall = try #require(persistenceManager.saveCallsWithValueAndStorageKeys.first)
    let savedIds = try #require(firstSaveCall.value as? Set<Int>)
    #expect(savedIds == [character.id])
    #expect(firstSaveCall.storageKey == Storages.favouriteCharacterIds.key)

    sut.isFavouriteBinding(for: character).wrappedValue = false
    #expect(sut.favouriteCharacterIds == [])
    #expect(persistenceManager.saveCallsWithValueAndStorageKeys.count == 2)
    let secondSaveCall = try #require(persistenceManager.saveCallsWithValueAndStorageKeys.last)
    let savedIds2 = try #require(secondSaveCall.value as? Set<Int>)
    #expect(savedIds2 == [])
    #expect(secondSaveCall.storageKey == Storages.favouriteCharacterIds.key)
  }
}
