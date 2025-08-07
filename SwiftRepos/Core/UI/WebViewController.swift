import UIKit
import WebKit

final class WebViewController: UIViewController {

    // MARK: - Properties
    
    private let url: URL

    // MARK: - UI Components
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - Initializers
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadRequest()
    }
    
    // MARK: - Private Setup
    
    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupProperties() {
        title = "Pull Request"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }

    private func setupHierarchy() {
        view.addSubview(webView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadRequest() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
