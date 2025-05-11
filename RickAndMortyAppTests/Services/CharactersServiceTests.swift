import Testing
@testable import RickAndMortyApp

final class CharactersServiceTests {

  var apiClient: MockAPIClient!
  var sut: CharactersService!

  init() {
    apiClient = MockAPIClient()
    sut = CharactersService(apiClient: apiClient)
  }

  deinit {
    apiClient = nil
    sut = nil
  }

  @Test
  func fetchCharacters_success() async throws {
    let expectedResponse = CharactersResponse(results: [.stubRick, .stubMorty])
    apiClient.performRequestResult = .success(expectedResponse)

    let result = try await sut.fetchCharacters(page: 1)

    #expect(result == [.stubRick, .stubMorty])
    #expect(apiClient.performRequestCallsWithRequest.count == 1)
    let request = try #require(apiClient.performRequestCallsWithRequest.first)
    #expect(request.path == "/character")
    #expect(request.method == .get)
    #expect(request.headers.isEmpty)
    #expect(request.parameters.count == 1)
    #expect(request.parameters["page"] == "1")
    #expect(request.body == nil)
  }

  @Test
  func fetchCharacters_failure() async throws {
    let expectedError = APIError.serverError(statusCode: 500)
    apiClient.performRequestResult = .failure(expectedError)

    await #expect(throws: expectedError) {
      _ = try await self.sut.fetchCharacters(page: 1)
    }

    #expect(apiClient.performRequestCallsWithRequest.count == 1)
    let request = try #require(apiClient.performRequestCallsWithRequest.first)
    #expect(request.path == "/character")
    #expect(request.method == .get)
    #expect(request.headers.isEmpty)
    #expect(request.parameters.count == 1)
    #expect(request.parameters["page"] == "1")
    #expect(request.body == nil)
  }
}
