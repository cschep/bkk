//
//  UIImage+URL.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/27/16.
//
//

import Foundation

extension UIImageView {
    func setImage(withURLRequest request: URLRequest, placeholderImage: UIImage, success: @escaping (URLRequest, URLResponse, UIImage) -> ()) {
        image = placeholderImage

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    success(request, response!, UIImage(data: data)!)
                }
            }
        }.resume()
    }
}
