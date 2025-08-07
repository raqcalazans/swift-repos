import XCTest
@testable import SwiftRepos

final class RepositoryListReducerTests: XCTestCase {

    // MARK: - Properties

    private var mockApiService: MockAPIService!

    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        
        mockApiService = MockAPIService()
    }

    override func tearDown() {
        mockApiService = nil
        
        super.tearDown()
    }

    // MARK: - Tests

    // Tests if, upon receiving the .viewDidAppear action, the state is updated to loading
    // and if an effect to fetch data is returned.
    func test_viewDidAppear_shouldSetLoadingStateAndReturnFetchEffect() {
        // Given
        var state = RepositoryListState.initial
        let action = RepositoryListAction.viewDidAppear
        
        // When
        let effect = repositoryListReducer(state: &state, action: action, dependency: mockApiService)
        
        // Then
        XCTAssertTrue(state.isLoadingFirstPage, "isLoadingFirstPage should be true after viewDidAppear")
        XCTAssertNotNil(effect, "An effect to fetch repositories should be returned")
    }
    
    // Tests if, after a successful API response, the state is updated with the repositories.
    func test_repositoriesResponse_withSuccess_shouldUpdateStateWithRepositories() {
        // Given
        var state = RepositoryListState.initial
        state.isLoadingFirstPage = true
        let mockRepos = mockApiService.mockRepositories
        let action = RepositoryListAction.repositoriesResponse(.success(mockRepos))
        
        // When
        let effect = repositoryListReducer(state: &state, action: action, dependency: mockApiService)
        
        // Then
        XCTAssertFalse(state.isLoadingFirstPage, "isLoadingFirstPage should be false after a successful response")
        XCTAssertEqual(state.repositories.count, mockRepos.count, "The number of repositories in the state should match the mock data")
        XCTAssertEqual(state.repositories.first?.name, mockRepos.first?.name, "The repository data should be correctly stored in the state")
        XCTAssertNil(effect, "No new effect should be returned after a success response")
    }
    
    // Tests if, after a failed API response, the state is updated with an error message.
    func test_repositoriesResponse_withFailure_shouldUpdateStateWithError() {
        // Given
        var state = RepositoryListState.initial
        state.isLoadingFirstPage = true
        let error = MockAPIService.MockError.networkError
        let action = RepositoryListAction.repositoriesResponse(.failure(error))
        
        // When
        let effect = repositoryListReducer(state: &state, action: action, dependency: mockApiService)
        
        // Then
        XCTAssertFalse(state.isLoadingFirstPage, "isLoadingFirstPage should be false after a failure response")
        XCTAssertNotNil(state.error, "An error message should be set in the state")
        XCTAssertTrue(state.repositories.isEmpty, "The repositories list should be empty after an error")
        XCTAssertNil(effect, "No new effect should be returned after a failure response")
    }

    // Tests the pagination logic: if the .reachedEndOfList action is received,
    // the loading state for the next page should be activated and an effect should be returned.
    func test_reachedEndOfList_whenCanLoadMore_shouldSetFetchingNextPageAndReturnEffect() {
        // Given
        var state = RepositoryListState.initial
        state.canLoadMorePages = true
        let action = RepositoryListAction.reachedEndOfList
        
        // When
        let effect = repositoryListReducer(state: &state, action: action, dependency: mockApiService)
        
        // Then
        XCTAssertTrue(state.isFetchingNextPage, "isFetchingNextPage should be true")
        XCTAssertNotNil(effect, "An effect to fetch the next page should be returned")
    }
}
