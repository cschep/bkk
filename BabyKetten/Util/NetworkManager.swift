//
//  NetworkManager.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/26/16.
//
//

import Foundation

public class NetworkManager : NSObject {
    static let defaultSession = URLSession(configuration: .default)
    static var dataTask: URLSessionDataTask?

    @objc
    static func GET(_ url: URL, completionHandler: @escaping (Any?) -> ()) {
        if dataTask != nil {
            dataTask?.cancel()
        }

        dataTask = defaultSession.dataTask(with: url) {
            data, response, error in

            if let error = error {
                print(error.localizedDescription)
                completionHandler(nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) {

                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                    }
                } else {
                    completionHandler(nil)
                }
            }
        }

        dataTask?.resume()
    }

    @objc
    static func GET(urlString: String, completionHandler: @escaping (Any?) -> ()) {
        GET(URL(string: urlString)!, completionHandler: completionHandler)
    }
}

