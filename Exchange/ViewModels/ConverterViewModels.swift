import Foundation

enum Field {
    case usd
    case other
}

@Observable
final class ConverterViewModel {
    
    private let service = ExchangeService()
    
    
    var usdAmount: String = ""
    var otherAmount: String = ""
    var selectedCurrency: String = "MXN"
    var rate: Decimal? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var editingField: Field = .usd
    var isUSDOnTop: Bool = true

    func recalculate() {
        /*
         если нет курса → выходим (нечего считать)
             
             если главный = USD:
                 other = usd × rate
             иначе:
                 usd = other ÷ rate
         */
        
        guard let rate else { return }
        switch editingField {
        case .usd:
            guard let usdValue = Decimal(string: usdAmount) else { return }
            let result = usdValue * rate
            otherAmount = "\(result)"
        case .other:
            guard let otherValue = Decimal(string: otherAmount) else { return }
            guard rate != 0 else { return }
            let result = otherValue / rate
            usdAmount = "\(result)"
        }
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
        } catch {
            errorMessage = "Не удалось загрузить курс"
            }
            
    }
    
}
