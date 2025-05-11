import SwiftUI

struct EpisodeDetailsView: View {

  @ObservedObject private var viewModel: EpisodeDetailsViewModel

  init(viewModel: EpisodeDetailsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    Text("Hello, \(viewModel.episode.episode)")
  }
}

#if DEBUG
#Preview {
  EpisodeDetailsView(viewModel: .init(episode: .stub))
}
#endif
