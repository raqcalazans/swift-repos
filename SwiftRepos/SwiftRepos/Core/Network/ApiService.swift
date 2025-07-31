import Foundation

final class APIService: APIServiceProtocol {

    private let baseURL = "https://api.github.com"
    private let decoder: JSONDecoder

    init() {
        self.decoder = JSONDecoder()
    }

    func fetchRepositories(page: Int) async throws -> [Repository] {
        
        let urlString = "\(baseURL)/search/repositories?q=language:Swift&sort=stars&page=\(page)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw APIError.unexpectedStatusCode(statusCode)
        }

        do {
            let searchResponse = try decoder.decode(RepoSearchResponse.self, from: data)
            return searchResponse.items
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchPullRequests(owner: String, repoName: String) async throws -> [PullRequest] {

        let urlString = "\(baseURL)/repos/\(owner)/\(repoName)/pulls"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw APIError.unexpectedStatusCode(statusCode)
        }

        do {
            let pullRequests = try decoder.decode([PullRequest].self, from: data)
            return pullRequests
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
