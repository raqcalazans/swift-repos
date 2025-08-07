import XCTest
@testable import SwiftRepos

final class PullRequestListReducerTests: XCTestCase {

    // MARK: - Properties
    
    private var mockApiService: MockAPIService!
    private var mockRepository: Repository!

    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockApiService = MockAPIService()
        mockRepository = Repository(
            id: 1,
            name: "Test Repo",
            owner: Owner(login: "testuser", avatarUrl: ""),
            description: "A test repository",
            stargazersCount: 100,
            forksCount: 50
        )
    }

    override func tearDown() {
        mockApiService = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Tests

    // Tests if, upon receiving the .viewDidAppear action, the state is updated to loading
    // and if an effect to fetch data is returned.
    func test_viewDidAppear_shouldSetLoadingStateAndReturnFetchEffect() {
        // Given
        var state = PullRequestListState.initial(repositoryName: mockRepository.name)
        let action = PullRequestListAction.viewDidAppear
        let dependency: (apiService: APIServiceProtocol, repository: Repository) = (apiService: mockApiService, repository: mockRepository)
        
        // When
        let effect = pullRequestListReducer(state: &state, action: action, dependency: dependency)
        
        // Then
        XCTAssertTrue(state.isLoading, "isLoading should be true after viewDidAppear")
        XCTAssertNotNil(effect, "An effect to fetch pull requests should be returned")
    }
    
    // Tests if, after a successful API response, the state is updated with the Pull Requests
    // and the stats are calculated correctly.
    func test_pullRequestsResponse_withSuccess_shouldUpdateStateWithPRsAndStats() {
        // Given
        var state = PullRequestListState.initial(repositoryName: mockRepository.name)
        state.isLoading = true
        let mockPRs = mockApiService.mockPullRequests
        let action = PullRequestListAction.pullRequestsResponse(.success(mockPRs))
        let dependency: (apiService: APIServiceProtocol, repository: Repository) = (apiService: mockApiService, repository: mockRepository)
        
        // When
        let effect = pullRequestListReducer(state: &state, action: action, dependency: dependency)
        
        // Then
        XCTAssertFalse(state.isLoading, "isLoading should be false after a successful response")
        XCTAssertTrue(state.hasFetchedOnce, "hasFetchedOnce should be true after the first fetch")
        XCTAssertEqual(state.pullRequests.count, mockPRs.count, "The number of PRs should match the mock data")
        XCTAssertEqual(state.openCount, 1, "The open PR count should be calculated correctly")
        XCTAssertEqual(state.closedCount, 1, "The closed PR count should be calculated correctly")
        XCTAssertNil(effect, "No new effect should be returned after a success response")
    }
    
    // Tests if, after a failed API response, the state is updated with an error message.
    func test_pullRequestsResponse_withFailure_shouldUpdateStateWithError() {
        // Given
        var state = PullRequestListState.initial(repositoryName: mockRepository.name)
        state.isLoading = true
        let error = MockAPIService.MockError.networkError
        let action = PullRequestListAction.pullRequestsResponse(.failure(error))
        let dependency: (apiService: APIServiceProtocol, repository: Repository) = (apiService: mockApiService, repository: mockRepository)
        
        // When
        let effect = pullRequestListReducer(state: &state, action: action, dependency: dependency)
        
        // Then
        XCTAssertFalse(state.isLoading, "isLoading should be false after a failure response")
        XCTAssertTrue(state.hasFetchedOnce, "hasFetchedOnce should be true even after an error")
        XCTAssertNotNil(state.error, "An error message should be set in the state")
        XCTAssertTrue(state.pullRequests.isEmpty, "The pull requests list should be empty after an error")
        XCTAssertNil(effect, "No new effect should be returned after a failure response")
    }
}
