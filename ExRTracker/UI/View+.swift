//
//  View+.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 03.04.2025.
//

import SwiftUI

extension View {
    var foregroundColor: Color {
        Settings.shared.palette.foregroundColor
    }
    
    var backgroundColor: Color {
        Settings.shared.palette.backgroundColor
    }
}
