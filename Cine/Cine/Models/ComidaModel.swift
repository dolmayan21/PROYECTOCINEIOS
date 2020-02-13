//
//  File.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import Foundation

struct ComidaModel: Codable {
    var name: String?
    var description: String?
    var price: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "description"
        case price = "price"
        case image = "image"
    }
}

struct FoodServiceResponseModel: Codable {
    var name: String?
    var description: String?
    var foodItems: [ComidaModel]? = []

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "Description"
        case foodItems = "food_items"
    }
}


