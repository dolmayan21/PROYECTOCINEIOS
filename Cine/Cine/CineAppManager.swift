//
//  CineAppManager.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import Foundation

enum CineAppService: Int {
    case pelis = 0, food
}

class CineAppManager {

    static let shared = CineAppManager()
    

    

    private let key = "5aa9f9d04ab72a31b70f56ef9db4b81e"
    private let lang = "en-US"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let gistBaseUrl = "https://gist.githubusercontent.com/dolmayan21/"
    private let imageBaseUrl = "https://image.tmdb.org/t/p/"

    var pelis: [PeliculaModel] = []
    var foodMenu: FoodServiceResponseModel?

    lazy var jsonDecoder = JSONDecoder()

    func updateIsNecessary(forService service: CineAppService) -> Bool {
        switch service {
        case .pelis:
            return !(pelis.count > 0)
        case .food:
            return (foodMenu == nil)
        }
    }

    func updateMovieAvailability(adding availability: Int, toMovie peli: PeliculaModel){
        for currentMovieIndex in 0..<pelis.count {
            if pelis[currentMovieIndex].title == peli.title {
                let updatedMovie = peli.clone(addingAvailability: availability)
                pelis[currentMovieIndex] = updatedMovie
                break
            }
        }
    }


    func updateFoodMenu(_ completion: @escaping (Bool)->()) {
        let endpoint = "148e06518fc1405974ef3054c710eb03/raw/f31560c6797b8e6050c9c51c370b5174b23ce446/menu.json"
        guard let url = URL(string: gistBaseUrl + endpoint), updateIsNecessary(forService: .food) else {
            completion(false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(false)
                return
            }
            guard let data = data, let foodData = try? self.jsonDecoder.decode(FoodServiceResponseModel.self, from: data) else {
                // parsing error handling
                completion(false)
                return
            }
            self.foodMenu = foodData
            completion(true)
        }
        task.resume()
    }

    func updateMovies(_ completion: @escaping (Bool)->()) {
        let endpoint = "/movie/popular?"
        let params = "api_key=\(self.key)&language=\(self.lang)"
        guard let url = URL(string: baseUrl + endpoint + params), updateIsNecessary(forService: .pelis) else {
            // url couldnot be constructed or update is not necessary error handling
            completion(false)
            return
        }
        // Con esto parceamos el json
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard error == nil else {
                // server error handling
                completion(false)
                return
            }
            guard let data = data, let pelisData = try? self.jsonDecoder.decode(MovieServiceResultModel.self, from: data) else {
                // parsing error handling
                completion(false)
                return
            }
            self.pelis = pelisData.results
            self.addTestingScreeningTimes(enabled: true)
            completion(true)
        }
        task.resume()
    }

    func addTestingScreeningTimes(enabled: Bool) {
        if enabled {
            var mockMovies: [PeliculaModel] = []
            for peli in self.pelis {
                let mockMovie = peli.clone(addingTestScreeningTimes: PeliculaScreeningTime.getPeliculaScreeningTime(Int.random(in: 3...10)))
                mockMovies.append(mockMovie)
            }
            self.pelis = mockMovies
        }
    }

    func peliPosterFullPath(forMovie peli: PeliculaModel, isThumbnail: Bool) -> String?  {
        guard let posterPath = peli.poster_path else { return nil }
        let size: CineImageSizes = isThumbnail ? .thumbnail : .detail
        return imageBaseUrl + size.rawValue + posterPath
    }

}
