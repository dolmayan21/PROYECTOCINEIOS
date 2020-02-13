//
//  BoletosViewController.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

enum BoletosViewCells: Int {
    case title = 0, description, ticketInfo
}

struct BoletosViewCellsIdentifiers {
    static var title = "titleCell"
    static var description = "descCell"
    static var ticketInfo = "infoCell"
}

class BoletosViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var remainingTickets: UILabel!
    var peli: PeliculaModel?
    var tickets: [MovieTicket] = []
    @IBOutlet weak var peliBackgroundView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = "0.0"
        tableView.dataSource = self
        tableView.delegate = self
        remainingTickets.text = "Boletos aun disponibles: \(peli?.remainingSeats ?? 0)"
        configureBackground()
    }

    func configureBackground() {
        guard let peli = peli, let urlString = CineAppManager.shared.peliPosterFullPath(forMovie: peli, isThumbnail: false) else { return }
        peliBackgroundView.downloadImageFrom(Url: urlString)
        peliBackgroundView.contentMode = .scaleAspectFill
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCart(_ sender: UIButton) {
        guard let peli = peli else {
            self.presentDefaultAlert(withMessage: "Tenemos problemas")
            return
        }
        guard tickets.count > 0 else {
            self.presentDefaultAlert(withMessage: "Selecciona tu boleto para continuar")
            return
        }
        guard tickets.count < peli.remainingSeats ?? 0 else {
            self.presentDefaultAlert(withMessage: "Boletos agotados")
            return
        }
        let orderAlreadyInProgressMessage = OrderManager.shared.tickets.count > 0 ? "Ya tienes una compra anterior, puedes perder lo que ya tenias.": ""
        let message = orderAlreadyInProgressMessage + "Quieres agregar los boletos a tu carrito de compra?"
        self.presentUserActionRequestAlert(withMessage: message ) { [weak self] (_) in
            self?.overrideCurrentCartIfNecessary()
            OrderManager.shared.tickets = self?.tickets ?? []
            OrderManager.shared.peli = peli
            CineAppManager.shared.updateMovieAvailability(adding: -(self?.tickets.count ?? 0), toMovie: peli)
            self?.dismiss(animated: true, completion: nil)
        }
    }

    func overrideCurrentCartIfNecessary() {
        guard OrderManager.shared.tickets.count > 0, let peli = OrderManager.shared.peli else { return }
        CineAppManager.shared.updateMovieAvailability(adding: OrderManager.shared.tickets.count, toMovie: peli)
    }


}

extension BoletosViewController: BoletoCellProtocol, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = BoletosViewCells(rawValue: indexPath.row) else { return 0 }

        switch cellType {
        case .title:
           return 248
        case .description:
            guard let peliDescription = peli?.overview else { return 0 }
            let height = DesCell.heightForCell(withString: peliDescription, withWidth: self.view.frame.width)
            return height
        case .ticketInfo:
            return 360
        }
    }
    func ticketView(ticketsAvailable: [MovieTicket]) {
        self.tickets = ticketsAvailable
        var total: Float = 0.0
        for ticket in tickets {
            let isForChild = ticket.isForChild ?? false
            total += isForChild ? 60.0 : 70.0
        }
        totalLabel.text = "\(total)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = BoletosViewCells(rawValue: indexPath.row) ?? .title
        var cell: UITableViewCell?
        guard let peli = peli else {
            return UITableViewCell()
        }

        switch cellType {
        case .title:
            cell = tableView.dequeueReusableCell(withIdentifier: BoletosViewCellsIdentifiers.title)
            (cell as? MainCell)?.update(with: peli)
        case .description:
            cell = tableView.dequeueReusableCell(withIdentifier: BoletosViewCellsIdentifiers.description)
            (cell as? DesCell)?.update(with: peli)
        case .ticketInfo:
            cell = tableView.dequeueReusableCell(withIdentifier: BoletosViewCellsIdentifiers.ticketInfo)
            (cell as? BoletoCell)?.update(with: peli)
            (cell as? BoletoCell)?.delegate = self
        }

        return cell ?? UITableViewCell()
    }
}



