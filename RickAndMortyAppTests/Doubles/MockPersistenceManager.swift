@testable import RickAndMortyApp
import Foundation

final class MockPersistenceManager: PersistenceManaging {

  private(set) var saveCallsWithValueAndStorageKeys: [(value: Encodable, storageKey: String)] = []
  private(set) var loadCallsWithStorageKeys: [String] = []

  var storage: [String: Any] = [:]

  func save<T: Encodable>(_ value: T, in storage: Storage<T>) throws {
    self.saveCallsWithValueAndStorageKeys.append((value: value, storageKey: storage.key))
    self.storage[storage.key] = value
  }

  func load<T: Decodable>(from storage: Storage<T>) throws -> T {
    self.loadCallsWithStorageKeys.append(storage.key)
    return (self.storage[storage.key] as? T) ?? storage.defaultValue
  }
}
