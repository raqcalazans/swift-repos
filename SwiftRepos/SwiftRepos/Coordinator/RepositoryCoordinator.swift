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
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPullRequestList() {}
    
    private func showPullRequestWebView() {}
}
