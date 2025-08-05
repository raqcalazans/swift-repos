import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        setupNavigationBarAppearance()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let apiService: APIServiceProtocol = APIService()

        let repositoryCoordinator = RepositoryCoordinator(
            navigationController: navigationController,
            apiService: apiService 
        )
        
        childCoordinators.append(repositoryCoordinator)
        repositoryCoordinator.start()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGroupedBackground
        appearance.shadowColor = .clear
        
        let backButtonImage = UIImage(systemName: "arrow.backward")
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        
        navigationController.navigationBar.tintColor = .label
    }
}
