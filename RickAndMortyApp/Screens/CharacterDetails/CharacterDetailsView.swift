import SwiftUI

struct CharacterDetailsView: View {

  @ObservedObject private var viewModel: CharacterDetailsViewModel

  init(viewModel: CharacterDetailsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        characterImage
        VStack(alignment: .leading, spacing: 12) {
          Text(character.name)
            .font(.title.bold())
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.textPrimary)
          basicInfo
          Divider()
          episodesSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UIConstants.defaultScreenPadding)
      }
    }
    .background(Color.background.ignoresSafeArea())
    .ignoresSafeArea(edges: .top)
  }

  private var character: Character { viewModel.character }

  private var characterImage: some View {
    GeometryReader { geometry in
      AsyncImage(url: URL(string: character.imageUrlString)) { image in
        image
          .resizable()
          .scaledToFit()
      } placeholder: {
        LoadingIndicatorView()
          .frame(width: 81, height: 81)
      }
      .frame(width: geometry.size.width, height: geometry.size.width)
      .background(Color.surface)
    }
    .aspectRatio(1, contentMode: .fit)
  }

  private var basicInfo: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Status: \(character.status.rawValue.capitalized)")
      Text("Gender: \(character.gender.rawValue.capitalized)")
      Text("Origin: \(character.origin.name)")
      Text("Last seen: \(character.lastKnownLocation.name)")
    }
    .font(.headline)
    .foregroundStyle(Color.textPrimary)
  }

  private var episodesSection: some View {
    VStack(spacing: 12) {
      Text("Episodes")
        .font(.title3.bold())
        .foregroundStyle(Color.textPrimary)
    }
  }
}

#if DEBUG
#Preview {
  CharacterDetailsView(viewModel: .init(character: .stubRick))
}
#endif
