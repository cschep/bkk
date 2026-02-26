import UIKit

class KamikazeViewController: UIViewController, CAAnimationDelegate {
    private let kamikazeImage = UIImageView(image: UIImage(named: "kamikaze_ketten_background"))
    private var running = false

    override func viewDidLoad() {
        super.viewDidLoad()

        kamikazeImage.contentMode = .scaleAspectFill
        kamikazeImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(kamikazeImage)

        NSLayoutConstraint.activate([
            kamikazeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kamikazeImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            kamikazeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            kamikazeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake && !running {
            kamikazeKetten()
        }
    }

    private func kamikazeKetten() {
        running = true

        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.5
        scale.toValue = 3.0
        scale.duration = 1.0
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotate.values = [0.0, 2.0 * Double.pi, 0.0]
        rotate.duration = 1.0
        rotate.isRemovedOnCompletion = false
        rotate.fillMode = .forwards
        rotate.timingFunctions = [
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut),
        ]

        let alphaDown = CABasicAnimation(keyPath: "opacity")
        alphaDown.fromValue = 1.0
        alphaDown.toValue = 0.0
        alphaDown.duration = 1.0
        alphaDown.delegate = self
        alphaDown.isRemovedOnCompletion = false
        alphaDown.fillMode = .forwards
        alphaDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        kamikazeImage.layer.add(scale, forKey: "move forward by scaling")
        kamikazeImage.layer.add(rotate, forKey: "rotate back and forth")
        kamikazeImage.layer.add(alphaDown, forKey: "alpha fade out")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        navigationController?.view.alpha = 0.0
        navigationController?.navigationBar.isHidden = false

        let songList = SongListTableViewController()
        songList.setupRandom()
        navigationController?.pushViewController(songList, animated: false)

        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseInOut) {
            self.navigationController?.view.alpha = 1.0
        } completion: { _ in
            self.kamikazeImage.layer.removeAllAnimations()
            self.running = false
        }
    }
}
