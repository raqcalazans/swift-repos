enum PullRequestListAction {

    case viewDidAppear
    case pullRequestSelected(PullRequest)
    case pullRequestsResponse(TaskResult<[PullRequest]>)
}
