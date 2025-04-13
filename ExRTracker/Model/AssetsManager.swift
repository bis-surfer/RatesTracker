//
//  AssetsManager.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 05.04.2025.
//

import Foundation

final class AssetsManager {
    static let shared = AssetsManager()
    
    @Published var selectedAssets: [Asset] = AppStorageManager.shared.selectedAssets ?? initialAssetsSelection {
        didSet {
            for asset in selectedAssets {
                knownAssets[asset.symbol] = asset
            }
        }
    }
    @Published var modifiedSelectedAssets: [Asset] = []
    
    @Published var knownAssets: [String: Asset] = initiallyKnownAssets
    
#if true
    var allAssets: [Asset] {
        knownAssets.compactMap { (symbol, asset) in
            var exchangeRate: Double? = nil
            if let inverseExchangeRate = AppStorageManager.shared.exchangeRates?.rates[symbol] {
                exchangeRate = 1.0 / inverseExchangeRate
            }
            return Asset(symbol: symbol, name: asset.name, isCrypto: asset.isCrypto, unicodeSign: asset.unicodeSign, imageUrl: asset.imageUrl, exchangeRate: exchangeRate)
        }
        .sorted { assetOne, assetTwo in
            assetOne.symbol < assetTwo.symbol
        }
    }
#else
    var allAssets: [Asset] {
        (AppStorageManager.shared.exchangeRates?.rates.compactMap { (symbol, rate) in
            if let knownAsset = knownAssets[symbol] {
                return Asset(symbol: symbol, name: knownAsset.name, unicodeSign: knownAsset.unicodeSign, exchangeRate: 1.0 / rate)
            } else {
                return Asset(symbol: symbol, name: symbol, exchangeRate: 1.0 / rate)
            }
        } ?? AssetsManager.initialAssetsSelection)
        .sorted { assetOne, assetTwo in
            assetOne.symbol < assetTwo.symbol
        }
    }
#endif
    
    private init() {
    }
    
    func storeSelectedAssets() {
        AppStorageManager.shared.setSelectedAssets(selectedAssets)
    }
}

extension AssetsManager {
    static var initialAssetsSelection: [Asset] {
        [
            Asset(symbol: "USD", name: "US Dollar", unicodeSign: "\u{0024}"),
            Asset(symbol: "EUR", name: "Euro", unicodeSign: "\u{20AC}"),
            Asset(symbol: "UAH", name: "Ukraine Hryvnia", unicodeSign: "\u{20b4}"),
            Asset(symbol: "BTC", name: "Bitcoin", isCrypto: true, unicodeSign: "\u{20BF}", imageUrl: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"),
            Asset(symbol: "ETH", name: "Ethereum", isCrypto: true, unicodeSign: "\u{039E}", imageUrl:     "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628")
        ]
    }
}

extension AssetsManager {
    static var initiallyKnownAssets: [String: Asset] {
        [
            "ALL" : Asset(symbol: "ALL", name: "Albania Lek", unicodeSign: "\u{004c}\u{0065}\u{006b}"),
            "AFN" : Asset(symbol: "AFN", name: "Afghanistan Afghani", unicodeSign: "\u{060b}"),
            "ARS" : Asset(symbol: "ARS", name: "Argentina Peso", unicodeSign: "\u{0024}"),
            "AWG" : Asset(symbol: "AWG", name: "Aruba Guilder", unicodeSign: "\u{0192}"),
            "AUD" : Asset(symbol: "AUD", name: "Australia Dollar", unicodeSign: "\u{0024}"),
            "AZN" : Asset(symbol: "AZN", name: "Azerbaijan Manat", unicodeSign: "\u{20bc}"),
            
            "BSD" : Asset(symbol: "BSD", name: "Bahamas Dollar", unicodeSign: "\u{0024}"),
            "BBD" : Asset(symbol: "BBD", name: "Barbados Dollar", unicodeSign: "\u{0024}"),
            "BYN" : Asset(symbol: "BYN", name: "Belarus Ruble", unicodeSign: "\u{0042}\u{0072}"),
            "BZD" : Asset(symbol: "BZD", name: "Belize Dollar", unicodeSign: "\u{0042}\u{005a}\u{0024}"),
            "BMD" : Asset(symbol: "BMD", name: "Bermuda Dollar", unicodeSign: "\u{0024}"),
            "BOB" : Asset(symbol: "BOB", name: "Bolivia Bolíviano", unicodeSign: "\u{0024}\u{0062}"),
            "BAM" : Asset(symbol: "BAM", name: "Bosnia and Herzegovina Convertible Mark", unicodeSign: "\u{004b}\u{004d}"),
            "BWP" : Asset(symbol: "BWP", name: "Botswana Pula", unicodeSign: "\u{0050}"),
            "BGN" : Asset(symbol: "BGN", name: "Bulgaria Lev", unicodeSign: "\u{043b}\u{0432}"),
            "BRL" : Asset(symbol: "BRL", name: "Brazil Real", unicodeSign: "\u{0052}\u{0024}"),
            "BND" : Asset(symbol: "BND", name: "Brunei Darussalam Dollar", unicodeSign: "\u{0024}"),
            
            "KHR" : Asset(symbol: "KHR", name: "Cambodia Riel", unicodeSign: "\u{17db}"),
            "CAD" : Asset(symbol: "CAD", name: "Canada Dollar", unicodeSign: "\u{0024}"),
            "KYD" : Asset(symbol: "KYD", name: "Cayman Islands Dollar", unicodeSign: "\u{0024}"),
            "CLP" : Asset(symbol: "CLP", name: "Chile Peso", unicodeSign: "\u{0024}"),
            "CNY" : Asset(symbol: "CNY", name: "China Yuan Renminbi", unicodeSign: "\u{00a5}"),
            
            "EUR" : Asset(symbol: "EUR", name: "Euro", unicodeSign: "\u{20AC}"),
            
            "UAH" : Asset(symbol: "UAH", name: "Ukraine Hryvnia", unicodeSign: "\u{20b4}"),
            "USD" : Asset(symbol: "USD", name: "US Dollar", unicodeSign: "\u{0024}"),
            "BTC" : Asset(symbol: "BTC", name: "Bitcoin", isCrypto: true, unicodeSign: "\u{20BF}"),
            "ETH" : Asset(symbol: "ETH", name: "Ethereum", isCrypto: true, unicodeSign: "\u{039E}")
        ]
    }
}
