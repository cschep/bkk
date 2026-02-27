//
//  NetworkManager.swift
//  Baby Ketten
//
//  Created by Christopher Schepman on 11/26/16.
//
//

import Foundation

class NetworkManager {
    static func GET(_ url: URL) async -> Any? {
        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        return json
    }
}
