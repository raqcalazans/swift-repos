import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class PullRequestListViewModel: ViewModelProtocol {
    
    typealias Intent = PullRequestListIntent
    typealias State = PullRequestListState
    
    let intent = PublishRelay<Intent>()
    let state: Driver<State>
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
                    guard !stateRelay.value.hasFetchedOnce else { return }
                    
                    var currentState = stateRelay.value
                    currentState.isLoading = true
                    stateRelay.accept(currentState)
                    
                    Task {
                        guard let ownerLogin = repository.owner?.login,
                              let repoName = repository.name else {

                            stateRelay.accept(PullRequestListState(
                                isLoading: false,
                                pullRequests: [],
                                error: "Informações do repositório inválidas.",
                                repositoryName: repository.name,
                                openCount: 0,
                                closedCount: 0,
                                hasFetchedOnce: true
                            ))
                            return
                        }
                        
                        do {
                            let prs = try await apiService.fetchPullRequests(owner: ownerLogin, repoName: repoName)
                            
                            let openCount = prs.filter { $0.state == "open" }.count
                            let closedCount = prs.count - openCount

                            stateRelay.accept(PullRequestListState(
                                isLoading: false,
                                pullRequests: prs,
                                error: nil,
                                repositoryName: repository.name,
                                openCount: openCount,
                                closedCount: closedCount,
                                hasFetchedOnce: true
                            ))
                        } catch {
                            stateRelay.accept(PullRequestListState(
                                isLoading: false,
                                pullRequests: [],
                                error: error.localizedDescription,
                                repositoryName: repository.name,
                                openCount: 0,
                                closedCount: 0,
                                hasFetchedOnce: true
                            ))
                        }
                    }
                    
                case .pullRequestSelected(let pullRequest):
                    if let url = pullRequest.htmlUrl {
                        navigationRelay.accept(.showPullRequestInWebView(url: url))
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
