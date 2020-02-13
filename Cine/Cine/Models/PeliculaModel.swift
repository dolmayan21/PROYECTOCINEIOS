//
//  PeliculaModel.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import Foundation

struct PeliculaModel: Codable {
    var poster_path: String?
    var adult: Bool!
    var overview: String!
    var release_date: String!
    var id: Int!
    var original_title: String!
    var title: String!
    var remainingSeats: Int? = 0
    var screeningTimes: [PeliculaScreeningTime]? = []

    func clone(addingTestScreeningTimes screeningTimes: [PeliculaScreeningTime]) -> PeliculaModel {
        let peli = PeliculaModel(poster_path: poster_path, adult: adult, overview: overview, release_date: release_date, id: id, original_title: original_title, title: title,remainingSeats: Int.random(in: 0...60), screeningTimes: screeningTimes)
        return peli
    }

    func clone(addingAvailability availability: Int) -> PeliculaModel {
        let remainingSeats = self.remainingSeats ?? 0
        let peli = PeliculaModel(poster_path: poster_path, adult: adult, overview: overview, release_date: release_date, id: id, original_title: original_title, title: title,remainingSeats: remainingSeats + availability, screeningTimes: screeningTimes)
        return peli
    }

}

struct Dates: Codable {
    var maximum: String!
    var minimum: String!
}

struct MovieServiceResultModel: Codable {
    var page: Int!
    var results: [PeliculaModel]!
    var dates: Dates?
    var total_pages: Int!
    var total_results: Int!
}



