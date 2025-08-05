import UIKit
import RxSwift

final class RepositoryListViewController: UIViewController {

    private let viewModel: RepositoryListViewModelProtocol
    private let disposeBag = DisposeBag()

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    init(viewModel: RepositoryListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.intent.accept(.viewDidAppear)
    }

    private func setupUI() {
        title = "Repositórios Swift"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseID)
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
            .map { $0.repositories }
            .drive(tableView.rx.items(cellIdentifier: RepositoryCell.reuseID, cellType: RepositoryCell.self)) { (row, repository, cell) in
                cell.configure(with: repository)
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

        tableView.rx.modelSelected(Repository.self)
            .map { .repositorySelected($0) }
            .bind(to: viewModel.intent)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
