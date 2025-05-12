import Foundation

final class UserDefaultsPersistenceManager: PersistenceManaging {

  private let userDefaults = UserDefaults.standard

  func save<T: Encodable>(_ value: T, in storage: Storage<T>) throws {
    let data = try JSONEncoder().encode(value)
    userDefaults.set(data, forKey: storage.key)
  }

  func load<T: Decodable>(from storage: Storage<T>) throws -> T {
    guard let data = userDefaults.data(forKey: storage.key) else {
      return storage.defaultValue
    }
    return try JSONDecoder().decode(T.self, from: data)
  }
}
