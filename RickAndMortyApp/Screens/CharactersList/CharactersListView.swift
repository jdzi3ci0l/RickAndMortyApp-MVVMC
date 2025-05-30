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
    .loadingOverlay(isLoading: viewModel.isPerformingInitialLoad)
    .alert(item: $viewModel.alertItem)
    .animation(.easeInOut, value: viewModel.isLoading)
    .toolbar { navigationBarTrailingResetButton }
    .onAppear(perform: viewModel.onViewAppear)
  }

  private func charactersList(characters: [Character]) -> some View {
    LazyVStack(spacing: 12) {
      ForEach(characters) { character in
        Button {
          viewModel.selectCharacter(character)
        } label: {
          CharactersListRowView(
            character: character,
            isFavourite: viewModel.isFavouriteBinding(for: character)
          )
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
        Button("Reset", action: viewModel.resetCharacters)
          .foregroundStyle(Color.sauceRed)
      }
    }
  }
}

#if DEBUG
#Preview("Success") {
  let service = MockCharactersService()
  service.fetchCharactersResult = .success([.stubRick, .stubMorty])
  return NavigationView {
    CharactersListView(
      viewModel: .init(
        charactersService: service,
        persistenceManager: InMemoryPersistenceManager()
      )
    )
    .navigationTitle("Characters")
  }
}

#Preview("Error") {
  let service = MockCharactersService()
  service.fetchCharactersResult = .failure(APIError.serverError(statusCode: 500))
  return NavigationView {
    CharactersListView(
      viewModel: .init(
        charactersService: service,
        persistenceManager: InMemoryPersistenceManager()
      )
    )
    .navigationTitle("Characters")
  }
}
#endif
