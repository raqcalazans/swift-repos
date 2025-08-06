import UIKit
import Kingfisher

final class RepositoryCell: UITableViewCell {

    static let reuseID = "RepositoryCell"
    
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
    
    private let repoNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let forksIcon = UIImageView(image: SFSymbols.fork.image)
    private let starIcon = UIImageView(image: SFSymbols.star.image)
    
    private let forkCountLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.subheadline
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let starCountLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.subheadline
        label.textColor = .secondaryLabel
        return label
    }()

    private let authorAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Layout.Avatar.mediumCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.caption
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let mainHorizontalStack = UIStackView()
    private let leftVerticalStack = UIStackView()
    private let rightVerticalStack = UIStackView()
    private let statsHorizontalStack = UIStackView()
    private let forksStack = UIStackView()
    private let starsStack = UIStackView()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Configuration
    
    public func configure(with repository: Repository) {
        repoNameLabel.text = repository.name ?? "Nome Indisponível"
        descriptionLabel.text = repository.description ?? "Sem descrição."
        starCountLabel.text = "\(repository.stargazersCount ?? 0)"
        forkCountLabel.text = "\(repository.forksCount ?? 0)"
        
        if let owner = repository.owner {
            authorNameLabel.text = owner.login
            
            if let avatarUrlString = owner.avatarUrl,
               let avatarURL = URL(string: avatarUrlString) {
                
                authorAvatarImageView.kf.setImage(
                    with: avatarURL,
                    placeholder: SFSymbols.placeholderUser.image
                )
            } else {
                authorAvatarImageView.image = SFSymbols.placeholderUser.image
            }
        } else {
            authorNameLabel.text = "Desconhecido"
            authorAvatarImageView.image = SFSymbols.placeholderUser.image
        }
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
        configureStack(mainHorizontalStack, axis: .horizontal, spacing: Spacing.medium, alignment: .center)
        configureStack(leftVerticalStack, axis: .vertical, spacing: Spacing.small)
        configureStack(rightVerticalStack, axis: .vertical, spacing: Spacing.extraSmall, alignment: .center)
        configureStack(statsHorizontalStack, axis: .horizontal, spacing: Spacing.medium)
        configureStack(forksStack, axis: .horizontal, spacing: Spacing.extraSmall, alignment: .center)
        configureStack(starsStack, axis: .horizontal, spacing: Spacing.extraSmall, alignment: .center)

        starIcon.tintColor = .systemYellow
        starIcon.contentMode = .scaleAspectFit
        forksIcon.tintColor = .secondaryLabel
        forksIcon.contentMode = .scaleAspectFit
    }

    private func configureStack(_ stack: UIStackView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .fill) {
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
    }
     
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainHorizontalStack)

        forksStack.addArrangedSubview(forksIcon)
        forksStack.addArrangedSubview(forkCountLabel)
        starsStack.addArrangedSubview(starIcon)
        starsStack.addArrangedSubview(starCountLabel)
        
        statsHorizontalStack.addArrangedSubview(forksStack)
        statsHorizontalStack.addArrangedSubview(starsStack)
        statsHorizontalStack.addArrangedSubview(UIView())

        leftVerticalStack.addArrangedSubview(repoNameLabel)
        leftVerticalStack.addArrangedSubview(descriptionLabel)
        leftVerticalStack.addArrangedSubview(statsHorizontalStack)

        rightVerticalStack.addArrangedSubview(authorAvatarImageView)
        rightVerticalStack.addArrangedSubview(authorNameLabel)

        mainHorizontalStack.addArrangedSubview(leftVerticalStack)
        mainHorizontalStack.addArrangedSubview(rightVerticalStack)
    }
     
    private func setupConstraints() {
        mainHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.small),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.medium),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.small),

            mainHorizontalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Spacing.medium),
            mainHorizontalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            mainHorizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Spacing.medium),
            mainHorizontalStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Spacing.medium),
             
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: Layout.Avatar.medium),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: Layout.Avatar.medium),
            rightVerticalStack.widthAnchor.constraint(equalToConstant: Layout.RepositoryCell.authorColumnWidth),
             
            forksIcon.widthAnchor.constraint(equalToConstant: Layout.Icon.small),
            forksIcon.heightAnchor.constraint(equalToConstant: Layout.Icon.small),
            starIcon.widthAnchor.constraint(equalToConstant: Layout.Icon.small),
            starIcon.heightAnchor.constraint(equalToConstant: Layout.Icon.small)
        ])
    }
}
