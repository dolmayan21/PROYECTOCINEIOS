//
//  PeliculaScreeningTime.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import Foundation

struct PeliculaScreeningTime: Codable {

    var hour: Int = 0
    var minute: Int = 0

    // This assign a numerical value basing off the timing to later sort it with this value
    var sortValue: Float {
        return (Float(hour) + 1) * 1000 + Float(minute)
    }

    var timeStamp: String {
        let hourString = hour < 10 ? "0\(hour)": "\(hour)"
        let minuteString = minute < 10 ? "0\(minute)": "\(minute)"
        return hourString + ":" + minuteString
    }

    static func random() -> PeliculaScreeningTime {
        let screening = PeliculaScreeningTime(hour: Int.random(in: 0...23), minute:Int.random(in: 0...59))
        return screening
    }

    static func getPeliculaScreeningTime(_ numberOfScreenings: Int)-> [PeliculaScreeningTime] {
        var screenings: [PeliculaScreeningTime] = []
        for _ in 0..<numberOfScreenings {
            screenings.append(PeliculaScreeningTime.random())
        }
        return screenings.sorted {
            $0.sortValue < $1.sortValue
        }
    }
}
