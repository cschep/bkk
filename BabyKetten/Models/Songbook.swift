//
//  Songbook.swift
//  baby ketten
//
//  Created by Christopher Schepman on 11/27/22.
//

import Foundation

class Songbook {
    public static let current = Songbook()

    private let version = "now"
    private let urlComponents = URLComponents(string: "http://rocky.local:3000/users/1/songbooks/latest")
    private init() {}

    func checkForUpdate() {

    }
}
