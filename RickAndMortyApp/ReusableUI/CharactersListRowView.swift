import SwiftUI

struct CharactersListRowView: View {

  private let character: Character

  init(character: Character) {
    self.character = character
  }

  var body: some View {
    HStack(spacing: 8) {
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
    .frame(width: 81, height: 81)
  }
}

#if DEBUG
#Preview {
  VStack {
    CharactersListRowView(character: .stubRick)
    CharactersListRowView(character: .stubMorty)
  }
}
#endif
