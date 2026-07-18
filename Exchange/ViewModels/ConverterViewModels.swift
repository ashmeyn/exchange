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
    
    
}
