import Foundation

// MARK: - Protocol definition

protocol EpisodesServiceProtocol {
  func fetchEpisode(withNumber number: Int) async throws -> Episode
}

// MARK: - EpisodesRequests

enum EpisodesRequests {
  static func episode(forNumber number: Int) -> APIRequest {
    .init(path: "/episode/\(number)", method: .get)
  }
}

// MARK: - EpisodesService

final class EpisodesService: EpisodesServiceProtocol {

  private let apiClient: APIClientProtocol

  init(apiClient: APIClientProtocol) {
    self.apiClient = apiClient
  }

  func fetchEpisode(withNumber number: Int) async throws -> Episode {
    let request = EpisodesRequests.episode(forNumber: number)
    return try await apiClient.performRequest(request)
  }
}

#if DEBUG
// MARK: - MockEpisodesService

final class MockEpisodesService: EpisodesServiceProtocol {

  var fetchEpisodeResult = Result<Episode, Error>.success(.stub)
  var fetchEpisodeCallsWithNumber = [Int]()

  func fetchEpisode(withNumber number: Int) async throws -> Episode {
    fetchEpisodeCallsWithNumber.append(number)
    switch fetchEpisodeResult {
    case .success(let episode):
      return episode
    case .failure(let error):
      throw error
    }
  }
}
#endif
