//
//  AddAssetsView.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 30.03.2025.
//

import SwiftUI

struct AddAssetsView: View {
    @StateObject private var viewModel: AddAssetsViewModel = AddAssetsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(viewModel.filteredAssetsViewModels, id: \.self) { assetViewModel in
                Button(action: {
                    viewModel.toggleSelectionForAsset(assetViewModel.asset)
                }) {
                    AssetView(viewModel: assetViewModel)
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationBarBackButtonHidden(true)
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    viewModel.cancelAssetsSelection()
                    dismiss()
                }) {
                    Text("Cancel")
                        .foregroundStyle(foregroundColor)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Add Asset")
                    .font(.title2)
                    .foregroundStyle(foregroundColor)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    viewModel.confirmAssetsSelection()
                    dismiss()
                }) {
                    Text("Confirm")
                        .foregroundStyle(foregroundColor)
                }
            }
        }
        .onAppear {
            viewModel.resetAssetsSelection()
        }
    }
}

#Preview {
    AddAssetsView()
}
