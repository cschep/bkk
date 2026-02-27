import UIKit

class YTTableViewCell: UITableViewCell {
    let myImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        myImageView.contentMode = .scaleAspectFill
        myImageView.clipsToBounds = true
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(myImageView)

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 60),
            myImageView.heightAnchor.constraint(equalToConstant: 58),

            titleLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
