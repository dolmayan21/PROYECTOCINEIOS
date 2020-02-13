//
//  PeliculaCollectionViewCell.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class PeliculaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagenPelicula: UIImageView!

    func update(with peli: PeliculaModel) {
        guard let imageUrl = CineAppManager.shared.peliPosterFullPath(forMovie: peli, isThumbnail: false) else {
            // default image
            return
        }
        imagenPelicula.downloadImageFrom(Url: imageUrl)
    }
}

enum CineImageSizes: String {
    case thumbnail = "w200"
    case detail = "w500"
}


