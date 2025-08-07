import Foundation

struct PullRequest: Codable, Identifiable {
    let id: Int?
    let title: String?
    let user: User?
    let body: String?
    let htmlUrl: URL?
    let state: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, user, body, state
        case htmlUrl = "html_url"
        case createdAt = "created_at"
    }
}
