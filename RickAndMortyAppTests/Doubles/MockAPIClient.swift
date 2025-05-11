@testable import RickAndMortyApp

final class MockAPIClient: APIClientProtocol {

  var performRequestCallsWithRequest: [APIRequest] = []
  var performRequestResult: Result<Any, Error>?

  func performRequest<T: Decodable>(_ request: APIRequest) async throws -> T {
    guard let result = performRequestResult else { fatalError("No result set for performRequest") }
    performRequestCallsWithRequest.append(request)
    switch result {
    case .success(let response):
      guard let response = response as? T else { throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Type mismatch")) }
      return response
    case .failure(let error):
      throw error
    }
  }
}
