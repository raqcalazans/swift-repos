struct RepositoryListState {
    
    var isLoadingFirstPage: Bool
    var repositories: [Repository]
    var error: String?
    var currentPage: Int
    var isFetchingNextPage: Bool
    var canLoadMorePages: Bool

    static let initial = RepositoryListState(
        isLoadingFirstPage: false,
        repositories: [],
        error: nil,
        currentPage: 1,
        isFetchingNextPage: false,
        canLoadMorePages: true
    )
}
