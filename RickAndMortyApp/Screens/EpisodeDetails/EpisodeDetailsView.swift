import SwiftUI

struct EpisodeDetailsView: View {

  @ObservedObject private var viewModel: EpisodeDetailsViewModel

  init(viewModel: EpisodeDetailsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Episode \(episode.id)")
        .font(.title.bold())
      Text(episode.name)
        .font(.title.bold())
      Text(episode.episode)
        .font(.title2.bold())
        .foregroundStyle(Color.textSecondary)
      Text("Air date: \(episode.airDate)")
        .font(.headline)
      Text("Characters count: \(episode.characterIds.count)")
        .font(.headline)
      Spacer()
    }
    .foregroundStyle(Color.textPrimary)
    .multilineTextAlignment(.leading)
    .padding(UIConstants.defaultScreenPadding)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.background.ignoresSafeArea())
  }

  private var episode: Episode { viewModel.episode }
}

#if DEBUG
#Preview {
  EpisodeDetailsView(viewModel: .init(episode: .stub))
}
#endif
