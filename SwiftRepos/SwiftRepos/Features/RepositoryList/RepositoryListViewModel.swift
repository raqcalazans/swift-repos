import RxRelay
import RxCocoa
import RxSwift

enum RepositoryListNavigation {
    case showPullRequests(for: Repository)
}

final class RepositoryListViewModel: RepositoryListViewModelProtocol {
    
    let intent = PublishRelay<RepositoryListIntent>()
    let state: Driver<RepositoryListState>
    let navigation: Signal<RepositoryListNavigation>
    
    private let disposeBag = DisposeBag()

    init(apiService: APIServiceProtocol) {
        
        let stateRelay = BehaviorRelay<RepositoryListState>(value: .initial)
        let navigationRelay = PublishRelay<RepositoryListNavigation>()
        
        self.state = stateRelay.asDriver()
        self.navigation = navigationRelay.asSignal()

        intent
            .subscribe(onNext: { intent in
                switch intent {
                case .viewDidAppear:
                    guard stateRelay.value.repositories.isEmpty else { return }

                    stateRelay.accept(RepositoryListState(isLoading: true, repositories: [], error: nil))

                    Task {
                        do {
                            let repos = try await apiService.fetchRepositories(page: 1)

                            stateRelay.accept(RepositoryListState(isLoading: false, repositories: repos, error: nil))
                        } catch {
                            stateRelay.accept(RepositoryListState(isLoading: false, repositories: [], error: error.localizedDescription))
                        }
                    }
                    
                case .repositorySelected(let repository):
                    navigationRelay.accept(.showPullRequests(for: repository))
                }
            })
            .disposed(by: disposeBag)
    }
}
