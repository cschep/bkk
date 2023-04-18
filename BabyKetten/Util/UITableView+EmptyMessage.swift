//
//  UITableView+EmptyMessage.swift
//  baby ketten
//
//  Created by Christopher Schepman on 4/12/23.
//

// purloined from: https://stackoverflow.com/questions/15746745/handling-an-empty-uitableview-print-a-friendly-message
// specifically this is for BKK obviously but -- might be copy and pastable ya know?
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let bgView = UIView(frame: .init(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))

        let imageView = UIImageView(image: UIImage(named: "ketten_small_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(imageView)

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 32)
        messageLabel.sizeToFit()

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(messageLabel)

        self.backgroundView = bgView

        let constraints = [
            imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        self.separatorStyle = .none
    }

    // with message?
    func setLoading() {
        let bgView = UIView(frame: .init(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))

        let imageView = UIImageView(image: UIImage(named: "ketten_small_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(imageView)

        self.backgroundView = bgView
        let constraints = [
            imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        imageView.layer.add(rotation, forKey: "rotationAnimation")

        self.separatorStyle = .none
    }

    func restore() {
        self.separatorStyle = .singleLine
        UIView.animate(withDuration: 0.3) {
            self.backgroundView?.alpha = 0
        }
    }
}
