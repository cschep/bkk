//
//  SubtitleTableViewCell.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/10/22.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
