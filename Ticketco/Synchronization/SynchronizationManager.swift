//
//  SynchronizationManager.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/3/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import Foundation
import RxSwift

class SynchronizationManager {
    private static let lastUpdateKey = "SynchronizationManagerLastUpdate"

    static let shared = SynchronizationManager()

    let activeTickets = Variable([Ticket]())

    var updates: Observable<UpdateInfo> {
        return updatesSubject.asObservable()
    }

    private let updatesSubject = BehaviorSubject(value: UpdateInfo())
    private let disposeBag = DisposeBag()

    init() {
        updatesSubject.onNext(getLastUpdateInfo())
        activeTickets.value = loadTicketsFromCoreData()
    }

    func refreshFromAPI() {
        TicketcoServerManager.shared.getTickets().asObservable()
            .catchErrorJustReturn([Ticket]())
            .subscribe(onNext: { [weak self] tickets in
                self?.runUpdates(with: tickets)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private func loadTicketsFromCoreData() -> [Ticket] {
        return CoreDataManager.shared.getAllTickets()
    }

    private func getLastUpdateInfo() -> UpdateInfo {
        if let infoDict = UserDefaults.standard.value(forKey: SynchronizationManager.lastUpdateKey) as? [String: Any] {
            return UpdateInfo(from: infoDict)
        }
        return UpdateInfo()
    }

    private func saveUpdateInfo(info: UpdateInfo) {
        UserDefaults.standard.set(info.dictionary(), forKey: SynchronizationManager.lastUpdateKey)
    }

    private func runUpdates(with tickets: [Ticket]) {
        var updateInfo = UpdateInfo()
        var displayTickets = [Ticket]()

        for ticket in tickets {

            switch ticket.operation {
            case .add:

                updateInfo.added += 1
                //CoreDataManager.shared.saveTicket(ticket, saveImmediately: false)
                displayTickets.append(ticket)
            case .update:

                updateInfo.updated += 1
                //CoreDataManager.shared.saveTicket(ticket, saveImmediately: false)
                displayTickets.append(ticket)
            case .remove:

                updateInfo.removed += 1
                //CoreDataManager.shared.removeTicket(ticket, saveImmediately: false)
            case .unknown:

                print("⚠️Warning: no ticket should have unknown operation type!")
            }
        }

        CoreDataManager.shared.saveContext()
        activeTickets.value = displayTickets

        updateInfo.updateDate = Date()
        updatesSubject.onNext(updateInfo)
        saveUpdateInfo(info: updateInfo)
    }
}

struct UpdateInfo {
    var added: Int = 0
    var updated: Int = 0
    var removed: Int = 0

    var updateDate: Date?

    init() { }

    // MARK: - NSCoding compliable
    //------------------------------------------------------------------------------
    static let addedKey = "added"
    static let updatedKey = "updated"
    static let removedKey = "removed"
    static let updateDateKey = "updateDate"

    func dictionary() -> [String: Any] {
        var dictionary = [String: Any]()

        dictionary.updateValue(added, forKey: UpdateInfo.addedKey)
        dictionary.updateValue(updated, forKey: UpdateInfo.updatedKey)
        dictionary.updateValue(removed, forKey: UpdateInfo.removedKey)

        if let date = updateDate {
            dictionary.updateValue(date, forKey: UpdateInfo.updateDateKey)
        }

        return dictionary
    }

    init(from dictionary: [String: Any]) {

        added = dictionary[UpdateInfo.addedKey] as? Int ?? 0
        updated = dictionary[UpdateInfo.updatedKey] as? Int ?? 0
        removed = dictionary[UpdateInfo.removedKey] as? Int ?? 0
        updateDate = dictionary[UpdateInfo.updateDateKey] as? Date
    }
}
