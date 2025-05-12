import Foundation

enum APIError: Error, Equatable {
  case invalidURL
  case invalidResponseType
  case serverError(statusCode: Int)
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "The provided URL is invalid."
    case .invalidResponseType:
      return "The response type is invalid."
    case .serverError(let statusCode):
      return "Server error occured. Status code: \(statusCode)"
    }
  }
}
