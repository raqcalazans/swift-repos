import Foundation
@testable import SwiftRepos

final class MockAPIService: APIServiceProtocol {
    
    // MARK: - Properties

    var shouldReturnError = false
    
    var mockRepositories: [Repository] = [
        Repository(
            id: 1,
            name: "Repo Test 1",
            owner: nil,
            description: "Desc 1",
            stargazersCount: 100,
            forksCount: 10
        ),
        Repository(
            id: 2,
            name: "Repo Test 2",
            owner: nil,
            description: "Desc 2",
            stargazersCount: 200,
            forksCount: 20
        )
    ]
    
    var mockPullRequests: [PullRequest] = [
        PullRequest(
            id: 1,
            title: "PR Test 1",
            user: nil,
            body: "Body 1",
            htmlUrl: nil,
            state: "open",
            createdAt: nil
        ),
        PullRequest(
            id: 2,
            title: "PR Test 2",
            user: nil,
            body: "Body 2",
            htmlUrl: nil,
            state: "closed",
            createdAt: nil
        )
    ]
    
    enum MockError: Error {
        case networkError
    }
    
    // MARK: - APIServiceProtocol Conformance
    
    func fetchRepositories(page: Int) async throws -> [Repository] {
        if shouldReturnError {
            throw MockError.networkError
        } else {
            return page == 1 ? mockRepositories : []
        }
    }
    
    func fetchPullRequests(owner: String, repoName: String) async throws -> [PullRequest] {
        if shouldReturnError {
            throw MockError.networkError
        } else {
            return mockPullRequests
        }
    }
}
