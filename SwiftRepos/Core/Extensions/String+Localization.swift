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
    }
}
