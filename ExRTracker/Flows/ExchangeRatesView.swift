//
//  ExchangeRatesView.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 29.03.2025.
//

import SwiftUI

struct ExchangeRatesView: View {
    @StateObject private var viewModel: ExchangeRatesViewModel = ExchangeRatesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Styles.Layout.Spacing.standard) {
                Text(viewModel.dateOfLastUpdateRepresentation)
                
                List {
                    ForEach(viewModel.selectedAssets, id: \.self) { asset in
                        AssetView(viewModel: AssetViewModel(withAsset: asset))
                    }
                    .onDelete(perform: deleteAssets)
                }
            }
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(foregroundColor)
                            .padding(.all, Styles.Layout.Padding.standard)
                            .background(
                                Circle()
                                    .fill(backgroundColor)
                            )
                    }
                }
//                ToolbarItem(placement: .topBarLeading) {
//                    Button(action: {
//                        viewModel.updateExchangeRates()
//                    }) {
//                        Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
//                            .foregroundStyle(foregroundColor)
//                            .padding(.all, Styles.Layout.Padding.standard)
//                            .background(
//                                Circle()
//                                    .fill(backgroundColor)
//                            )
//                    }
//                }
                ToolbarItem(placement: .principal) {
                    Text("Exchange Rates")
                        .font(.title2)
                        .foregroundStyle(foregroundColor)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddAssetsView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(foregroundColor)
                            .padding(.all, Styles.Layout.Padding.standard)
                            .background(
                                Circle()
                                    .fill(backgroundColor)
                            )
                    }
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    EditButton()
//                        .foregroundStyle(foregroundColor)
//                }
            }
        }
        .onAppear {
            viewModel.assignStoredExchangeRates()
            viewModel.getExchangeRates()
//            viewModel.getCoinGeckoCoinInfos()
            viewModel.setupExchangeRatesUpdatingTimer()
            viewModel.setupDateOfLastUpdateRepresentationUpdatingTimer()
        }
        .overlay {
            if viewModel.networkingStatus != .idle {
                LockScreenView()
            }
        }
        .animation(Animation.easeInOut(duration: Styles.Durations.defaultAnimationDuration), value: viewModel.networkingStatus)
    }
}

extension ExchangeRatesView {
    private func deleteAssets(at indexSet: IndexSet) {
        withAnimation {
            viewModel.deleteAssets(at: indexSet)
        }
    }
}

extension ExchangeRatesView {
    var foregroundColor: Color {
        viewModel.palette.foregroundColor
    }
    
    var backgroundColor: Color {
        viewModel.palette.backgroundColor
    }
}

#Preview {
    ExchangeRatesView()
}
