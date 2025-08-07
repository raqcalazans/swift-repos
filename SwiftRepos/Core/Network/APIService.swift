import Foundation

final class APIService: APIServiceProtocol {

    private let decoder: JSONDecoder

    init() {
        self.decoder = JSONDecoder()
    }

    func fetchRepositories(page: Int) async throws -> [Repository] {
        
        guard let url = APIEndpoint.searchRepositories(page: page).url else {
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

        guard let url = APIEndpoint.pullRequests(owner: owner, repoName: repoName).url else {
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
