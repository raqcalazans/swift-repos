import UIKit
import Kingfisher

final class RepositoryCell: UITableViewCell {

    static let reuseID = "RepositoryCell"

    private let containerView = UIView()
    
    private let repoNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let forksIcon = UIImageView(image: UIImage(systemName: "tuningfork"))
    private let forkCountLabel = UILabel()
    
    private let starIcon = UIImageView(image: UIImage(systemName: "star.fill"))
    private let starCountLabel = UILabel()

    private let authorAvatarImageView = UIImageView()
    private let authorNameLabel = UILabel()

    private let mainHorizontalStack = UIStackView()
    private let leftVerticalStack = UIStackView()
    private let rightVerticalStack = UIStackView()
    private let statsHorizontalStack = UIStackView()
    private let forksStack = UIStackView()
    private let starsStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.layer.borderWidth = 1
        containerView.translatesAutoresizingMaskIntoConstraints = false

        repoNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        repoNameLabel.textColor = .label
        
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping

        forksIcon.tintColor = .secondaryLabel
        forksIcon.contentMode = .scaleAspectFit
        forkCountLabel.font = .systemFont(ofSize: 14)
        forkCountLabel.textColor = .secondaryLabel
        
        starIcon.tintColor = .systemYellow
        starIcon.contentMode = .scaleAspectFit
        starCountLabel.font = .systemFont(ofSize: 14)
        starCountLabel.textColor = .secondaryLabel

        authorAvatarImageView.contentMode = .scaleAspectFill
        authorAvatarImageView.layer.cornerRadius = 25
        authorAvatarImageView.clipsToBounds = true
        
        authorNameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        authorNameLabel.textColor = .secondaryLabel
        authorNameLabel.textAlignment = .center
        authorNameLabel.numberOfLines = 0
        authorNameLabel.lineBreakMode = .byWordWrapping

        configureStack(mainHorizontalStack, axis: .horizontal, spacing: 16, alignment: .center)
        configureStack(leftVerticalStack, axis: .vertical, spacing: 8)
        configureStack(rightVerticalStack, axis: .vertical, spacing: 4, alignment: .center)
        configureStack(statsHorizontalStack, axis: .horizontal, spacing: 16)
        configureStack(forksStack, axis: .horizontal, spacing: 4, alignment: .center)
        configureStack(starsStack, axis: .horizontal, spacing: 4, alignment: .center)
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
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            mainHorizontalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainHorizontalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainHorizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainHorizontalStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: 50),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: 50),
            rightVerticalStack.widthAnchor.constraint(equalToConstant: 60),
            
            forksIcon.widthAnchor.constraint(equalToConstant: 16),
            forksIcon.heightAnchor.constraint(equalToConstant: 16),
            starIcon.widthAnchor.constraint(equalToConstant: 16),
            starIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    public func configure(with repository: Repository) {
        repoNameLabel.text = repository.name
        descriptionLabel.text = repository.description ?? ""
        authorNameLabel.text = repository.owner.login
        starCountLabel.text = "\(repository.stargazersCount)"
        forkCountLabel.text = "\(repository.forksCount)"
        
        if let avatarURL = URL(string: repository.owner.avatarUrl) {
            authorAvatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(systemName: "person.circle.fill"))
        }
    }
}
