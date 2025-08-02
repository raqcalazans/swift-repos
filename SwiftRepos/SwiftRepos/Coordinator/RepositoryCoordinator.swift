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
        let viewModel = RepositoryListViewModel(apiService: apiService)
        let viewController = RepositoryListViewController(viewModel: viewModel)

        viewModel.navigation
            .emit(onNext: { [weak self] navigationEvent in
                switch navigationEvent {
                case .showPullRequests(let repository):
                    self?.showPullRequestList(for: repository)
                }
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPullRequestList(for repository: Repository) {
        let viewModel = PullRequestListViewModel(repository: repository, apiService: apiService)
        let viewController = PullRequestListViewController(viewModel: viewModel)

        viewModel.navigation
            .emit(onNext: { [weak self] navigationEvent in
                switch navigationEvent {
                case .showPullRequestInWebView(let url):
                    self?.showPullRequestInWebView(url: url)
                }
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
