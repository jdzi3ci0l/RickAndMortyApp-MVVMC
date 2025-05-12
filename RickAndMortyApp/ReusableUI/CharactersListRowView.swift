import SwiftUI

struct CharactersListRowView: View {

  private let character: Character
  @Binding private var isFavourite: Bool

  init(character: Character, isFavourite: Binding<Bool>) {
    self.character = character
    self._isFavourite = isFavourite
  }

  var body: some View {
    HStack(spacing: 8) {
      image
      Text(character.name)
        .font(.headline)
        .multilineTextAlignment(.leading)
        .foregroundStyle(Color.textPrimary)
      Spacer()
      HStack(spacing: 12) {
        FavouriteToggle($isFavourite)
          .foregroundStyle(Color.textPrimary)
          .font(.title3)
        Image.chevronRight
          .foregroundStyle(Color.textSecondary)
          .padding(.trailing, 8)
      }
    }
    .padding(8)
    .background(
      RoundedRectangle(
        cornerRadius: UIConstants.defaultCardCornerRadius,
        style: .continuous
      )
      .fill(Color.surface)
    )
    .contentShape(Rectangle())
  }

  private var image: some View {
    AsyncImage(url: URL(string: character.imageUrlString)) { image in
      image
        .resizable()
        .scaledToFit()
        .clipShape(
          RoundedRectangle(
            cornerRadius: UIConstants.defaultCardCornerRadius,
            style: .continuous
          )
        )
    } placeholder: {
      LoadingIndicatorView()
        .frame(width: 28, height: 28)
    }
    .frame(width: 81, height: 81)
  }
}

#if DEBUG
#Preview {
  VStack {
    CharactersListRowView(character: .stubRick, isFavourite: .constant(false))
    CharactersListRowView(character: .stubMorty, isFavourite: .constant(true))
  }
  .padding(UIConstants.defaultScreenPadding)
  .background(Color.background)
}
#endif
