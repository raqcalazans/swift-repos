import UIKit
import RxSwift
import RxCocoa

final class RepositoryListViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: RepositoryListViewModelProtocol
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        return view
    }()

    // MARK: - Initializers
    
    init(viewModel: RepositoryListViewModelProtocol) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.intent.accept(.viewDidAppear)
    }

    // MARK: - Private Setup
    
    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupProperties() {
        title = "Repositórios Swift"
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        // MARK: - Outputs (ViewModel -> View)
        
        viewModel.state
            .map { $0.repositories }
            .skip(1)
            .drive(tableView.rx.items(cellIdentifier: RepositoryCell.reuseID, cellType: RepositoryCell.self)) { (row, repository, cell) in
                cell.configure(with: repository)
            }
            .disposed(by: disposeBag)
            
        viewModel.state
            .map { $0.isLoadingFirstPage }
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.state
            .map { $0.isFetchingNextPage }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isFetching in
                if isFetching {
                    self?.tableView.tableFooterView = self?.footerView
                } else {
                    self?.tableView.tableFooterView = UIView(frame: .zero)
                }
            })
            .disposed(by: disposeBag)
            
        viewModel.state
            .map { $0.error == nil }
            .drive(errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
            
        viewModel.state
            .map { $0.error }
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)

        // MARK: - Inputs (View -> ViewModel)
        
        tableView.rx.modelSelected(Repository.self)
            .map { .repositorySelected($0) }
            .bind(to: viewModel.intent)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { [weak self] offset -> Bool in
                guard let self = self else { return false }
                
                let contentHeight = self.tableView.contentSize.height
                let visibleHeight = self.tableView.frame.height

                guard contentHeight > visibleHeight else { return false }
                
                let y = offset.y + visibleHeight
                let threshold = contentHeight - 200
                
                return y >= threshold
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in .reachedEndOfList }
            .bind(to: viewModel.intent)
            .disposed(by: disposeBag)
    }
}
