import UIKit
import RxSwift
import RxCocoa

typealias PullRequestListStore = Store<
    PullRequestListState,
    PullRequestListAction,
    (apiService: APIServiceProtocol, repository: Repository)
>

final class PullRequestListViewController: BaseViewController<PullRequestListStore> {

    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.register(PullRequestCell.self, forCellReuseIdentifier: PullRequestCell.reuseID)
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
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum Pull Request encontrado para este repositório."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: Spacing.medium, y: 0, width: view.frame.width - (Spacing.medium * 2), height: 44)
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        view.addSubview(statsLabel)
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.intent.accept(.viewDidAppear)
    }

    // MARK: - Override Methods
    
    override func setupView() {
        super.setupView()
        
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        // MARK: - Outputs (ViewModel -> View)
        // MARK: - Outputs (Store -> View)
        
        viewModel.state
            .map { "\($0.repositoryName ?? "") PRs" }
            .drive(self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { "\($0.openCount) opened / \($0.closedCount) closed" }
            .drive(statsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.pullRequests }
            .drive(tableView.rx.items(cellIdentifier: PullRequestCell.reuseID, cellType: PullRequestCell.self)) { (row, pullRequest, cell) in
                cell.configure(with: pullRequest)
            }
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.isLoading }
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.error == nil }
            .drive(errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.error }
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { state in
                return !(state.hasFetchedOnce && !state.isLoading && state.error == nil && state.pullRequests.isEmpty)
            }
            .drive(emptyStateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // MARK: - Inputs (View -> Store)
        
        tableView.rx.modelSelected(PullRequest.self)
            .map { .pullRequestSelected($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Setup Helpers
    
    private func setupProperties() {
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.tableHeaderView = headerView
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        view.addSubview(emptyStateLabel)
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
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
