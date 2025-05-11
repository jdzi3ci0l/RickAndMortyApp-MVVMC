import Foundation

struct Character: Identifiable, Hashable {

  let id: Int
  let name: String
  let gender: Gender
  let status: CharacterStatus
  let origin: Location
  let lastKnownLocation: Location
  let imageUrlString: String
  let episodeNumbers: [Int]

  init(
    id: Int,
    name: String,
    gender: Gender,
    status: CharacterStatus,
    origin: Location,
    lastKnownLocation: Location,
    imageUrlString: String,
    episodeNumbers: [Int]
  ) {
    self.id = id
    self.name = name
    self.gender = gender
    self.status = status
    self.origin = origin
    self.lastKnownLocation = lastKnownLocation
    self.imageUrlString = imageUrlString
    self.episodeNumbers = episodeNumbers
  }
}

extension Character: Decodable {

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case gender
    case status
    case origin
    case lastKnownLocation = "location"
    case imageUrlString = "image"
    case episodeNumbers = "episode"
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.gender = try container.decode(Gender.self, forKey: .gender)
    self.status = try container.decode(CharacterStatus.self, forKey: .status)
    self.origin = try container.decode(Location.self, forKey: .origin)
    self.lastKnownLocation = try container.decode(Location.self, forKey: .lastKnownLocation)
    self.imageUrlString = try container.decode(String.self, forKey: .imageUrlString)
    let episodeUrlStrings = try container.decode([String].self, forKey: .episodeNumbers)
    self.episodeNumbers = episodeUrlStrings.compactMap {
      let components = $0.split(separator: "/")
      return components.last.flatMap { Int($0) }
    }
  }
}

#if DEBUG
extension Character {
  static let stubRick: Self = .init(
    id: 1,
    name: "Rick Sanchez",
    gender: .male,
    status: .alive,
    origin: .stubEarth,
    lastKnownLocation: .stubEarth,
    imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
    episodeNumbers: [1, 2]
  )

  static let stubMorty: Self = .init(
    id: 2,
    name: "Morty Smith",
    gender: .male,
    status: .alive,
    origin: .stubEarth,
    lastKnownLocation: .stubEarth,
    imageUrlString: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
    episodeNumbers: [1, 2]
  )
}
#endif
