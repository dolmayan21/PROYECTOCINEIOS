//
//  ComidaCollectionViewCell.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class ComidaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageFood : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func update(with foodItem: ComidaModel) {
        guard let foodURL = foodItem.image else { return }
        imageFood.downloadImageFrom(Url: foodURL)
        imageFood.contentMode = .scaleAspectFill
        nameLabel.text = foodItem.name
        priceLabel.text = foodItem.price
    }
}
