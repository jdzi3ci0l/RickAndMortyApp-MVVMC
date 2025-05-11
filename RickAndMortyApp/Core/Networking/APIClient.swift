import Foundation

// MARK: - Protocol definition

protocol APIClientProtocol {
  func performRequest<T: Decodable>(_ request: APIRequest) async throws -> T
}

// MARK: - RickAndMortyAPIClient

final class RickAndMortyAPIClient: APIClientProtocol {

  private let baseURLString = "https://rickandmortyapi.com/api"

  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func performRequest<T: Decodable>(_ request: APIRequest) async throws -> T {

    guard let url = URL(baseURLString: baseURLString, request: request) else { throw APIError.invalidURL }

    var urlRequest = URLRequest(url: url)

    urlRequest.httpMethod = request.method.rawValue
    urlRequest.allHTTPHeaderFields = request.headers

    if let body = request.body {
      urlRequest.httpBody = try JSONEncoder().encode(body)
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    let (data, response) = try await session.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponseType
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      throw APIError.serverError(statusCode: httpResponse.statusCode)
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return try decoder.decode(T.self, from: data)
  }
}
