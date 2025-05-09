enum APIError: Error, Equatable {
  case invalidResponseType
  case serverError(statusCode: Int)
}
