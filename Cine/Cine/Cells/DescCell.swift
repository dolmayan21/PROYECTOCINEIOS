//
//  DesCell.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class DesCell: UITableViewCell {
    @IBOutlet weak var descriptionTag: UILabel!

    static func heightForCell(withString string: String, withWidth width: CGFloat) -> CGFloat {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width - 40, height: 500))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = string
        label.font = UIFont(name: "System", size: 17)
        view.addSubview(label)
        label.numberOfLines = 0
        label.sizeToFit()
        return label.frame.height + 50
    }

    func update(with peli: PeliculaModel) {
        descriptionTag.text = peli.overview
    }
}
