import Foundation

struct APIRequest {
  let path: String
  let method: HTTPMethod
  let headers: [String: String] = [:]
  let body: Data? = nil
}
