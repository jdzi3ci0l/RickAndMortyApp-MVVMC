import SwiftUI

struct CharactersListView: View {

  @ObservedObject private var viewModel: CharactersListViewModel

  init(viewModel: CharactersListViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    SpacerRespectingScrollView {
      Group {
        if let characters = viewModel.characters {
          charactersList(characters: characters)
        } else {
          initialInfoView
        }
      }
      .padding(UIConstants.defaultScreenPadding)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    .background(Color.background.ignoresSafeArea())
    .loadingOverlay(isLoading: viewModel.shouldUseFullScreenLoadingOverlay)
    .animation(.easeInOut, value: viewModel.isLoading)
    .toolbar { navigationBarTrailingResetButton }
  }

  private func charactersList(characters: [Character]) -> some View {
    LazyVStack(spacing: 12) {
      ForEach(characters) { character in
        Button {
          viewModel.selectCharacter(character)
        } label: {
          CharactersListRowView(character: character)
            .task {
              await viewModel.loadMoreCharactersIfNeeded(currentCharacterId: character.id)
            }
        }
      }
      if viewModel.isLoading && characters.isNotEmpty {
        LoadingIndicatorView()
          .frame(width: 34, height: 34)
      }
    }
    .padding(.bottom, 16)
  }

  private var initialInfoView: some View {
    VStack(spacing: 12) {
      Spacer()
      Text("To get started, tap the button below to load characters.")
        .font(.title)
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.textPrimary)
      Button("Load Characters") {
        Task { await viewModel.loadCharacters() }
      }
      .buttonStyle(ActionButtonStyle.primary)
      Spacer()
    }
  }

  private var navigationBarTrailingResetButton: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      if !viewModel.isLoading {
        Button("Reset", action: viewModel.reset)
          .foregroundStyle(Color.sauceRed)
      }
    }
  }
}

#if DEBUG
#Preview {
  NavigationView {
    CharactersListView(viewModel: .init(charactersService: MockCharactersService()))
      .navigationTitle("Characters")
  }
}
#endif
