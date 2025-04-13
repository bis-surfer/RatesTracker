//
//  ExchangeRatesViewModel.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 29.03.2025.
//

import Combine
import SwiftUI

final class ExchangeRatesViewModel: ColorableViewModel {
    @Published var networkingStatus: NetworkingStatus = .idle
    @Published var selectedAssets: [Asset] = AssetsManager.shared.selectedAssets {
        didSet {
            AssetsManager.shared.selectedAssets = selectedAssets
        }
    }
    @Published var dateOfLastUpdateRepresentation: String = ""
    
    private var ratesUpdatingTimer: Timer?
    private var ratesUpdateIndex: Int = 0
    
    private var dateOfLastUpdate: Date?
    private var dateOfLastUpdateRepresentationUpdatingTimer: Timer?
    
    override func addSubscribers() {
        AssetsManager.shared.$selectedAssets.sink(receiveValue: { [weak self] selectedAssets in
            DispatchQueue.main.async {
                self?.resetSelectedAssets(selectedAssets)
            }
        })
        .store(in: &cancellableBag)
        
        super.addSubscribers()
    }
    
    func deleteAssets(at indexSet: IndexSet) {
        let assetsToDelete: [Asset] = indexSet.compactMap { assetIndex in
            selectedAssets[assetIndex]
        }
        
        selectedAssets = selectedAssets.filter { asset in
            assetsToDelete.firstIndex(of: asset) == nil
        }
    }
    
    func getExchangeRates() {
        networkingStatus = .gettingExchangeRates
        Task {
             do {
                 let fetchedExchangeRates = try await NetworkingManager.shared.getExchangeRates()
                 await updateExchangeRates(fetchedExchangeRates)
             } catch NetworkingError.invalidUrl {
                 await handleNetworkingError(.invalidUrl)
             } catch NetworkingError.invalidResponse {
                 await handleNetworkingError(.invalidResponse)
             } catch NetworkingError.invalidData {
                 await handleNetworkingError(.invalidData)
             } catch {
                 await handleNetworkingError(.unexpected(error))
             }
        }
    }
    
    func getCoinGeckoCoinInfos() {
        networkingStatus = .gettingCoinGeckoCoinInfos
        Task {
             do {
                 let fetchedCoinGeckoCoinInfos = try await NetworkingManager.shared.getCoinGeckoCoinInfos()
                 await updateCoinGeckoCoinInfos(fetchedCoinGeckoCoinInfos)
             } catch NetworkingError.invalidUrl {
                 await handleNetworkingError(.invalidUrl)
             } catch NetworkingError.invalidResponse {
                 await handleNetworkingError(.invalidResponse)
             } catch NetworkingError.invalidData {
                 await handleNetworkingError(.invalidData)
             } catch {
                 await handleNetworkingError(.unexpected(error))
             }
        }
    }
    
    func updateExchangeRates() {
        getExchangeRates()
    }
    
    func updateCoinGeckoCoinInfos() {
        getCoinGeckoCoinInfos()
    }
    
    func assignStoredExchangeRates() {
        guard let exchangeRates = AppStorageManager.shared.exchangeRates else {
            return
        }
        updateSelectedAssets(withRates: exchangeRates.rates)
    }
    
    @MainActor
    func updateExchangeRates(_ exchangeRates: ExchangeRates) {
        networkingStatus = .idle
        updateDateOfLastUpdate(withTimestamp: exchangeRates.timestamp)
        updateSelectedAssets(withRates: exchangeRates.rates)
        AppStorageManager.shared.setExchangeRates(exchangeRates)
        AssetsManager.shared.storeSelectedAssets()
    }
    
    @MainActor
    func updateCoinGeckoCoinInfos(_ coinGeckoCoinInfos: [CoinGeckoCoinInfo]) {
        networkingStatus = .idle
        updateDateOfLastUpdate(withStringRepresentation: coinGeckoCoinInfos.first?.last_updated)
        var rates: [String : Double] = [:]
        var imageUrls: [String : String] = [:]
        for coinInfo in coinGeckoCoinInfos {
            rates[coinInfo.symbol.uppercased()] = coinInfo.current_price
            imageUrls[coinInfo.symbol.uppercased()] = coinInfo.image
        }
        updateSelectedAssets(withRates: rates, imageUrls: imageUrls, isInverseRates: false)
        AssetsManager.shared.storeSelectedAssets()
    }
    
    func updateDateOfLastUpdate(withTimestamp timestamp: Int) {
        dateOfLastUpdate = Date(timeIntervalSince1970: TimeInterval(timestamp))
//        dateOfLastUpdate = Date()
    }
    
    func updateDateOfLastUpdate(withStringRepresentation dateOfLastUpdateStringRepresentation: String?) {
        guard let dateOfLastUpdateStringRepresentation else {
            return
        }
        dateOfLastUpdate = dateOfLastUpdateStringRepresentation.date
    }
    
    func updateSelectedAssets(withRates rates: [String : Double], imageUrls: [String : String] = [:], isInverseRates: Bool = true) {
        selectedAssets = selectedAssets.map { asset in
            asset.assetUpdated(withRate: rates[asset.symbol], imageUrl: imageUrls[asset.symbol], isInverseRate: isInverseRates)
        }
    }
    
    @MainActor
    func resetSelectedAssets(_ selectedAssets: [Asset]) {
        self.selectedAssets = selectedAssets
    }
    
    @MainActor
    func handleNetworkingError(_ networkingError: NetworkingError) {
        networkingStatus = .idle
        print(networkingError.message)
    }
    
    func setupExchangeRatesUpdatingTimer() {
        ratesUpdatingTimer = Timer.scheduledTimer(withTimeInterval: Settings.shared.ratesUpdatingInterval, repeats: true) { [weak self] timer in
            guard let self else {
                return
            }
            if self.ratesUpdateIndex % (1 + Settings.shared.coinGeckoToOpenExchangeRatesUpdatesRatio) == 0 {
                self.updateExchangeRates()
            } else {
                self.updateCoinGeckoCoinInfos()
            }
            self.ratesUpdateIndex += 1
        }
    }
}

extension ExchangeRatesViewModel {
    func setupDateOfLastUpdateRepresentationUpdatingTimer() {
        dateOfLastUpdateRepresentationUpdatingTimer = Timer.scheduledTimer(withTimeInterval: Settings.shared.dateOfLastUpdateRepresentationUpdatingInterval, repeats: true) { [weak self] timer in
            self?.updateRepresentationOfDateOfLastUpdate()
        }
    }
    
    func updateRepresentationOfDateOfLastUpdate() {
        guard let dateOfLastUpdate else {
            return
        }
        
        let timeIntervalSinceLastUpdate = 0.0 - dateOfLastUpdate.timeIntervalSince(.now)
        let timeIntervalInSeconds = Int(timeIntervalSinceLastUpdate)
        let timeIntervalInMinutes = timeIntervalInSeconds / 60
        let remainderInSeconds = timeIntervalInSeconds - timeIntervalInMinutes * 60
        
        dateOfLastUpdateRepresentation = "Last updated \(timeIntervalInMinutes) minutes \(remainderInSeconds) seconds ago"
    }
}
