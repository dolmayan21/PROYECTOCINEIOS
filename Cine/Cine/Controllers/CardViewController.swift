//
//  CardViewController.swift
//  Cine
//
//  Created by Alejandro Leon Del Villar on 12/27/19.
//  Copyright © 2019 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var peliPosterView: UIImageView!
    @IBOutlet weak var peliTitleLable: UILabel!
    @IBOutlet weak var peliScreeningTimeLabel: UILabel!
    @IBOutlet weak var childTicketsLabel: UILabel!
    @IBOutlet weak var adultTicketLabel: UILabel!
    @IBOutlet weak var noOrderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var peliBackgroundView: UIImageView!
    @IBOutlet weak var totalButton: UIButton!

    var orderManager = OrderManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    func updateView() {
        noOrderView.alpha = self.orderManager.peli != nil ? 0 : 1
        let tickets = orderManager.tickets
        let ticketNumbers = orderManager.getTicketSpecifiedNumbers()
        guard let peli = orderManager.peli, let peliPosterUrl = CineAppManager.shared.peliPosterFullPath(forMovie: peli, isThumbnail: true), let anyTicket = tickets.first else { return }
        peliBackgroundView.downloadImageFrom(Url: peliPosterUrl)
        peliTitleLable.text = peli.title
        peliPosterView.downloadImageFrom(Url: peliPosterUrl)
        peliScreeningTimeLabel.text = anyTicket.screeningTime?.timeStamp
        childTicketsLabel.text = "Menores: \(ticketNumbers.childNumber)"
        adultTicketLabel.text = "Adultos: \(ticketNumbers.adultNumber)"
        totalButton.setTitle("Total \(orderManager.getTotalPrice()) pesos", for: .normal)
        tableView.reloadData()
    }

    @IBAction func deleteCart() {
        self.presentUserActionRequestAlert(withMessage: "Quieres eliminar tu pedido?") { (_) in
            if let peli = OrderManager.shared.peli {
                let tickets = OrderManager.shared.tickets
                CineAppManager.shared.updateMovieAvailability(adding: tickets.count, toMovie: peli)
            }
            OrderManager.shared.purgeOrder()
            self.updateView()
        }
    }

    @IBAction func buy() {
        self.presentUserActionRequestAlert(withMessage: "Costo total " + "\(orderManager.getTotalPrice()) pesos") { (_) in
            OrderManager.shared.purgeOrder()
            self.updateView()
            self.presentDefaultAlert(withMessage: "PRESENTA EL SIGUIENTE CODIGO EN TU CINE: " + OrderManager.shared.generateAnID())
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodItem = orderManager.getUniqueFoodItems()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "comidaCardCell") as? ComidaCardCell else {
            return UITableViewCell()
        }
        cell.update(with: foodItem, andCuantity: orderManager.getNumberOfSameFoodItemOfKind(kind: foodItem.name ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let foodArray = orderManager.getUniqueFoodItems()
        return foodArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
