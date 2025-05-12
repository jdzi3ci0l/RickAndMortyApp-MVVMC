import SwiftUI

struct LoadingOverlay<Content: View>: View {

  private let isLoading: Bool
  private let content: Content

  @State private var rotationAngle: Double = 0
  @State private var scale: CGFloat = 1

  init(
    isLoading: Bool,
    @ViewBuilder content: () -> Content
  ) {
    self.isLoading = isLoading
    self.content = content()
  }

  var body: some View {
    ZStack {
      content
        .allowsHitTesting(!isLoading)
        .overlay(loadingOverlay)
    }
  }

  private var loadingOverlay: some View {
    Group {
      if isLoading {
        Color.black.opacity(0.5)
          .edgesIgnoringSafeArea(.all)
        LoadingIndicatorView()
          .frame(width: 81, height: 81)
      }
    }
  }
}

extension View {
  func loadingOverlay(isLoading: Bool) -> some View {
    LoadingOverlay(isLoading: isLoading) { self }
  }
}

#if DEBUG
#Preview {
  LoadingOverlay(isLoading: true) {
    Color.background.ignoresSafeArea()
  }
}
#endif
