import Foundation

extension String {
    
    /// Converts an ISO8601 date string (used by the GitHub API)
    /// to a localized display format.
    /// - Returns: The formatted date as a String, or an empty string if the conversion fails.
    func toFormattedDate() -> String {
        let formatter = ISO8601DateFormatter()
        
        // First, try with the format that includes fractional seconds
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: self) {
            return date.toDisplayFormat()
        }
        
        // If it fails, try with the standard format without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: self) {
            return date.toDisplayFormat()
        }
        
        return "" // Returns empty if it cannot convert
    }
}

extension Date {
    /// Formats the date to a short display format, respecting the device's locale.
    /// Ex: "06/08/25" (Brazil), "8/6/25" (USA).
    func toDisplayFormat() -> String {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .none
        
        return displayFormatter.string(from: self)
    }
}
