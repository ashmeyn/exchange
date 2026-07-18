//
//  ExchangeService.swift
//  Exchange
//
//  Created by Daniil Leongard on 14.07.2026.
//

import Foundation

enum ExchangeError: Error {
    case invalidURL
    case badResponse
}

struct ExchangeService {
    private let baseURL = "https://api.dolarapp.dev/v1"
    
    func fetchTickers(for curriencies: [String]) async throws -> [Ticker] {
        
        // адрес
        let codes = curriencies.joined(separator: ",")
        guard let url = URL(string: "\(baseURL)/tickers?currencies=\(codes)") else {
            throw ExchangeError.invalidURL
        }
        
        // запрос и байты
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        // проверка сервер вообще ответил "ок"?
        guard let http = responce as? HTTPURLResponse, http.statusCode == 200 else {
            throw ExchangeError.badResponse
        }
        
        // распаковка
        return try JSONDecoder().decode([Ticker].self, from: data)
    }
    
}
