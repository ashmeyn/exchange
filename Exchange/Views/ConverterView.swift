import SwiftUI

struct ConverterView: View {
    @Bindable var viewModel = ConverterViewModel()
    @State private var isPickerPresented: Bool = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(spacing: 16) {
            if let rate = viewModel.rate {
                Text("1 USD = \(viewModel.format(rate)) \(viewModel.selectedCurrency)")
                    .foregroundColor(.green)
                    .font(.subheadline)
            }
            
            if viewModel.isUSDOnTop {
                fieldRow(text: $viewModel.usdAmount, field: .usd, currencyLabel: "USD", showsCurrencyButton: false)
                swapButton
                fieldRow(text: $viewModel.otherAmount, field: .other, currencyLabel: viewModel.selectedCurrency, showsCurrencyButton: true)
            } else {
                fieldRow(text: $viewModel.otherAmount, field: .other, currencyLabel: viewModel.selectedCurrency, showsCurrencyButton: true)
                swapButton
                fieldRow(text: $viewModel.usdAmount, field: .usd, currencyLabel: "USD", showsCurrencyButton: false)
            }
        }
        .padding()
        .onChange(of: viewModel.selectedCurrency) {
            Task { await viewModel.loadRate() }
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
        .task { await viewModel.loadRate() }
    }
    
    private var swapButton: some View {
        Button { viewModel.swap() } label: {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .font(.title2)
        }
    }
    
    @ViewBuilder
    private func fieldRow(text: Binding<String>, field: Field, currencyLabel: String, showsCurrencyButton: Bool) -> some View {
        HStack {
            if showsCurrencyButton {
                Button { isPickerPresented = true } label: {
                    Text(currencyLabel)
                }
            } else {
                Text(currencyLabel)
            }
            
            TextField("0", text: text)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: field)
                .onChange(of: text.wrappedValue) {
                    guard focusedField == field else { return }
                    viewModel.editingField = field
                    viewModel.recalculate()
                }
                .multilineTextAlignment(.trailing)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
