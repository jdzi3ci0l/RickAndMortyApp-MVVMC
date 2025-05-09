import Foundation

// MARK: - Protocol definition

protocol CharactersServiceProtocol {
  func fetchCharacters(page: Int) async throws -> [Character]
  func fetchCharacter(id: Int) async throws -> Character
}

// MARK: - CharactersRequests

enum CharactersRequests {
  static func characters(forPage page: Int) -> APIRequest {
    .init(path: "character", method: .get, parameters: ["page": "\(page)"])
  }

  static func character(forId id: Int) -> APIRequest {
    .init(path: "character/\(id)", method: .get)
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

  func fetchCharacter(id: Int) async throws -> Character {
    let request = CharactersRequests.character(forId: id)
    return try await apiClient.performRequest(request)
  }
}

// MARK: - CharactersResponse

struct CharactersResponse: Codable {
  let results: [Character]
}

#if DEBUG
// MARK: - MockCharactersService
final class MockCharactersService: CharactersServiceProtocol {

  var fetchCharactersResult = Result<[Character], Error>.success([.stubRick, .stubMorty])
  var fetchCharacterResult = Result<Character, Error>.success(.stubRick)

  func fetchCharacters(page: Int) async throws -> [Character] {
    switch fetchCharactersResult {
    case .success(let characters):
      return characters
    case .failure(let error):
      throw error
    }
  }

  func fetchCharacter(id: Int) async throws -> Character {
    switch fetchCharacterResult {
    case .success(let character):
      return character
    case .failure(let error):
      throw error
    }
  }
}
#endif
