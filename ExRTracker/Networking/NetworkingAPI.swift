//
//  NetworkingAPI.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 30.03.2025.
//

import Foundation

//struct NetworkingAPI {
//    static var url: URL? {
//        NetworkingAPIProvider.openExchangeRates.url
//    }
//}

enum NetworkingAPIProvider: CaseIterable, Hashable {
    case openExchangeRates
    case coinGecko
    
    var url: URL? {
        switch self {
        case .openExchangeRates:
            return OpenExchangeRatesAPI.url
        case .coinGecko:
            return CoinGeckoAPI.url
        }
    }
    
    var baseCurrency: String {
        switch self {
        case .openExchangeRates:
            return Settings.shared.baseCurrency
        case .coinGecko:
            return Settings.shared.baseCurrency.lowercased()
        }
    }
}

struct OpenExchangeRatesAPI {
    static let baseUrl: String = "https://openexchangerates.org/api/"
    static let endpoint: String = "latest.json"
    static let apiKey: String = "?app_id=be0f1c331d1d403b8a122c011208f8fb"
    
    static var baseCurrency: String {
        Settings.shared.baseCurrency
    }
    static var queryParams: String {
        "&base=\(baseCurrency)"
    }
    
    static var url: URL? {
        URL(string: baseUrl + endpoint + apiKey + queryParams)
    }
    
    // https://openexchangerates.org/api/latest.json?app_id=be0f1c331d1d403b8a122c011208f8fb&base=USD
}

struct CoinGeckoAPI {
    static let baseUrl: String = "https://api.coingecko.com/api/v3/"
//    static let endpoint: String = "coins/list?"   // "simple/price"
    static let endpoint: String = "coins/markets?"
    
    static var baseCurrency: String {
        Settings.shared.baseCurrency.lowercased()
    }
    static var coinsList: String {
        Settings.shared.coins.reduce("") { partialResult, coin in
            partialResult + (partialResult.count > 0 ? "," : "") + coin
        }
    }
    static var queryParams: String {
        "vs_currency=\(baseCurrency)&ids=\(coinsList)&"
    }
    
    static let apiKey: String = "x_cg_demo_api_key=CG-M9vCbJeep3NkRnASnN2HBLnf"
    // -H "x-cg-demo-api-key: CG-M9vCbJeep3NkRnASnN2HBLnf"
    
    static var url: URL? {
        URL(string: baseUrl + endpoint + queryParams + apiKey)
    }
    
    // https://api.coingecko.com/api/v3/coins/list?x_cg_demo_api_key=CG-M9vCbJeep3NkRnASnN2HBLnf
    // https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&x_cg_demo_api_key=CG-M9vCbJeep3NkRnASnN2HBLnf
}
