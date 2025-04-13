//
//  Untitled.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 29.03.2025.
//

import Foundation

struct Asset: Codable, Hashable {
    var symbol: String
    var name: String
    var isCrypto: Bool = false   // false means Fiat money
    var unicodeSign: String?
    var imageUrl: String?
    var exchangeRate: Double?
    
    func assetUpdated(withRate rate: Double?, imageUrl newImageUrl: String? = nil, isInverseRate: Bool = true) -> Asset {
        guard let originalRate = rate, let newRate = isInverseRate ? (1.0 / originalRate) : rate else {
            return self
        }
        
        return Asset(
            symbol: symbol,
            name: name,
            isCrypto: isCrypto,
            unicodeSign: unicodeSign,
            imageUrl: newImageUrl ?? imageUrl,
            exchangeRate: newRate
        )
    }
    
    var representsBaseCurrency: Bool {
        symbol == Settings.shared.baseCurrency
    }
    
    func belongsTo(_ assets: [Asset]) -> Bool {
        assets.map { asset in
            asset.symbol
        }.contains(symbol)
    }
}
