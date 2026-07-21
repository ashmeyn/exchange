import Foundation

enum Field {
    case usd
    case other
}

@Observable
final class ConverterViewModel {
    
    private let service = ExchangeService()
    
    let availableCurrencies = ["MXN", "ARS", "COP", "BRL", "EURC"]
    var usdAmount: String = ""
    var otherAmount: String = ""
    var selectedCurrency: String = "MXN"
    var rate: Decimal? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var editingField: Field = .usd
    var isUSDOnTop: Bool = true

    func recalculate() {
        guard let rate else { return }
                
        switch editingField {
        case .usd:
            guard let usdValue = Decimal(string: usdAmount) else {
                return
            }
            let result = usdValue * rate
            otherAmount = format(result)
            
        case .other:
            guard let otherValue = Decimal(string: otherAmount) else {
                return
            }
            guard rate != 0 else {
                return
            }
            let result = otherValue / rate
            usdAmount = format(result)
        }
    }
    
    private func format(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "\(value)"
    }
    
    func swap() {
        isUSDOnTop.toggle()
    }
    
    
    func loadRate() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let tickers = try await service.fetchTickers(for: [selectedCurrency])
            print(tickers)
            
            guard let ticker = tickers.first(where: {$0.currencyCode == selectedCurrency}) else {
                errorMessage = "Валюта не найдена"
                return
            }
                self.rate = ticker.rate
            recalculate()
        } catch {
            errorMessage = "Не удалось загрузить курс"
            }
            
    }
    
}
