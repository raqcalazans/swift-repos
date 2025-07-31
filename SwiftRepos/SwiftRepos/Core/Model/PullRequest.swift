import Foundation

struct PullRequest: Codable, Identifiable {
    let id: Int
    let title: String
    let user: User
    let body: String?
    let htmlUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id, title, user, body
        case htmlUrl = "html_url"
    }
}
