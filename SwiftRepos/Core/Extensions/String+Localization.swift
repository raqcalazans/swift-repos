import Foundation

extension String {
    
    /// Returns the localized version of the string key.
    /// - Returns: The localized string.
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    struct LocalizedKeys {
        
        // MARK: Screen Titles
        static let repositoryListTitle = "repository_list_title".localized()
        static let pullRequestDetailsTitle = "pull_request_details_title".localized()
        
        // MARK: State Messages
        static let emptyPullRequestList = "empty_pull_request_list".localized()
        
        // MARK: String Formats (with arguments)
        static func pullRequestListTitle(for repoName: String) -> String {
            return String(format: NSLocalizedString("pull_request_list_title_format", comment: ""), repoName)
        }
        
        static func statsHeader(open: Int, closed: Int) -> String {
            return String(format: NSLocalizedString("stats_header_format", comment: ""), open, closed)
        }
        
        // MARK: Error Messages
        static let errorInvalidURL = "error_invalid_url".localized()
        static let errorDecoding = "error_decoding".localized()
        static func errorRequestFailed(description: String) -> String {
            return String(format: NSLocalizedString("error_request_failed_format", comment: ""), description)
        }
        static func errorUnexpectedStatus(code: Int) -> String {
            return String(format: NSLocalizedString("error_unexpected_status_format", comment: ""), code)
        }
    }
}
