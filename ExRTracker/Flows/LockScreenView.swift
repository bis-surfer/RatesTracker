//
//  LockScreenView.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 03.04.2025.
//

import SwiftUI

struct LockScreenView: View {
    var body: some View {
        ZStack(alignment: .center) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .foregroundStyle(foregroundColor)
        .background(transparentBackgroundColor)
    }
}

private extension LockScreenView {
    var transparentBackgroundColor: Color {
        self.backgroundColor.opacity(Styles.Opacities.lockScreenViewBackgroundOpacity)
    }
}

#Preview {
    LockScreenView()
}
