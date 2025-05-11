import Testing
@testable import RickAndMortyApp

@MainActor
final class CharacterDetailsViewModelTests {

  private var service: MockEpisodesService!
  private var delegate: CharacterDetailsNavigationDelegateSpy!
  private var sut: CharacterDetailsViewModel!

  init() {
    service = MockEpisodesService()
    delegate = CharacterDetailsNavigationDelegateSpy()
    sut = CharacterDetailsViewModel(character: .stubRick, episodesService: service)
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
  }

  @Test("openEpisodeDetails calls navigationDelegate on API call success")
  func openEpisodeDetails_success() async {
    await sut.openEpisodeDetails(forEpisodeNumber: 1)

    #expect(service.fetchEpisodeCallsWithNumber == [1])
    #expect(delegate.didOpenEpisodeDetailsCallsWithEpisode == [.stub])
  }

  @Test("openEpisodeDetails does not call navigationDelegate on API call failure")
  func openEpisodeDetails_failure() async {
    service.fetchEpisodeResult = .failure(APIError.serverError(statusCode: 500))

    await sut.openEpisodeDetails(forEpisodeNumber: 1)

    #expect(service.fetchEpisodeCallsWithNumber == [1])
    #expect(delegate.didOpenEpisodeDetailsCallsWithEpisode.isEmpty)
  }
}
