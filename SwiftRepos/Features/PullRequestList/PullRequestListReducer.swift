/// The Reducer is a pure function that describes how the application's state changes in response to each action.
/// It also describes which side effects (like API calls) should be executed.
/// - Parameters:
///   - state: The current state of the feature. It will be modified directly (inout).
///   - action: The action that occurred.
///   - dependency: The external dependencies of the feature, like the APIService.
/// - Returns: An optional `Effect` that will be executed by the Store.
func pullRequestListReducer(
    state: inout PullRequestListState,
    action: PullRequestListAction,
    dependency: (apiService: APIServiceProtocol, repository: Repository)
) -> Effect<PullRequestListAction>? {
    
    switch action {
    case .viewDidAppear:
        guard !state.hasFetchedOnce else { return nil }
        
        state.isLoading = true
        return .run { send in
            let result: TaskResult<[PullRequest]>
            do {
                guard let owner = dependency.repository.owner?.login,
                      let repoName = dependency.repository.name else {
                    
                    throw APIError.invalidURL
                }
                let prs = try await dependency.apiService.fetchPullRequests(owner: owner, repoName: repoName)
                result = .success(prs)
            } catch {
                result = .failure(error)
            }
            await send(.pullRequestsResponse(result))
        }
        
    case .pullRequestSelected:
        return nil
        
    case .pullRequestsResponse(.success(let prs)):
        state.isLoading = false
        state.hasFetchedOnce = true
        state.pullRequests = prs
        state.openCount = prs.filter { $0.state == "open" }.count
        state.closedCount = prs.count - state.openCount
        return nil
        
    case .pullRequestsResponse(.failure(let error)):
        state.isLoading = false
        state.hasFetchedOnce = true
        state.error = error.localizedDescription
        return nil
    }
}
