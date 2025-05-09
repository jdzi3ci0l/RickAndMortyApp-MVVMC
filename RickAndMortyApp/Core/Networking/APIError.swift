enum APIError: Error, Equatable {
  case invalidURL
  case invalidResponseType
  case serverError(statusCode: Int)
}
