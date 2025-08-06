struct PullRequestListState {
    var isLoading: Bool
    var pullRequests: [PullRequest]
    var error: String?
    let repositoryName: String?
    
    var openCount: Int
    var closedCount: Int
    var hasFetchedOnce: Bool

    static func initial(repositoryName: String?) -> PullRequestListState {
        return PullRequestListState(
            isLoading: false,
            pullRequests: [],
            error: nil,
            repositoryName: repositoryName,
            openCount: 0,
            closedCount: 0,
            hasFetchedOnce: false
        )
    }
}
