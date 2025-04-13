//
//  AppStorageManager.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 03.04.2025.
//

import Foundation

final class AppStorageManager {
    static let shared = AppStorageManager()
    
    private init() {
    }
    
    
    var _settings: Settings?
    
    var settings: Settings? {
        if _settings != nil {
            return _settings
        }
        
        let settingsKey = AppStorageKeys.settings
        
        guard let settingsData = UserDefaults.standard.value(forKey: settingsKey) as? Data else {
            return nil
        }
        
        let settings = try? PropertyListDecoder().decode(Settings.self, from: settingsData)
        return settings
    }
    
    func setSettings(_ settings: Settings) {
        _settings = settings
        
        let settingsKey = AppStorageKeys.settings
        UserDefaults.standard.set(try? PropertyListEncoder().encode(settings), forKey: settingsKey)
    }
    
    func removeSettings() {
        let settingsKey = AppStorageKeys.settings
        UserDefaults.standard.removeObject(forKey: settingsKey)
    }
    
    
    var _selectedAssets: [Asset]?
    
    var selectedAssets: [Asset]? {
        if _selectedAssets != nil {
            return _selectedAssets
        }
        
        let selectedAssetsKey = AppStorageKeys.selectedAssets
        
        guard let selectedAssetsData = UserDefaults.standard.value(forKey: selectedAssetsKey) as? Data else {
            return nil
        }
        
        let selectedAssets = try? PropertyListDecoder().decode([Asset].self, from: selectedAssetsData)
        return selectedAssets
    }
    
    func setSelectedAssets(_ selectedAssets: [Asset]) {
        _selectedAssets = selectedAssets
        
        let selectedAssetsKey = AppStorageKeys.selectedAssets
        UserDefaults.standard.set(try? PropertyListEncoder().encode(selectedAssets), forKey: selectedAssetsKey)
    }
    
    func removeSelectedAssets() {
        let selectedAssetsKey = AppStorageKeys.selectedAssets
        UserDefaults.standard.removeObject(forKey: selectedAssetsKey)
    }
    
    
    var _exchangeRates: ExchangeRates?
    
    var exchangeRates: ExchangeRates? {
        if _exchangeRates != nil {
            return _exchangeRates
        }
        
        let exchangeRatesKey = AppStorageKeys.exchangeRates
        
        guard let exchangeRatesData = UserDefaults.standard.value(forKey: exchangeRatesKey) as? Data else {
            return nil
        }
        
        let exchangeRates = try? PropertyListDecoder().decode(ExchangeRates.self, from: exchangeRatesData)
        return exchangeRates
    }
    
    func setExchangeRates(_ exchangeRates: ExchangeRates) {
        _exchangeRates = exchangeRates
        
        let exchangeRatesKey = AppStorageKeys.exchangeRates
        UserDefaults.standard.set(try? PropertyListEncoder().encode(exchangeRates), forKey: exchangeRatesKey)
    }
    
    func removeExchangeRates() {
        let exchangeRatesKey = AppStorageKeys.exchangeRates
        UserDefaults.standard.removeObject(forKey: exchangeRatesKey)
    }
}


enum AppStorageKeys {
    static let settings = "settings"
    static let selectedAssets = "selectedAssets"
    static let exchangeRates = "exchangeRates"
}
