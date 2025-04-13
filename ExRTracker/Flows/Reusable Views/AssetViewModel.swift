//
//  AssetViewModel.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 29.03.2025.
//

import Foundation
import Combine

final class AssetViewModel: ColorableViewModel {
    @Published var asset: Asset
    @Published var isInSelectableMode: Bool = false
    @Published var isSelected: Bool = false
    
    init(withAsset anAsset: Asset, inSelectableMode: Bool = false, selected: Bool = false) {
        self.asset = anAsset
        self.isInSelectableMode = inSelectableMode
        self.isSelected = anAsset.belongsTo(AssetsManager.shared.modifiedSelectedAssets)
        
        super.init()
    }
    
    override func addSubscribers() {
        AssetsManager.shared.$modifiedSelectedAssets.sink(receiveValue: { [weak self] modifiedSelectedAssets in
            DispatchQueue.main.async {
                self?.updateIsSelected(with: modifiedSelectedAssets)
            }
        })
        .store(in: &cancellableBag)
        
        super.addSubscribers()
    }
    
    private func updateIsSelected(with selectedAssets: [Asset]) {
        isSelected = asset.belongsTo(selectedAssets)
    }
    
    var representsBaseCurrency: Bool {
        asset.representsBaseCurrency
    }
    
    var exchangeRateRepresentation: String? {
        if representsBaseCurrency {
            return "1"
        }
        
        guard let exchangeRate = asset.exchangeRate else {
            return nil
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = "\u{2008}"   // The space with a width of a period
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 4
        
        var exchangeRateString = numberFormatter.string(for: exchangeRate) ?? String(format: "%.4f", exchangeRate)
        for _ in 0...1 {
            if exchangeRateString.count > 8 {
                exchangeRateString.removeLast()
            }
        }
        return exchangeRateString
    }
}

extension AssetViewModel: Hashable {
    static func == (lhs: AssetViewModel, rhs: AssetViewModel) -> Bool {
        lhs.asset == rhs.asset
    }
    
    func hash(into hasher: inout Hasher) {
        asset.hash(into: &hasher)
    }
}
