//
//  BoletoCell.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

protocol BoletoCellProtocol {
    func ticketView(ticketsAvailable: [MovieTicket])
}

class BoletoCell: UITableViewCell {
    @IBOutlet weak var picketHour: UIPickerView!
    @IBOutlet weak var ticketAdultTextField: UITextField!
    @IBOutlet weak var ticketChildTextField: UITextField!
    @IBOutlet weak var selectedMovieHour: UILabel!
    var totalA = 0.0 , totalC = 0.0

    var ticket = MovieTicket()
    var delegate: BoletoCellProtocol?

    var purchasedAdultTickets: [MovieTicket] = []
    var purchasedChildTickets: [MovieTicket] = []

    func add(adultTickets: Int){
        purchasedAdultTickets = []
        for _ in 0..<adultTickets {
            let ticket = self.ticket.createNewTicketFromCurrentData()
            ticket.isForChild = false
            purchasedAdultTickets.append(ticket)
        }
    }

    func add(childTickets: Int){
        purchasedChildTickets = []
        for _ in 0..<childTickets {
            let ticket = self.ticket.createNewTicketFromCurrentData()
            ticket.isForChild = true
            purchasedChildTickets.append(ticket)
        }
    }

    func update(with peli: PeliculaModel) {
        ticket.peli = peli
        picketHour.delegate = self
        picketHour.dataSource = self
        autoSelectTime()

    }
}

extension BoletoCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let peli = ticket.peli, let peliCount = peli.screeningTimes?.count else {
            return 0
        }
        return peliCount
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let peli = ticket.peli else {
            return
        }
        ticket.screeningTime = peli.screeningTimes?[row]
        selectedMovieHour.text = ticket.screeningTime?.timeStamp ?? ""
    }

    func autoSelectTime() {
        guard let peli = ticket.peli, (peli.screeningTimes?.count ?? 0) > 0 else { return }
        pickerView(picketHour, didSelectRow: 0, inComponent: 0)
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let peli = ticket.peli, let screening = peli.screeningTimes?[row] else {
            return NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }

        return NSAttributedString(string: screening.timeStamp, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }



    @IBAction func stepperAdult(_ sender: UIStepper) {
        ticketAdultTextField.text = Int(sender.value).description
        add(adultTickets: Int(sender.value))
        delegate?.ticketView(ticketsAvailable: purchasedChildTickets + purchasedAdultTickets)
    }
    @IBAction func stepperChild(_ sender: UIStepper) {
        ticketChildTextField.text = Int(sender.value).description
        add(childTickets: Int(sender.value))
        delegate?.ticketView(ticketsAvailable: purchasedChildTickets + purchasedAdultTickets)
    }
}

