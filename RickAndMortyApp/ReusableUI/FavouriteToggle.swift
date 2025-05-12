import SwiftUI

struct FavouriteToggle: View {

  @Binding private var isFavourite: Bool

  init(_ isFavourite: Binding<Bool>) {
    self._isFavourite = isFavourite
  }

  var body: some View {
    Image(systemName: isFavourite ? "heart.fill" : "heart")
      .foregroundStyle(isFavourite ? Color.red : Color.textPrimary)
      .onTapGesture { isFavourite.toggle() }
  }
}

#if DEBUG
struct FavouriteTogglePreviewHelper: View {
  @State private var isFavourite: Bool = false

  var body: some View {
    FavouriteToggle($isFavourite)
      .padding()
      .background(Color.surface)
  }
}

#Preview {
  FavouriteTogglePreviewHelper()
    .font(.title)
}
#endif
