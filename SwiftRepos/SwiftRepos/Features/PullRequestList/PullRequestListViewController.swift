import UIKit
import RxSwift

final class PullRequestListViewController: UIViewController {

    private let viewModel: PullRequestListViewModelProtocol
    private let disposeBag = DisposeBag()

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    
    private let headerView = UIView()
    private let statsLabel = UILabel()

    init(viewModel: PullRequestListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.intent.accept(.viewDidAppear)
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        statsLabel.frame = CGRect(x: 16, y: 0, width: view.frame.width - 32, height: 44)
        statsLabel.font = .systemFont(ofSize: 14)
        statsLabel.textColor = .secondaryLabel
        statsLabel.textAlignment = .center
        headerView.addSubview(statsLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableHeaderView = headerView
        tableView.register(PullRequestCell.self, forCellReuseIdentifier: PullRequestCell.reuseID)
        view.addSubview(tableView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.state
            .map { "\($0.repositoryName) PRs" }
            .drive(self.rx.title)
            .disposed(by: disposeBag)

        viewModel.state
            .map { "\($0.openCount) opened / \($0.closedCount) closed" }
            .drive(statsLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.state
            .map { $0.pullRequests }
            .drive(tableView.rx.items(
                cellIdentifier: PullRequestCell.reuseID,
                cellType: PullRequestCell.self)) { (row, pullRequest, cell) in
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

        tableView.rx.modelSelected(PullRequest.self)
            .map { .pullRequestSelected($0) }
            .bind(to: viewModel.intent)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
