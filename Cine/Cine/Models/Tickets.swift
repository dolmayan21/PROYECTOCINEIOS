//
//  Tickets.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import Foundation

class MovieTicket {
    var isForChild: Bool?
    var peli: PeliculaModel?
    var screeningTime: PeliculaScreeningTime?
    var seat: String?
    var location: Location?

    init() {}

    func createNewTicketFromCurrentData() -> MovieTicket {
        let ticket = MovieTicket()
        ticket.isForChild = isForChild
        ticket.peli = peli
        ticket.screeningTime = screeningTime
        ticket.seat = seat
        ticket.location = location
        return ticket
    }
}

struct Location {
    var lat: String?
    var lon: String?
}



