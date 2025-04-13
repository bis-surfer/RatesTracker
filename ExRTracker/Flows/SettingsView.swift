//
//  SettingsView.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 08.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: Styles.Layout.Spacing.standard) {
            Text("Settings")
                .font(.title)
                .padding(.all, Styles.Layout.Padding.double)
            
            VStack(alignment: .leading, spacing: Styles.Layout.Spacing.standard) {
                Text("Select your color palette:")
                    .font(.title2)
                    .padding(.horizontal, Styles.Layout.Padding.double)
//                List {
                VStack(spacing: .zero) {
                    ForEach(Palette.allCases, id: \.self) { palette in
                        Button(action: {
                            viewModel.selectPalette(palette)
                        }) {
                            PaletteView(palette: palette)
                                .background(palette == viewModel.selectedPalette ? Styles.Colors.semitransparentGrayColor : Styles.Colors.transparentColor)
                        }
                    }
                }
                .background(Styles.Colors.semitransparentLightGrayColor)
            }
            
            VStack(alignment: .leading, spacing: Styles.Layout.Spacing.standard) {
                Text("Select preferable rates updating interval:")
                    .font(.title2)
                    .padding(.all, Styles.Layout.Padding.double)
                
                VStack(spacing: .zero) {
                    Slider(value: $viewModel.selectedRatesUpdatingInterval, in: viewModel.ratesUpdatingIntervalRange)
                        .accentColor(foregroundColor)
                    
                    Text(String(format: "%d seconds", Int(viewModel.selectedRatesUpdatingInterval)))
                        .font(.title3)
                }
                .padding(.horizontal, Styles.Layout.Padding.double)
                .padding(.vertical, Styles.Layout.Padding.standard)
                .background(Styles.Colors.semitransparentLightGrayColor)
            }
            
            Spacer()
        }
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .foregroundStyle(foregroundColor)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    viewModel.updateSharedSettings()
                    dismiss()
                }) {
                    Text("Confirm")
                        .foregroundStyle(foregroundColor)
                }
            }
        }
    }
}

extension SettingsView {
    var foregroundColor: Color {
        viewModel.selectedPalette.foregroundColor
    }
    
    var backgroundColor: Color {
        viewModel.selectedPalette.backgroundColor
    }
}

struct PaletteView: View {
    @State var palette: Palette
    
    var body: some View {
        HStack {
            Text("Text - sample of foreground color - on background color")
                .multilineTextAlignment(.center)
                .foregroundStyle(palette.foregroundColor)
                .padding(.horizontal, Styles.Layout.Padding.standardAndHalf)
                .padding(.vertical, Styles.Layout.Padding.half)
                .background(
                    Capsule()
                        .fill(palette.backgroundColor)
                )
            
            Spacer()
        }
        .padding(.horizontal, Styles.Layout.Padding.double)
        .padding(.vertical, Styles.Layout.Padding.standard)
    }
}

#Preview {
    SettingsView()
}
