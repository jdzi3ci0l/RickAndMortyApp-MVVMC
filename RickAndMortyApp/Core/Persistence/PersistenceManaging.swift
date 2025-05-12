import Foundation

// MARK: - Protocol definition

protocol PersistenceManaging {
  func save<T: Encodable>(_ value: T, in storage: Storage<T>) throws
  func load<T: Decodable>(from storage: Storage<T>) throws -> T
}

// MARK: - PersistenceKey

struct Storage<Value: Codable> {

  let key: String
  let defaultValue: Value

  init(key: String, defaultValue: Value) {
    self.key = key
    self.defaultValue = defaultValue
  }
}

enum Storages {
  static let favouriteCharacterIds = Storage<Set<Int>>(key: "favouriteCharacterIds", defaultValue: [])
}

#if DEBUG
// MARK: - InMemoryPersistenceManager

final class InMemoryPersistenceManager: PersistenceManaging {

  private var storage: [String: Any] = [:]

  func save<T: Encodable>(_ value: T, in storage: Storage<T>) throws {
    self.storage[storage.key] = value
  }

  func load<T: Decodable>(from storage: Storage<T>) throws -> T {
    return (self.storage[storage.key] as? T) ?? storage.defaultValue
  }
}
#endif
