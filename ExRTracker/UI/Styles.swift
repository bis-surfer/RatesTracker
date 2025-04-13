//
//  Styles.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 29.03.2025.
//

import SwiftUI

enum Styles {
}

extension Styles {
    enum Layout {
        enum Padding {
            static let half: CGFloat = 4.0
            static let standard: CGFloat = 8.0
            static let standardAndHalf: CGFloat = 12.0
            static let double: CGFloat = 16.0
        }
        
        enum Spacing {
            static let standard: CGFloat = 8.0
            static let double: CGFloat = 16.0
        }
        
        enum CornerRadius {
            static let standard: CGFloat = 8.0
        }
        
        enum AssetImageCircle {
            static let diameter: CGFloat = 52.0
        }
    }
}

extension Styles {
    enum Colors {
        static let transparentColor: Color = .white.opacity(0.0)
        static let semitransparentLightGrayColor: Color = Color(.lightGray).opacity(0.5)
        static let semitransparentGrayColor: Color = .gray.opacity(0.5)
        
        enum StandardPalette {
            static let foregroundColor: Color = .indigo
            static let backgroundColor: Color = Color(red: 0.5 * (1.0 + UIColor(Color.yellow).cgColor.components![0]), green: 0.5 * (1.0 + UIColor(Color.yellow).cgColor.components![1]), blue: 0.75)
        }
        
        enum SecondaryPalette {
            static let foregroundColor: Color = Color(.darkGray)
            static let backgroundColor: Color = .white
        }
        
        enum TertiaryPalette {
            static let foregroundColor: Color = .black
            static let backgroundColor: Color = .cyan
        }
        
        enum QuaternaryPalette {
            static let foregroundColor: Color = .purple
            static let backgroundColor: Color = Color(red: 0.5 * (1.0 + UIColor(Color.mint).cgColor.components![0]), green: 0.5 * (1.0 + UIColor(Color.mint).cgColor.components![1]), blue: 0.5 * (1.0 + UIColor(Color.mint).cgColor.components![2]))
        }
        
        enum QuinaryPalette {
            static let foregroundColor: Color = Color(.magenta)
            static let backgroundColor: Color = .yellow
        }
    }
}

extension Styles {
    enum Opacities {
        static let lockScreenViewBackgroundOpacity: CGFloat = 0.75
    }
}

extension Styles {
    enum Durations {
        static let defaultAnimationDuration: TimeInterval = 0.25
    }
}
