import Foundation

// MARK: - Protocol definition

protocol CharactersServiceProtocol {
  func fetchCharacters(page: Int) async throws -> [Character]
}

// MARK: - CharactersRequests

enum CharactersRequests {
  static func characters(forPage page: Int) -> APIRequest {
    .init(path: "/character", method: .get, parameters: ["page": "\(page)"])
  }
}

// MARK: - CharactersService

final class CharactersService: CharactersServiceProtocol {

  private let apiClient: APIClientProtocol

  init(apiClient: APIClientProtocol) {
    self.apiClient = apiClient
  }

  func fetchCharacters(page: Int) async throws -> [Character] {
    let request = CharactersRequests.characters(forPage: page)
    let response: CharactersResponse = try await apiClient.performRequest(request)
    return response.results
  }
}

#if DEBUG
// MARK: - MockCharactersService
final class MockCharactersService: CharactersServiceProtocol {

  var fetchCharactersResult = Result<[Character], Error>.success([.stubRick, .stubMorty])
  var fetchCharactersCallsWithPage = [Int]()

  func fetchCharacters(page: Int) async throws -> [Character] {
    fetchCharactersCallsWithPage.append(page)
    switch fetchCharactersResult {
    case .success(let characters):
      return characters
    case .failure(let error):
      throw error
    }
  }
}
#endif
