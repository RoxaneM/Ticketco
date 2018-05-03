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
    @IBOutlet weak var ticketsTableHeaderView: TicketsTableHeaderView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUpdatesObservable()
        setupTableView()
    }

    private func setupTableView() {
        ticketsTableView.register(ticketTableViewCellNib,
                                 forCellReuseIdentifier: ticketTableViewCellIdentifier)
        ticketsTableView.rx.setDelegate(self).disposed(by: disposeBag)

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
        SynchronizationManager.shared.updates
            .subscribe(onNext: { [weak self] updateInfo in
                self?.ticketsTableHeaderView.update(with: updateInfo)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func reload(_ sender: Any) {
        SynchronizationManager.shared.refreshFromAPI()
    }

}

extension TicketsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ticketsTableHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ticketsTableHeaderView.frame.height
    }
}
