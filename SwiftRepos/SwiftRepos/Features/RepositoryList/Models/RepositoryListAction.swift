enum RepositoryListAction {
    
    case viewDidAppear
    case repositorySelected(Repository)
    case reachedEndOfList
    case repositoriesResponse(TaskResult<[Repository]>)
    case nextPageResponse(TaskResult<[Repository]>)
}
