import UIKit
import CoreGraphics

// MARK: - Spacing

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

// MARK: - Layout Constants

/// Struct that defines standard layout values like corner radius, component sizes, etc.
struct Layout {
    /// Standard corner radius for card-like views (8.0).
    static let cornerRadius: CGFloat = 8.0
    
    /// Standard border width for containers (1.0).
    static let borderWidth: CGFloat = 1.0
    
    /// Standard height for table view headers or footers (44.0).
    static let standardViewHeight: CGFloat = 44.0
    
    enum Icon {
        /// Standard size for small icons like stars and forks (16.0).
        static let small: CGFloat = 16.0
    }
    
    enum Avatar {
        /// Size for avatars in the Pull Request list (30.0).
        static let small: CGFloat = 30.0
        
        /// Size for avatars in the Repository list (50.0).
        static let medium: CGFloat = 50.0
        
        /// Corner radius for small avatars to make them circular (15.0).
        static let smallCornerRadius: CGFloat = 15.0
        
        /// Corner radius for medium avatars to make them circular (25.0).
        static let mediumCornerRadius: CGFloat = 25.0
    }
    
    enum RepositoryCell {
        /// Width of the right column containing the author's avatar and name (60.0).
        static let authorColumnWidth: CGFloat = 60.0
        
        /// Estimated row height for self-sizing cells in the repository list (160.0).
        static let estimatedRowHeight: CGFloat = 160.0
    }
    
    enum PullRequestCell {
        /// Estimated row height for self-sizing cells in the pull request list (120.0).
        static let estimatedRowHeight: CGFloat = 120.0
    }
}

// MARK: - Typography

/// Struct that defines the standard font styles for the application.
struct Typography {
    /// Font for main titles, like repository names (System Bold, 20).
    static let title: UIFont = .systemFont(ofSize: 20, weight: .bold)
    
    /// Font for secondary titles, like pull request titles (System Bold, 18).
    static let subtitle: UIFont = .systemFont(ofSize: 18, weight: .bold)
    
    /// Font for body text, like descriptions (System Regular, 15).
    static let body: UIFont = .systemFont(ofSize: 15)
    
    /// Font for secondary information, like stats (System Regular, 14).
    static let subheadline: UIFont = .systemFont(ofSize: 14)
    
    /// Font for small captions, like author names or dates (System Regular, 12).
    static let caption: UIFont = .systemFont(ofSize: 12)
    
    /// Font for small, slightly heavier captions (System Medium, 12).
    static let captionMedium: UIFont = .systemFont(ofSize: 12, weight: .medium)
}

// MARK: - App Configuration

/// Struct that defines application behavior configuration constants.
struct AppConfiguration {
    enum Pagination {
        /// The debounce interval for the scroll check, in milliseconds (500).
        static let scrollThrottleInterval: Int = 500
        
        /// The distance (in points) from the bottom of the list to trigger loading the next page (200.0).
        static let threshold: CGFloat = 200.0
    }
}

// MARK: - Identifiers

/// Struct that defines reusable identifiers for UI components like table view cells.
struct Identifiers {
    enum Cell {
        /// Reusable identifier for the RepositoryCell ("RepositoryCell").
        static let repository = "RepositoryCell"
        /// Reusable identifier for the PullRequestCell ("PullRequestCell").
        static let pullRequest = "PullRequestCell"
    }
}

// MARK: - SF Symbols

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
