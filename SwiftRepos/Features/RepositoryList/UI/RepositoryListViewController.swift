import UIKit
import RxSwift
import RxCocoa

typealias RepositoryListStore = Store<
    RepositoryListState,
    RepositoryListAction,
    APIServiceProtocol
>

final class RepositoryListViewController: BaseViewController<RepositoryListStore> {

    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Layout.RepositoryCell.estimatedRowHeight
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
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: Layout.standardViewHeight
        ))
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        return view
    }()
    
    private let paginationErrorToast: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemRed.withAlphaComponent(0.9)
        label.textColor = .white
        label.font = Typography.subheadline
        label.textAlignment = .center
        label.layer.cornerRadius = Layout.cornerRadius
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private var hideToastWorkItem: DispatchWorkItem?

    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.action.accept(.viewDidAppear)
    }

    // MARK: - Overridden Methods
    
    override func setupView() {
        super.setupView()
        
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        // MARK: - Outputs (Store -> View)
        
        viewModel.state
            .map { $0.repositories }
            .skip(1)
            .drive(tableView.rx.items(
                cellIdentifier: RepositoryCell.reuseID,
                cellType: RepositoryCell.self)) { (row, repository, cell) in
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
        
        viewModel.state
            .map { $0.paginationError }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] errorText in
                guard let self = self else { return }
                self.hideToastWorkItem?.cancel()
                
                guard let text = errorText else {
                    self.hidePaginationErrorToast()
                    return
                }
                
                self.showPaginationErrorToast(message: text)
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    self?.hidePaginationErrorToast()
                }
                self.hideToastWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: requestWorkItem)
            })
            .disposed(by: disposeBag)

        // MARK: - Inputs (View -> Store)
        
        tableView.rx.modelSelected(Repository.self)
            .map { .repositorySelected($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
            .throttle(
                .milliseconds(AppConfiguration.Pagination.scrollThrottleInterval),
                scheduler: MainScheduler.instance
            )
            .map { [weak self] offset -> Bool in
                guard let self = self else { return false }
                
                let contentHeight = self.tableView.contentSize.height
                let visibleHeight = self.tableView.frame.height

                guard contentHeight > visibleHeight else { return false }
                
                let y = offset.y + visibleHeight
                let threshold = contentHeight - AppConfiguration.Pagination.threshold
                
                return y >= threshold
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in .reachedEndOfList }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Setup Helpers
    
    private func setupProperties() {
        title = String.LocalizedKeys.repositoryListTitle
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        view.addSubview(paginationErrorToast)
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
            
            paginationErrorToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.medium),
            paginationErrorToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.medium),
            paginationErrorToast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.medium),
            paginationErrorToast.heightAnchor.constraint(equalToConstant: Layout.standardViewHeight)
        ])
    }
    
    private func showPaginationErrorToast(message: String) {
        paginationErrorToast.text = message
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.paginationErrorToast.alpha = 1
        })
    }
    
    private func hidePaginationErrorToast() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.paginationErrorToast.alpha = 0
        })
    }
}
