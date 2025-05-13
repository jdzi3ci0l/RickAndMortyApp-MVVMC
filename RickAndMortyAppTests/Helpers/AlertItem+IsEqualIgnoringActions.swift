@testable import RickAndMortyApp

extension AlertItem {

  func isEqualIgnoringActions(to other: AlertItem) -> Bool {
    return title == other.title &&
      message == other.message &&
      buttons.map(\.title) == other.buttons.map(\.title)
  }
}
