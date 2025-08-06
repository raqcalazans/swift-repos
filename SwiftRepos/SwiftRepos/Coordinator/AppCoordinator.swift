import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []
    private let apiService: APIServiceProtocol

    init(window: UIWindow, apiService: APIServiceProtocol) {
        self.window = window
        self.navigationController = UINavigationController()
        self.apiService = apiService
        
        setupNavigationBarAppearance()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

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
        
        let backButtonImage = SFSymbols.backArrow.image
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        
        navigationController.navigationBar.tintColor = .label
    }
}
