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
          HStack {
            Text(character.name)
              .font(.title.bold())
              .multilineTextAlignment(.leading)
              .foregroundStyle(Color.textPrimary)
            Spacer()
            FavouriteToggle($viewModel.isFavourite)
              .font(.title)
          }
          basicInfo
          Divider()
          episodesSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UIConstants.defaultScreenPadding)
      }
    }
    .background(Color.background.ignoresSafeArea())
    .loadingOverlay(isLoading: viewModel.isLoading)
    .onAppear(perform: viewModel.onViewAppear)
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
    VStack(alignment: .leading, spacing: 12) {
      Text("Episodes")
        .font(.title3.bold())
        .foregroundColor(Color.textPrimary)
      + Text(" (\(character.episodeNumbers.count))")
        .font(.title3)
        .foregroundColor(Color.textSecondary)
      episodesList
    }
  }

  private var episodesList: some View {
    LazyVStack(alignment: .leading, spacing: 12) {
      ForEach(character.episodeNumbers, id: \.self) { episodeNumber in
        Button {
          Task {
            await viewModel.openEpisodeDetails(forEpisodeNumber: episodeNumber)
          }
        } label: {
          HStack {
            Text("Episode \(episodeNumber)")
              .font(.headline)
              .foregroundStyle(Color.textPrimary)
            Spacer()
            Image.chevronRight
          }
          .contentShape(Rectangle())
        }
        Divider()
      }
    }
  }
}

#if DEBUG
#Preview {
  CharacterDetailsView(
    viewModel: .init(
      character: .stubRick,
      episodesService: MockEpisodesService(),
      persistenceManager: InMemoryPersistenceManager()
    )
  )
}
#endif
