//
//  AssetView.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 29.03.2025.
//

import SwiftUI

struct AssetView: View {
    @StateObject var viewModel: AssetViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: Styles.Layout.Spacing.double) {
            if let imageUrl = viewModel.asset.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .padding(.all, Styles.Layout.Padding.half)
                        .frame(width: Styles.Layout.AssetImageCircle.diameter, height: Styles.Layout.AssetImageCircle.diameter)
                        .background(
                            Circle()
                                .fill(foregroundColor)
                                .frame(width: Styles.Layout.AssetImageCircle.diameter, height: Styles.Layout.AssetImageCircle.diameter)
                        )
                    
                } placeholder: {
                    if let unicodeSign = viewModel.asset.unicodeSign {
                        unicodeSignView(with: unicodeSign)
                    }
                }
            } else {
                if let unicodeSign = viewModel.asset.unicodeSign {
                    unicodeSignView(with: unicodeSign)
                }
            }
            
            VStack(alignment: .leading, spacing: Styles.Layout.Spacing.standard) {
                Text(viewModel.asset.symbol)
                    .font(.headline)
                Text(viewModel.asset.name)
                    .font(.body)
            }
            
            Spacer()
            
            if viewModel.isInSelectableMode {
                Image(systemName: viewModel.isSelected ? "checkmark.circle" : "circle")
                    .font(.title3)
                    .foregroundStyle(foregroundColor)
                    .padding(.all, Styles.Layout.Padding.standard)
            } else if let exchangeRateRepresentation = viewModel.exchangeRateRepresentation {
                Text(exchangeRateRepresentation)
                    .font(viewModel.representsBaseCurrency ? .title2 : .title3)
            }
        }
        .foregroundStyle(foregroundColor)
        .padding(.all, Styles.Layout.Padding.half)
        .animation(Animation.easeInOut(duration: Styles.Durations.defaultAnimationDuration), value: viewModel.asset.exchangeRate)
    }
}

extension AssetView {
    func unicodeSignView(with unicodeSign: String) -> some View {
        Text(unicodeSign)
            .font(.title)
            .lineLimit(1)
            .truncationMode(.tail)
            .multilineTextAlignment(.leading)
            .foregroundStyle(backgroundColor)
            .padding(.horizontal, unicodeSign.count < 3 ? Styles.Layout.Padding.half : Styles.Layout.Padding.double)
            .background(
                ZStack {
                    if unicodeSign.count < 3 {
                        Circle()
                            .fill(foregroundColor)
                            .frame(width: Styles.Layout.AssetImageCircle.diameter, height: Styles.Layout.AssetImageCircle.diameter)
                    } else {
                        Capsule()
                            .fill(foregroundColor)
                            .frame(height: Styles.Layout.AssetImageCircle.diameter)
                    }
                }
            )
            .frame(minWidth: Styles.Layout.AssetImageCircle.diameter)
    }
}

extension AssetView {
    var foregroundColor: Color {
        viewModel.palette.foregroundColor
    }
    
    var backgroundColor: Color {
        viewModel.palette.backgroundColor
    }
}

#Preview {
    let asset = Asset(symbol: "USD", name: "US Dollar", unicodeSign: "\u{0024}")
    AssetView(viewModel: AssetViewModel(withAsset: asset))
}
