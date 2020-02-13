//
//  UIImage+extension.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(Url urlString:String) {
        self.alpha = 0
        guard let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: url) { (data, urlResponse, responseError) in
            guard let imageData = data, responseError == nil else  { return }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = 1
                    self.image = UIImage(data: imageData)
                })
            }
            }.resume()
    }
}
