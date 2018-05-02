//
//  ViewController.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TicketsViewController: BaseViewController {

    @IBOutlet weak var ticketsTableView: UITableView!

    private let tickets = Variable([Ticket]())

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadData()
    }

    private func loadData() {
        TicketcoServerManager.shared.getTickets()
            .catchErrorJustReturn([Ticket]())
            .bind(to: tickets)
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        ticketsTableView.register(ticketTableViewCellNib,
                                 forCellReuseIdentifier: ticketTableViewCellIdentifier)

        tickets.asObservable()
            .map { $0 }
            .catchErrorJustReturn ([Ticket]())
            .bind(to: ticketsTableView.rx.items) { (tableView: UITableView, index: Int, ticket: Ticket) in
                //swiftlint:disable force_cast line_length
                let cell: TicketTableViewCell = tableView.dequeueReusableCell(withIdentifier: ticketTableViewCellIdentifier, for: IndexPath(row: index, section: 0)) as! TicketTableViewCell
                cell.update(with: ticket)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func load(_ sender: Any) {
        print("All tickets from CD")

        let array = CoreDataManager.shared.getAllTickets()
        for ticket in array {
            print(ticket)
        }
    }

    @IBAction func save(_ sender: Any) {
        let ticket = Ticket()
        ticket.ticketId = "2"
        ticket.firstName = "NewName"

        CoreDataManager.shared.saveTicket(ticket)
    }

}
