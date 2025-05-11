import Testing
@testable import RickAndMortyApp

final class EpisodesServiceTests {

  var apiClient: MockAPIClient!
  var sut: EpisodesService!

  init() {
    apiClient = MockAPIClient()
    sut = EpisodesService(apiClient: apiClient)
  }

  deinit {
    apiClient = nil
    sut = nil
  }

  @Test
  func fetchEpisode_success() async throws {
    let expectedResponse = Episode.stub
    apiClient.performRequestResult = .success(expectedResponse)

    let result = try await sut.fetchEpisode(withNumber: 1)

    #expect(result == expectedResponse)
    #expect(apiClient.performRequestCallsWithRequest.count == 1)
    let request = try #require(apiClient.performRequestCallsWithRequest.first)
    #expect(request.path == "/episode/1")
    #expect(request.method == .get)
    #expect(request.headers.isEmpty)
    #expect(request.parameters.isEmpty)
    #expect(request.body == nil)
  }

  @Test
  func fetchCharacters_failure() async throws {
    let expectedError = APIError.serverError(statusCode: 500)
    apiClient.performRequestResult = .failure(expectedError)

    await #expect(throws: expectedError) {
      _ = try await self.sut.fetchEpisode(withNumber: 1)
    }

    #expect(apiClient.performRequestCallsWithRequest.count == 1)
    let request = try #require(apiClient.performRequestCallsWithRequest.first)
    #expect(request.path == "/episode/1")
    #expect(request.method == .get)
    #expect(request.headers.isEmpty)
    #expect(request.parameters.isEmpty)
    #expect(request.body == nil)
  }
}
