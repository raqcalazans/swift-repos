protocol APIServiceProtocol {
    
    func fetchRepositories(page: Int) async throws -> [Repository]
    func fetchPullRequests(owner: String, repoName: String) async throws -> [PullRequest]
}
