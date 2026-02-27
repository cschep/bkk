//
//  UIImage+URL.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/27/16.
//
//

import UIKit

extension UIImageView {
    func setImage(from url: URL, placeholder: UIImage) {
        image = placeholder

        Task {
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let downloaded = UIImage(data: data) else { return }
            self.image = downloaded
        }
    }
}
