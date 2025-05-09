import Foundation

struct Character: Identifiable, Hashable, Codable {

  let id: Int
  let name: String
  let gender: Gender
  let origin: Location
  let lastKnownLocation: Location
  let imageUrlString: String
  let episodesUrlStrings: [String]

  init(
    id: Int,
    name: String,
    gender: Gender,
    origin: Location,
    lastKnownLocation: Location,
    imageUrlString: String,
    episodesUrlStrings: [String]
  ) {
    self.id = id
    self.name = name
    self.gender = gender
    self.origin = origin
    self.lastKnownLocation = lastKnownLocation
    self.imageUrlString = imageUrlString
    self.episodesUrlStrings = episodesUrlStrings
  }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case gender
    case origin
    case lastKnownLocation = "location"
    case imageUrlString = "image"
    case episodesUrlStrings = "episode"
  }
}

#if DEBUG
extension Character {
  static let stubRick: Self = .init(
    id: 1,
    name: "Rick Sanchez",
    gender: .male,
    origin: .stubEarth,
    lastKnownLocation: .stubEarth,
    imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
    episodesUrlStrings: [
      "https://rickandmortyapi.com/api/episode/1",
      "https://rickandmortyapi.com/api/episode/2"
    ]
  )

  static let stubMorty: Self = .init(
    id: 2,
    name: "Morty Smith",
    gender: .male,
    origin: .stubEarth,
    lastKnownLocation: .stubEarth,
    imageUrlString: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
    episodesUrlStrings: [
      "https://rickandmortyapi.com/api/episode/1",
      "https://rickandmortyapi.com/api/episode/2"
    ]
  )
}
#endif
