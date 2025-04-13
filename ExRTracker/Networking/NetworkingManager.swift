//
//  NetworkingManager.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 30.03.2025.
//

import Foundation

final class NetworkingManager: ObservableObject {
    static let shared = NetworkingManager()
    
    private init() {
    }
    
    func getExchangeRates() async throws -> ExchangeRates {
        guard let url = OpenExchangeRatesAPI.url else {
            throw NetworkingError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkingError.invalidResponse
        }
        
        do {
//            try await Task.sleep(for: .seconds(1))
            return try JSONDecoder().decode(ExchangeRates.self, from: data)
        } catch {
            throw NetworkingError.invalidData
        }
    }
    
    func getCoinGeckoCoinInfos() async throws -> [CoinGeckoCoinInfo] {
        guard let url = CoinGeckoAPI.url else {
            throw NetworkingError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkingError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([CoinGeckoCoinInfo].self, from: data)
        } catch {
            throw NetworkingError.invalidData
        }
    }
}
