import Testing
@testable import RickAndMortyApp

@MainActor
final class EpisodeDetailsViewModelTests {

  private var sut: EpisodeDetailsViewModel!

  init() {
    sut = EpisodeDetailsViewModel(episode: .stub)
  }

  deinit {
    sut = nil
  }

  @Test
  func initial_state() {
    #expect(sut.episode == .stub)
  }
}

