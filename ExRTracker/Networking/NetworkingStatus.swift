//
//  NetworkingStatus.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 03.04.2025.
//

enum NetworkingStatus: Equatable {
    case idle
    case gettingExchangeRates
    case gettingCoinGeckoCoinInfos
}
