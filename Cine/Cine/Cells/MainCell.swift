//
//  MainCell.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit


class MainCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func update(with peli: PeliculaModel) {
        titleLabel.text = peli.title
        guard let imageUrl = CineAppManager.shared.peliPosterFullPath(forMovie: peli, isThumbnail: true) else {  return }
        thumbnailView.downloadImageFrom(Url: imageUrl)
    }
}
