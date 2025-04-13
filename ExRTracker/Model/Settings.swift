//
//  Settings.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 03.04.2025.
//

import Foundation

final class Settings: ObservableObject, Codable  {
    static let shared = AppStorageManager.shared.settings ?? Settings()
    
    var baseCurrency: String = "USD"
    var coins: [String] {
        AssetsManager.shared.selectedAssets.filter { asset in
            asset.isCrypto
        }.map { asset in
            asset.name.lowercased()
        }
    }
    
    var ratesUpdatingInterval: TimeInterval = 5.0
    let ratesUpdatingIntervalRange: ClosedRange<TimeInterval> = 2.0 ... 120.0
    
    var coinGeckoToOpenExchangeRatesUpdatesRatio: Int = 5   // 0 ... infinity
    
    var dateOfLastUpdateRepresentationUpdatingInterval: TimeInterval = 1.0
    
    @Published var palette: Palette = .standard
    
    private init() {
    }
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "baseCurrency"
        case ratesUpdatingInterval = "ratesUpdatingInterval"
        case palette = "palette"
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        baseCurrency = try values.decode(String.self, forKey: .baseCurrency)
        ratesUpdatingInterval = try values.decode(TimeInterval.self, forKey: .ratesUpdatingInterval)
        let paletteId = try values.decode(Int.self, forKey: .palette)
        palette = Palette.palette(with: paletteId)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(baseCurrency, forKey: .baseCurrency)
        try container.encode(ratesUpdatingInterval, forKey: .ratesUpdatingInterval)
        try container.encode(palette.id, forKey: .palette)
    }
}
