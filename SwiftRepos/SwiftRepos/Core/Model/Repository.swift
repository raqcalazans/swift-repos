struct RepoSearchResponse: Codable {
    let items: [Repository]
}

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let owner: Owner
    let description: String?
    let stargazersCount: Int
    let forksCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, owner, description
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
    }
}
