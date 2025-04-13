//
//  Palette.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 03.04.2025.
//

import SwiftUI

enum Palette: CaseIterable, Hashable {
    case standard
    case secondary
    case tertiary
    case quaternary
    case quinary
}

extension Palette {
    var foregroundColor: Color {
        switch self {
        case .standard:
            return Styles.Colors.StandardPalette.foregroundColor
        case .secondary:
            return Styles.Colors.SecondaryPalette.foregroundColor
        case .tertiary:
            return Styles.Colors.TertiaryPalette.foregroundColor
        case .quaternary:
            return Styles.Colors.QuaternaryPalette.foregroundColor
        case .quinary:
            return Styles.Colors.QuinaryPalette.foregroundColor
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .standard:
            return Styles.Colors.StandardPalette.backgroundColor
        case .secondary:
            return Styles.Colors.SecondaryPalette.backgroundColor
        case .tertiary:
            return Styles.Colors.TertiaryPalette.backgroundColor
        case .quaternary:
            return Styles.Colors.QuaternaryPalette.backgroundColor
        case .quinary:
            return Styles.Colors.QuinaryPalette.backgroundColor
        }
    }
}

extension Palette {
    var id: Int {
        switch self {
        case .standard:
            return 1
        case .secondary:
            return 2
        case .tertiary:
            return 3
        case .quaternary:
            return 4
        case .quinary:
            return 5
        }
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    static func palette(with id: Int) -> Palette {
        switch(id) {
        case 1:
            return Palette.standard
        case 2:
            return Palette.secondary
        case 3:
            return Palette.tertiary
        case 4:
            return Palette.quaternary
        case 5:
            return Palette.quinary
            
        default:
            return Palette.standard
        }
    }
}
