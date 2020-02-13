//
//  ComidaCardCell.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class ComidaCardCell: UITableViewCell {
    @IBOutlet weak var foodIconView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var cuantityTF: UITextField!

    func update(with foodItem: ComidaModel, andCuantity cuantity: Int) {
        foodNameLabel.text = foodItem.name
        cuantityTF.text = String(cuantity)
        guard let foodImageURL = foodItem.image else { return }
        foodIconView.downloadImageFrom(Url: foodImageURL)
    }
}

