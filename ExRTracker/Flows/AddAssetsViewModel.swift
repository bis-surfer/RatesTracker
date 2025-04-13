//
//  AddAssetsViewModel.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 30.03.2025.
//

import Combine

final class AddAssetsViewModel: ColorableViewModel {
    @Published var allAssets: [Asset] = AssetsManager.shared.allAssets
    @Published var searchText: String = ""
    
    @Published var selectedAssets: [Asset] = AssetsManager.shared.selectedAssets
    
    var filteredAssets: [Asset] {
        if searchText.isEmpty {
            return allAssets
        } else {
            return allAssets.filter { $0.symbol.contains(searchText.uppercased()) }
        }
    }
    
    func isSelectedAsset(_ asset: Asset) -> Bool {
        asset.belongsTo(selectedAssets)
    }
    
    func toggleSelectionForAsset(_ asset: Asset) {
        if isSelectedAsset(asset) {
            selectedAssets.removeAll(where: { $0.symbol == asset.symbol })
        } else {
            selectedAssets.append(asset)
        }
        AssetsManager.shared.modifiedSelectedAssets = selectedAssets
    }
    
    var filteredAssetsViewModels: [AssetViewModel] {
        filteredAssets.map { asset in
            AssetViewModel(
                withAsset: asset,
                inSelectableMode: true
            )
        }
    }
    
    func resetAssetsSelection() {
        AssetsManager.shared.modifiedSelectedAssets = AssetsManager.shared.selectedAssets
    }
    
    func cancelAssetsSelection() {
        resetAssetsSelection()
    }
    
    func confirmAssetsSelection() {
        AssetsManager.shared.selectedAssets = AssetsManager.shared.modifiedSelectedAssets
        AssetsManager.shared.storeSelectedAssets()
    }
}
