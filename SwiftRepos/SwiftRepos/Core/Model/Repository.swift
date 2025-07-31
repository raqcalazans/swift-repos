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
    
    // Mapeia as chaves do JSON (snake_case) para as nossas propriedades (camelCase).
    enum CodingKeys: String, CodingKey {
        case id, name, owner, description
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
    }
}
