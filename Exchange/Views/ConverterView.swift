import SwiftUI

struct ConverterView: View {
    @Bindable var viewModel = ConverterViewModel()
    @State private var isPickerPresented: Bool = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            if viewModel.isUSDOnTop {
                TextField("0", text: $viewModel.usdAmount)
                    .focused($focusedField, equals: .usd)
                    .onChange(of: viewModel.usdAmount) {
                        guard focusedField == .usd else { return }
                        viewModel.editingField = .usd
                        viewModel.recalculate()
                }
                Button { viewModel.swap() } label: { Text("⇅") }
                Button { isPickerPresented = true } label: { Text(viewModel.selectedCurrency) }
                TextField("0", text: $viewModel.otherAmount)
                    .focused($focusedField, equals: .other)
                    .onChange(of: viewModel.otherAmount) {
                        guard focusedField == .other else { return }
                        viewModel.editingField = .other
                        viewModel.recalculate()
                    }
            } else {
                Button { isPickerPresented = true } label: { Text(viewModel.selectedCurrency) }
                TextField("0", text: $viewModel.otherAmount)
                    .focused($focusedField, equals: .other)
                    .onChange(of: viewModel.otherAmount) {
                        guard focusedField == .other else { return }
                        viewModel.editingField = .other
                        viewModel.recalculate()
                }
                Button { viewModel.swap() } label: { Text("⇅") }
                TextField("0", text: $viewModel.usdAmount)
                    .focused($focusedField, equals: .usd)
                    .onChange(of: viewModel.usdAmount) {
                        guard focusedField == .usd else { return }
                        viewModel.editingField = .usd
                        viewModel.recalculate()
                    }
            }
        }
        .onChange(of: viewModel.selectedCurrency) {
            Task {
                await viewModel.loadRate()
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            CurrencyPickerSheet(
                currencies: viewModel.availableCurrencies,
                onSelect: { currency in
                    viewModel.selectedCurrency = currency
                    isPickerPresented = false
                }
            )
        }
    }
}
