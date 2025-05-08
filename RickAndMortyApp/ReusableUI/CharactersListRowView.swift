import SwiftUI

struct CharactersListRowView: View {

  private let character: Character

  init(character: Character) {
    self.character = character
  }

  var body: some View {
    HStack {
      image
      Text(character.name)
        .font(.headline)
        .foregroundStyle(Color.textPrimary)
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(Color.textSecondary)
        .padding(.trailing, 8)
    }
    .padding(8)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(Color.surface)
    )
    .contentShape(Rectangle())
  }

  private var image: some View {
    AsyncImage(url: URL(string: character.imageUrlString)) { image in
      image
        .resizable()
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    } placeholder: {
      ProgressView()
    }
  }
}

#Preview {
  CharactersListRowView(
    character: .init(
      id: 1,
      name: "Rick Sanchez",
      gender: .male,
      origin: .init(
        id: 1,
        name: "Earth",
        type: "Planet",
        dimension: "Dimension C-137"
      ),
      lastKnownLocation: .init(
        id: 1,
        name: "Earth",
        type: "Planet",
        dimension: "Dimension C-137"
      ),
      imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      episodesUrlStrings: []
    )
  )
}
