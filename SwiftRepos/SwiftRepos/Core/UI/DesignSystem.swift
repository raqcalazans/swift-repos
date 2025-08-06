import UIKit
import CoreGraphics

/// Enum that defines the standard spacing scale for the application.
enum Spacing {
    /// Spacing of 4.0 points, ideal for small and close elements.
    static let extraSmall: CGFloat = 4.0
    
    /// Spacing of 8.0 points, good for separating elements within the same group.
    static let small: CGFloat = 8.0
    
    /// Spacing of 16.0 points, the standard for margins and for separating larger components.
    static let medium: CGFloat = 16.0
    
    /// Spacing of 24.0 points, to create a clear visual separation.
    static let large: CGFloat = 24.0
    
    /// Spacing of 32.0 points, for large sections.
    static let extraLarge: CGFloat = 32.0
}

/// Enum that defines the icons (SF Symbols) used in the application to ensure consistency and type safety.
enum SFSymbols {
    case star
    case fork
    case backArrow
    case placeholderUser
    
    /// Computed property that returns the corresponding UIImage.
    var image: UIImage? {
        let imageName: String
        switch self {
        case .star:
            imageName = "star.fill"
        case .fork:
            imageName = "tuningfork"
        case .backArrow:
            imageName = "arrow.backward"
        case .placeholderUser:
            imageName = "person.circle.fill"
        }
        return UIImage(systemName: imageName)
    }
}
