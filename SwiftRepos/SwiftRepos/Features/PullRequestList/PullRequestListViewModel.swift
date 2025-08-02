import Foundation

import RxSwift
import RxCocoa
import RxRelay

enum PullRequestListNavigation {
    case showPullRequestInWebView(url: URL)
}

final class PullRequestListViewModel: PullRequestListViewModelProtocol {
    
    let intent = PublishRelay<PullRequestListIntent>()
    let state: Driver<PullRequestListState>
    let navigation: Signal<PullRequestListNavigation>
    
    private let disposeBag = DisposeBag()

    init(repository: Repository, apiService: APIServiceProtocol) {
        let stateRelay = BehaviorRelay<PullRequestListState>(value: .initial(repositoryName: repository.name))
        let navigationRelay = PublishRelay<PullRequestListNavigation>()
        
        self.state = stateRelay.asDriver()
        self.navigation = navigationRelay.asSignal()

        intent
            .subscribe(onNext: { intent in
                switch intent {
                case .viewDidAppear:
                    guard stateRelay.value.pullRequests.isEmpty else { return }
                    
                    var currentState = stateRelay.value
                    currentState.isLoading = true
                    stateRelay.accept(currentState)
                    
                    Task {
                        do {
                            let prs = try await apiService.fetchPullRequests(owner: repository.owner.login, repoName: repository.name)
                            stateRelay.accept(PullRequestListState(isLoading: false, pullRequests: prs, error: nil, repositoryName: repository.name))
                        } catch {
                            stateRelay.accept(PullRequestListState(isLoading: false, pullRequests: [], error: error.localizedDescription, repositoryName: repository.name))
                        }
                    }
                    
                case .pullRequestSelected(let pullRequest):
                    navigationRelay.accept(.showPullRequestInWebView(url: pullRequest.htmlUrl))
                }
            })
            .disposed(by: disposeBag)
    }
}
