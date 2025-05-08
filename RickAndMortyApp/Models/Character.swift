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
