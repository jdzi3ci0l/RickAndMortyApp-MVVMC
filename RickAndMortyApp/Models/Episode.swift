import Foundation

struct Episode: Hashable {

  let id: Int
  let name: String
  let airDate: String
  let episode: String
  let characterIds: [Int]

  init(
    id: Int,
    name: String,
    airDate: String,
    episode: String,
    characterIds: [Int]
  ) {
    self.id = id
    self.name = name
    self.airDate = airDate
    self.episode = episode
    self.characterIds = characterIds
  }
}

extension Episode: Decodable {

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case airDate
    case episode
    case characterIds = "characters"
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.airDate = try container.decode(String.self, forKey: .airDate)
    self.episode = try container.decode(String.self, forKey: .episode)
    let characterUrls = try container.decode([String].self, forKey: .characterIds)
    self.characterIds = characterUrls.compactMap {
      let components = $0.split(separator: "/")
      return components.last.flatMap { Int($0) }
    }
  }
}

#if DEBUG
extension Episode {
  static let stub: Self = .init(
    id: 1,
    name: "Pilot",
    airDate: "December 2, 2013",
    episode: "S01E01",
    characterIds: [1, 2]
  )
}
#endif
