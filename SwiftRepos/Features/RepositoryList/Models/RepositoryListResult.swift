enum RepositoryListResult {
    
    case setLoadingFirstPage(Bool)
    case fetchFirstPageSuccess(repos: [Repository])
    case fetchFirstPageFailure(error: Error)
    
    case setLoadingNextPage(Bool)
    case fetchNextPageSuccess(repos: [Repository], page: Int)
    case fetchNextPageFailure(error: Error)
}
