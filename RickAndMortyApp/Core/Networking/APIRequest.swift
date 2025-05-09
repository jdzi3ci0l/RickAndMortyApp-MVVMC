import Foundation

struct APIRequest {
  let path: String
  let method: HTTPMethod
  let headers: [String: String]
  let parameters: [String: String]
  let body: Data?

  init(
    path: String,
    method: HTTPMethod,
    headers: [String: String] = [:],
    parameters: [String: String] = [:],
    body: Data? = nil
  ) {
    self.path = path
    self.method = method
    self.headers = headers
    self.parameters = parameters
    self.body = body
  }
}

extension URL {
  init?(baseURLString: String, request: APIRequest) {
    var urlComponents = URLComponents(string: baseURLString + request.path)
    urlComponents?.queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    guard let url = urlComponents?.url else { return nil }
    self = url
  }
}
