import Foundation

// MARK: - Protocol definition

protocol APIClientProtocol {
  func performRequest<T: Decodable>(_ request: APIRequest) async throws -> T
}

// MARK: - RickAndMortyAPIClient

final class RickAndMortyAPIClient: APIClientProtocol {

  private let baseURL: URL
  private let session: URLSession

  init(baseURL: URL, session: URLSession = .shared) {
    self.baseURL = baseURL
    self.session = session
  }

  func performRequest<T: Decodable>(_ request: APIRequest) async throws -> T {

    let url = baseURL.appendingPathComponent(request.path)
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

    return try JSONDecoder().decode(T.self, from: data)
  }
}
