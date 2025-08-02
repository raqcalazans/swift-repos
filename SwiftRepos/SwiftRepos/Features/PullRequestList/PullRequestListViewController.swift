import UIKit
import RxSwift

final class PullRequestListViewController: UIViewController {

    private let viewModel: PullRequestListViewModelProtocol
    private let disposeBag = DisposeBag()

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

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
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRCell")
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
            .map { $0.repositoryName }
            .drive(self.rx.title)
            .disposed(by: disposeBag)
            
        viewModel.state
            .map { $0.pullRequests }
            .drive(tableView.rx.items(cellIdentifier: "PRCell", cellType: UITableViewCell.self)) { (row, pullRequest, cell) in
                var content = cell.defaultContentConfiguration()
                content.text = pullRequest.title
                content.secondaryText = "Autor: \(pullRequest.user.login)"
                cell.contentConfiguration = content
                cell.accessoryType = .disclosureIndicator
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
    }
}
