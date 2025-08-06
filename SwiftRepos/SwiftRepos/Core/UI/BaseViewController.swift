import UIKit
import RxSwift
import RxCocoa

/// A generic base class for all ViewControllers in the application that follow the MVI pattern.
/// It handles ViewModel injection and defines a standard configuration structure.
class BaseViewController<VM: ViewModelProtocol>: UIViewController {
    
    // MARK: - Properties
    
    /// The ViewModel instance, which is injected in the initializer.
    let viewModel: VM
    
    /// The DisposeBag to manage RxSwift subscriptions.
    let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    // MARK: - Abstract Methods
    // Subclasses are required to implement these methods for their specific configuration.
    
    /// Configures the properties, hierarchy, and constraints of the subviews.
    /// This method must be implemented by subclasses.
    func setupView() {
        // Subclasses should call super.setupView() if this implementation is expanded.
    }
    
    /// Configures the bindings between the View and the ViewModel.
    /// This method must be implemented by subclasses.
    func bindViewModel() {
        // Subclasses should call super.bindViewModel() if this implementation is expanded.
    }
}
