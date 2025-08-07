import UIKit
import RxSwift

final class RepositoryCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private let apiService: APIServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController, apiService: APIServiceProtocol) {
        self.navigationController = navigationController
        self.apiService = apiService
    }
    
    func start() {
        showRepositoryList()
    }

    private func showRepositoryList() {
        let store = Store(
            initialState: RepositoryListState.initial,
            reducer: repositoryListReducer,
            dependency: apiService
        )
        
        let viewController = RepositoryListViewController(viewModel: store)
        
        store.action
            .compactMap { action -> Repository? in
                if case .repositorySelected(let repo) = action {
                    return repo
                }
                return nil
            }
            .subscribe(onNext: { [weak self] repository in
                self?.showPullRequestList(for: repository)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPullRequestList(for repository: Repository) {
        let store = Store(
            initialState: PullRequestListState.initial(repositoryName: repository.name),
            reducer: pullRequestListReducer,
            dependency: (apiService: apiService, repository: repository)
        )
        
        let viewController = PullRequestListViewController(viewModel: store)
        
        store.action
            .compactMap { action -> URL? in
                if case .pullRequestSelected(let pr) = action {
                    return pr.htmlUrl
                }
                return nil
            }
            .subscribe(onNext: { [weak self] url in
                self?.showPullRequestInWebView(url: url)
            })
            .disposed(by: disposeBag)

        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPullRequestInWebView(url: URL) {
        let webViewController = WebViewController(url: url)
        let modalNavController = UINavigationController(rootViewController: webViewController)
        
        navigationController.present(modalNavController, animated: true)
    }
}
