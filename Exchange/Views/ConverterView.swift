import SwiftUI

struct ConverterView: View {
    @Bindable var viewModel = ConverterViewModel()
    
    var body: some View {
        VStack {
            TextField("0", text: $viewModel.usdAmount)
                .onChange(of: viewModel.usdAmount) {
                    viewModel.editingField = .usd
                    viewModel.recalculate()
            }
            Text("⇅")
            TextField("0", text: $viewModel.otherAmount)
                .onChange(of: viewModel.otherAmount) {
                    viewModel.editingField = .other
                    viewModel.recalculate()
                }
        }
        .task {
            await viewModel.loadRate()
        }
    }
}
