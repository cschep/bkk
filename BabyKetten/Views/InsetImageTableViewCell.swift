//
//  InsetImageTableViewCell.swift
//  baby ketten
//
//  Created by Christopher Schepman on 4/12/23.
//

import UIKit

class InsetImageTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        imageView?.contentMode = .scaleAspectFit
        separatorInset = UIEdgeInsets.zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let iv = imageView, let lbl = textLabel else { return }
        iv.frame = CGRect(5, 10, iv.frame.width - 5, iv.frame.height - 20)
        lbl.frame = CGRect(x: iv.frame.width + 5, y: 0, width: lbl.frame.width, height: lbl.frame.height)
    }
}
