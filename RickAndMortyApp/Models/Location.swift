import Foundation

struct Location: Hashable, Codable {

  let name: String

  init(name: String) {
    self.name = name
  }
}

#if DEBUG
extension Location {
  static let stubEarth: Self = .init(name: "Earth")
}
#endif
