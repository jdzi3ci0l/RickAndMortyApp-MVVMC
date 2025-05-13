import Testing
@testable import RickAndMortyApp

@MainActor
final class CharacterDetailsViewModelTests {

  private var service: MockEpisodesService!
  private var persistenceManager: MockPersistenceManager!
  private var delegate: CharacterDetailsNavigationDelegateSpy!
  private var sut: CharacterDetailsViewModel!

  init() {
    service = MockEpisodesService()
    persistenceManager = MockPersistenceManager()
    delegate = CharacterDetailsNavigationDelegateSpy()
    sut = CharacterDetailsViewModel(
      character: .stubRick,
      episodesService: service,
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
    #expect(sut.character == .stubRick)
    #expect(sut.isFavourite == false)
    #expect(sut.isLoading == false)
    #expect(sut.alertItem == nil)
  }

  @Test("onViewAppear refreshes favourite status from Storage")
  func onViewAppear() throws {
    try persistenceManager.save([Character.stubRick.id], in: Storages.favouriteCharacterIds)
    sut.onViewAppear()
    #expect(persistenceManager.loadCallsWithStorageKeys == [Storages.favouriteCharacterIds.key])
    #expect(sut.isFavourite == true)
  }

  @Test("Setting isFavourite to true adds character to favourites storage")
  func isFavourite_set_to_true() throws {
    sut.isFavourite = true

    #expect(persistenceManager.loadCallsWithStorageKeys.count == 1)
    #expect(persistenceManager.saveCallsWithValueAndStorageKeys.count == 1)

    let saveCall = try #require(persistenceManager.saveCallsWithValueAndStorageKeys.first)
    let savedIds = try #require(saveCall.value as? Set<Int>)
    #expect(savedIds == [Character.stubRick.id])
    #expect(saveCall.storageKey == Storages.favouriteCharacterIds.key)
  }

  @Test("Setting isFavourite to false removes character from favourites")
  func isFavourite_set_to_false() throws {
    // First load
    persistenceManager.storage[Storages.favouriteCharacterIds.key] = Set([Character.stubRick.id])
    sut.onViewAppear()
    #expect(sut.isFavourite == true)

    // Then remove
    sut.isFavourite = false

    #expect(persistenceManager.loadCallsWithStorageKeys == [
      Storages.favouriteCharacterIds.key,
      Storages.favouriteCharacterIds.key
    ], "Expected to load favourite character ids twice: once for initial load and once for the update")
    #expect(persistenceManager.saveCallsWithValueAndStorageKeys.count == 1)

    let saveCall = try #require(persistenceManager.saveCallsWithValueAndStorageKeys.first)
    let savedIds = try #require(saveCall.value as? Set<Int>)
    #expect(savedIds == [])
    #expect(saveCall.storageKey == Storages.favouriteCharacterIds.key)
  }

  @Test("openEpisodeDetails calls navigationDelegate on API call success")
  func openEpisodeDetails_success() async {
    await sut.openEpisodeDetails(forEpisodeNumber: 1)

    #expect(service.fetchEpisodeCallsWithNumber == [1])
    #expect(delegate.didOpenEpisodeDetailsCallsWithEpisode == [.stub])
  }

  @Test("openEpisodeDetails sets alertItem on API call failure")
  func openEpisodeDetails_failure() async throws {
    let error = APIError.serverError(statusCode: 500)
    service.fetchEpisodeResult = .failure(error)

    await sut.openEpisodeDetails(forEpisodeNumber: 1)

    #expect(service.fetchEpisodeCallsWithNumber == [1])
    #expect(delegate.didOpenEpisodeDetailsCallsWithEpisode.isEmpty)
    let item = try #require(sut.alertItem)
    #expect(item.isEqualIgnoringActions(to: AlertItem(fromError: error)))
  }
}
