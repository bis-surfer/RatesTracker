//
//  ExchangeRates.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 31.03.2025.
//

import Foundation

struct ExchangeRates: Codable {
    var disclaimer: String
    var license: String
    var timestamp: Int
    var base: String
    var rates: [String : Double]
}
