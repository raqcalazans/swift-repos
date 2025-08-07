import UIKit
import Kingfisher

final class PullRequestCell: UITableViewCell {

    static let reuseID = Identifiers.Cell.pullRequest

    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = Layout.borderWidth
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.subtitle
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.subheadline
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let authorAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Layout.Avatar.smallCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.subheadline
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.caption
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()

    private let mainStack = UIStackView()
    private let authorStack = UIStackView()
    private let authorInfoStack = UIStackView()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Configuration

    public func configure(with pr: PullRequest) {
        titleLabel.text = pr.title
        bodyLabel.text = pr.body ?? "Sem descrição."
        
        if let user = pr.user {
            authorNameLabel.text = user.login
            if let avatarUrlString = user.avatarUrl, let avatarURL = URL(string: avatarUrlString) {
                authorAvatarImageView.kf.setImage(with: avatarURL, placeholder: SFSymbols.placeholderUser.image)
            } else {
                authorAvatarImageView.image = SFSymbols.placeholderUser.image
            }
        } else {
            authorNameLabel.text = "Desconhecido"
            authorAvatarImageView.image = SFSymbols.placeholderUser.image
        }
        
        dateLabel.text = pr.createdAt?.toFormattedDate()
    }
    
    // MARK: - Private Setup

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        configureStacks()
        setupHierarchy()
        setupConstraints()
    }
    
    private func configureStacks() {
        mainStack.axis = .vertical
        mainStack.spacing = Spacing.small
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        authorStack.axis = .horizontal
        authorStack.spacing = Spacing.small
        authorStack.alignment = .center
        
        authorInfoStack.axis = .horizontal
        authorInfoStack.spacing = Spacing.small
    }
    
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
        
        authorInfoStack.addArrangedSubview(authorNameLabel)
        authorInfoStack.addArrangedSubview(dateLabel)
        
        authorStack.addArrangedSubview(authorAvatarImageView)
        authorStack.addArrangedSubview(authorInfoStack)
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(bodyLabel)
        mainStack.addArrangedSubview(authorStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.small),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.medium),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.small),

            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Spacing.medium),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Spacing.medium),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Spacing.medium),
            
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: Layout.Avatar.small),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: Layout.Avatar.small),
        ])
    }
}
