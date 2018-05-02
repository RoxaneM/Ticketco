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

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUpdatesObservable()
        setupTableView()
    }

    private func setupTableView() {
        ticketsTableView.register(ticketTableViewCellNib,
                                 forCellReuseIdentifier: ticketTableViewCellIdentifier)

        SynchronizationManager.shared.activeTickets.asObservable()
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

    private func setupUpdatesObservable() {
        SynchronizationManager.shared.updateInfo.updateDate.asObservable()
            .subscribe(onNext: { date in
                print(date ?? "noDate")
            })
            .disposed(by: disposeBag)
    }

    @IBAction func reload(_ sender: Any) {
        SynchronizationManager.shared.refreshFromAPI()
    }

}
