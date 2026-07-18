//
//  Ticker.swift
//  Exchange
//
//  Created by Daniil Leongard on 14.07.2026.
//
import Foundation

struct Ticker: Decodable {
    let ask: String
    let bid: String
    let book: String
    let date: String
    
    
    var currencyCode: String {
        book.split(separator: "_").last?.uppercased() ?? book.uppercased()
    }
    
    var rate: Decimal? { Decimal(string: bid) }
}
