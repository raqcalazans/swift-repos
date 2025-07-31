struct RepositoryListState {
    
    var isLoading: Bool
    var repositories: [Repository]
    var error: String?

    static let initial = RepositoryListState(isLoading: false, repositories: [], error: nil)
}
