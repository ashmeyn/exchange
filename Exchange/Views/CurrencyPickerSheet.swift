import SwiftUI

struct CurrencyPickerSheet: View {
    let currencies: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        List(currencies, id: \.self) { currency in
            Button { onSelect(currency)} label: { Text(currency) }
        }
    }
}
