//
//  SpinnerViewController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 4/19/23.
//

import UIKit

//TODO: does this need to be a VC or just a view? this is tiny for barbuttons right now?
class SpinnerViewController: UIViewController {
    var spinningKetten = UIImageView(image: UIImage(named: "ketten_small_white"))

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.isRemovedOnCompletion = false
        spinningKetten.layer.add(rotation, forKey: "rotationAnimation")

        spinningKetten.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinningKetten)

        NSLayoutConstraint.activate([
            spinningKetten.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinningKetten.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinningKetten.widthAnchor.constraint(equalToConstant: 25),
            spinningKetten.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
