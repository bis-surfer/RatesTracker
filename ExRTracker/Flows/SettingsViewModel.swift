//
//  SettingsViewModel.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 08.04.2025.
//

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var selectedPalette: Palette = Settings.shared.palette
    @Published var selectedRatesUpdatingInterval: Double = Settings.shared.ratesUpdatingInterval
    
    var ratesUpdatingIntervalRange: ClosedRange<Double> {
        Settings.shared.ratesUpdatingIntervalRange
    }
    
    func selectPalette(_ palette: Palette) {
        selectedPalette = palette
    }
    
    func updateSharedSettings() {
        Settings.shared.palette = selectedPalette
        Settings.shared.ratesUpdatingInterval = TimeInterval(Int(selectedRatesUpdatingInterval))
        
        storeSettings()
    }
    
    private func storeSettings() {
        AppStorageManager.shared.setSettings(Settings.shared)
    }
}
