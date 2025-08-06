import RxRelay
import RxCocoa
import RxSwift

enum RepositoryListNavigation {
    case showPullRequests(for: Repository)
}

enum RepositoryListAction {
    case fetchFirstPage
    case fetchNextPage(page: Int)
}

enum RepositoryListResult {
    case setLoadingFirstPage(Bool)
    case fetchFirstPageSuccess(repos: [Repository])
    case fetchFirstPageFailure(error: Error)
    
    case setLoadingNextPage(Bool)
    case fetchNextPageSuccess(repos: [Repository], page: Int)
    case fetchNextPageFailure(error: Error)
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

        let action = intent
            .withLatestFrom(stateRelay) { intent, state in
                (intent, state)
            }
            .flatMapLatest { intent, state -> Observable<RepositoryListAction> in
                switch intent {
                case .viewDidAppear:
                    guard state.repositories.isEmpty else { return .empty() }
                    return .just(.fetchFirstPage)
                    
                case .reachedEndOfList:
                    guard !state.isFetchingNextPage && state.canLoadMorePages else { return .empty() }
                    return .just(.fetchNextPage(page: state.currentPage + 1))
                    
                case .repositorySelected(let repository):
                    navigationRelay.accept(.showPullRequests(for: repository))
                    return .empty()
                }
            }
            .share()

        let result = action
            .flatMapLatest { action -> Observable<RepositoryListResult> in
                switch action {
                case .fetchFirstPage:
                    return Observable.create { observer in
                        observer.onNext(.setLoadingFirstPage(true))
                        Task {
                            do {
                                let repos = try await apiService.fetchRepositories(page: 1)
                                observer.onNext(.fetchFirstPageSuccess(repos: repos))
                                observer.onCompleted()
                            } catch {
                                observer.onNext(.fetchFirstPageFailure(error: error))
                                observer.onCompleted()
                            }
                        }
                        return Disposables.create()
                    }
                    
                case .fetchNextPage(let page):
                    return Observable.create { observer in
                        observer.onNext(.setLoadingNextPage(true))
                        Task {
                            do {
                                let repos = try await apiService.fetchRepositories(page: page)
                                observer.onNext(.fetchNextPageSuccess(repos: repos, page: page))
                                observer.onCompleted()
                            } catch {
                                observer.onNext(.fetchNextPageFailure(error: error))
                                observer.onCompleted()
                            }
                        }
                        return Disposables.create()
                    }
                }
            }

        result
            .scan(RepositoryListState.initial) { previousState, result -> RepositoryListState in
                var newState = previousState
                
                switch result {
                case .setLoadingFirstPage(let isLoading):
                    newState.isLoadingFirstPage = isLoading
                    newState.error = nil
                    
                case .fetchFirstPageSuccess(let repos):
                    newState.isLoadingFirstPage = false
                    newState.repositories = repos
                    
                case .fetchFirstPageFailure(let error):
                    newState.isLoadingFirstPage = false
                    newState.error = error.localizedDescription

                case .setLoadingNextPage(let isLoading):
                    newState.isFetchingNextPage = isLoading
                    
                case .fetchNextPageSuccess(let repos, let page):
                    newState.isFetchingNextPage = false
                    newState.repositories.append(contentsOf: repos)
                    newState.currentPage = page
                    newState.canLoadMorePages = !repos.isEmpty
                    
                case .fetchNextPageFailure(let error):
                    newState.isFetchingNextPage = false
                    newState.error = error.localizedDescription
                }
                
                return newState
            }
            .startWith(.initial)
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
    }
}
