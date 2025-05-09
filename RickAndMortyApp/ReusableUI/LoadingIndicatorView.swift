import SwiftUI

struct LoadingIndicatorView: View {

  var body: some View {
    TimelineView(.animation) { context in
      let angle = context.date.timeIntervalSinceReferenceDate * 180
      Image.loadingIndicator
        .resizable()
        .scaledToFit()
        .rotationEffect(.degrees(angle))
    }
  }
}

#if DEBUG
#Preview {
  LoadingIndicatorView()
}
#endif
