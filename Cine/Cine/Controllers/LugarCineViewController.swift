//
//  CinesViewController.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class LugarCineViewController: UIViewController {

    @IBOutlet weak var imagePlace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePlace.image = UIImage(named: "mapa")
        // Do any additional setup after loading the view.
    }

}
