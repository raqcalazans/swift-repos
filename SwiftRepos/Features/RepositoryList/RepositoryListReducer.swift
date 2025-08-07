/// The Reducer is a pure function that describes how the application's state changes in response to each action.
/// It also describes which side effects (like API calls) should be executed.
/// - Parameters:
///   - state: The current state of the feature. It will be modified directly (inout).
///   - action: The action that occurred.
///   - dependency: The external dependencies of the feature, like the APIService.
/// - Returns: An optional `Effect` that will be executed by the Store.
func repositoryListReducer(
    state: inout RepositoryListState,
    action: RepositoryListAction,
    dependency: APIServiceProtocol
) -> Effect<RepositoryListAction>? {
    
    switch action {
    case .viewDidAppear:
        guard state.repositories.isEmpty else { return nil }
        
        state.isLoadingFirstPage = true
        
        return .run { send in
            let result: TaskResult<[Repository]>
            do {
                let repos = try await dependency.fetchRepositories(page: 1)
                result = .success(repos)
            } catch {
                result = .failure(error)
            }
            await send(.repositoriesResponse(result))
        }

    case .reachedEndOfList:
        guard !state.isFetchingNextPage && state.canLoadMorePages else { return nil }
        
        state.isFetchingNextPage = true
        let nextPage = state.currentPage + 1

        return .run { send in
            let result: TaskResult<[Repository]>
            do {
                let repos = try await dependency.fetchRepositories(page: nextPage)
                result = .success(repos)
            } catch {
                result = .failure(error)
            }
            await send(.nextPageResponse(result))
        }
        
    case .repositorySelected:
        return nil
        
    case .repositoriesResponse(.success(let repos)):
        state.isLoadingFirstPage = false
        state.repositories = repos
        state.canLoadMorePages = !repos.isEmpty
        return nil
        
    case .repositoriesResponse(.failure(let error)):
        state.isLoadingFirstPage = false
        state.error = error.localizedDescription
        return nil
        
    case .nextPageResponse(.success(let repos)):
        state.isFetchingNextPage = false
        state.repositories.append(contentsOf: repos)
        state.currentPage += 1
        state.canLoadMorePages = !repos.isEmpty
        return nil
        
    case .nextPageResponse(.failure(let error)):
        state.isFetchingNextPage = false
        return nil
    }
}
