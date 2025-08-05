import UIKit
import Kingfisher

final class PullRequestCell: UITableViewCell {

    static let reuseID = "PullRequestCell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let authorAvatarImageView = UIImageView()
    private let authorNameLabel = UILabel()
    
    private let mainStack = UIStackView()
    private let authorStack = UIStackView()

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
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 3
        bodyLabel.lineBreakMode = .byTruncatingTail

        authorAvatarImageView.contentMode = .scaleAspectFill
        authorAvatarImageView.layer.cornerRadius = 15
        authorAvatarImageView.clipsToBounds = true
        
        authorNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        authorNameLabel.textColor = .label
        
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        authorStack.axis = .horizontal
        authorStack.spacing = 8
        authorStack.alignment = .center
    }
    
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
        
        authorStack.addArrangedSubview(authorAvatarImageView)
        authorStack.addArrangedSubview(authorNameLabel)
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(bodyLabel)
        mainStack.addArrangedSubview(authorStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: 30),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    public func configure(with pr: PullRequest) {
        titleLabel.text = pr.title
        bodyLabel.text = pr.body ?? "Sem descrição."
        authorNameLabel.text = pr.user.login
        
        if let avatarURL = URL(string: pr.user.avatarUrl) {
            authorAvatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(systemName: "person.circle.fill"))
        }
    }
}
