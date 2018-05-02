//
//  SynchronizationManager.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/3/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import Foundation
import RxSwift

struct UpdateInfo {
    var added: Int = 0
    var updated: Int = 0
    var removed: Int = 0

    mutating func reset() {
        added = 0
        updated = 0
        removed = 0
    }
}

class SynchronizationManager {
    private static let lastUpdateKey = "SynchronizationManagerLastUpdate"
    private let disposeBag = DisposeBag()

    // MARK: - Public
    //------------------------------------------------------------------------------
    static let shared = SynchronizationManager()
    var updateInfo = UpdateInfo()

    func refreshFromAPI() {

        TicketcoServerManager.shared.getTickets().asObservable()
            .catchErrorJustReturn([Ticket]())
            .subscribe(onNext: { [weak self] tickets in
                self?.runUpdates(with: tickets)
            })
            .disposed(by: disposeBag)
    }

    func loadFromCoreData() -> [Ticket] {
        return CoreDataManager.shared.getAllTickets()
    }

    func getLastUpdateDate() -> Date? {
        if let date = UserDefaults.standard.value(forKey: SynchronizationManager.lastUpdateKey) as? Date {
            return date
        }
        return nil
    }

    // MARK: - Private
    private func setLastUpdateDate() {
        UserDefaults.standard.set(Date(), forKey: SynchronizationManager.lastUpdateKey)
    }

    private func runUpdates(with newTickets: [Ticket]) {
        updateInfo.reset()

        for ticket in newTickets {

            switch ticket.operation {
            case .add:
                updateInfo.added += 1
                CoreDataManager.shared.saveTicket(ticket, saveImmediately: false)
            case .update:
                updateInfo.updated += 1
                CoreDataManager.shared.saveTicket(ticket, saveImmediately: false)
            case .remove:
                updateInfo.removed += 1
                CoreDataManager.shared.removeTicket(ticket, saveImmediately: false)
            case .unknown:
                print("⚠️Warning: no ticket should have unknown operation type!")
            }
        }

        CoreDataManager.shared.saveContext()
        setLastUpdateDate()
    }
}
