import SwiftUI

struct SpacerRespectingScrollView<Content: View>: View {

  private let showsIndicators: Bool
  private let content: Content

  init(
    showsIndicators: Bool = true,
    @ViewBuilder content: () -> Content
  ) {
    self.showsIndicators = showsIndicators
    self.content = content()
  }

  var body: some View {
    GeometryReader { proxy in
      ScrollView(showsIndicators: showsIndicators) {
        content
          .frame(minHeight: proxy.size.height)
      }
      .frame(width: proxy.size.width)
    }
  }
}
