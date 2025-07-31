import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let apiService: APIServiceProtocol = APIService()

        let repositoryCoordinator = RepositoryCoordinator(
            navigationController: navigationController,
            apiService: apiService 
        )
        
        repositoryCoordinator.start()
    }
}
