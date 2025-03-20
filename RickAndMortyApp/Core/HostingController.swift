import SwiftUI

class HostingController<Content: View, VM: BaseViewModel>: UIHostingController<Content> {

  var viewModel: VM

  init(rootView: Content, viewModel: VM) {
    self.viewModel = viewModel
    super.init(rootView: rootView)
    viewModel.hostingController = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
