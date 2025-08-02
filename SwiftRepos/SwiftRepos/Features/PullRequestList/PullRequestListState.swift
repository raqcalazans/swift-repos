struct PullRequestListState {
    
    var isLoading: Bool
    var pullRequests: [PullRequest]
    var error: String?
    let repositoryName: String

    static func initial(repositoryName: String) -> PullRequestListState {
        return PullRequestListState(
            isLoading: false,
            pullRequests: [],
            error: nil,
            repositoryName: repositoryName
        )
    }
}
