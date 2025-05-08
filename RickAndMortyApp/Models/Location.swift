import Foundation

struct Location: Identifiable, Hashable, Codable {

  let id: Int
  let name: String
  let type: String
  let dimension: String

  init(
    id: Int,
    name: String,
    type: String,
    dimension: String
  ) {
    self.id = id
    self.name = name
    self.type = type
    self.dimension = dimension
  }
}

#if DEBUG
extension Location {
  static let stubEarth: Self = .init(
    id: 1,
    name: "Earth",
    type: "Planet",
    dimension: "Dimension C-137"
  )
}
#endif
