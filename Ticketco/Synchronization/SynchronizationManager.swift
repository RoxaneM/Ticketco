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

    private let updatesSubject = BehaviorSubject(value: UpdateInfo())
    private let disposeBag = DisposeBag()

    // MARK: - Public
    static let shared = SynchronizationManager()
    let activeTickets = Variable([Ticket]())

    var updates: Observable<UpdateInfo> {
        return updatesSubject.asObservable()
    }

    init() {
        updatesSubject.onNext(getLastUpdateInfo())
        activeTickets.value = loadTicketsFromCoreData()
    }

    func refreshFromAPI(completion: (() -> Void)? = nil) {
        _ = Observable.combineLatest(
            TicketcoServerManager.shared.getTickets().asObservable(),
            TicketcoServerManager.shared.getTicketTypes().asObservable())

            .catchErrorJustReturn(([Ticket](), [TicketType]()))
            .subscribe(onNext: { [weak self] (tickets, types) in
                self?.runUpdates(with: tickets, types)
                completion?()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private func runUpdates(with tickets: [Ticket], _ types: [TicketType]) {
        var updateInfo = UpdateInfo()
        var displayTickets = [Ticket]()

        for ticket in tickets {

            if let type = CoreDataManager.shared.getTicketType(for: ticket.typeId) {
                ticket.type = type
            } else {
                for type in types where type.typeId == ticket.typeId {
                    ticket.type = type
                    break
                }
            }

            switch ticket.operation {
            case .add:

                updateInfo.added += 1
                displayTickets.append(ticket)
            case .update:

                updateInfo.updated += 1
                displayTickets.append(ticket)
            case .remove:

                updateInfo.removed += 1
            case .unknown:

                print("⚠️Warning: no ticket should have unknown operation type!")
            }
        }

        saveTicketsToCoreData(tickets)
        activeTickets.value = displayTickets

        updateInfo.updateDate = Date()
        updatesSubject.onNext(updateInfo)
        saveUpdateInfo(info: updateInfo)
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

    // MARK: Core Data
    private func loadTicketsFromCoreData() -> [Ticket] {
        return CoreDataManager.shared.getAllTickets()
    }

    private func saveTicketsToCoreData(_ tickets: [Ticket]) {
        CoreDataManager.shared.updateAllTickets(tickets)
    }
}
// MARK: - Update Info
//------------------------------------------------------------------------------
struct UpdateInfo {
    var added: Int = 0
    var updated: Int = 0
    var removed: Int = 0

    var updateDate: Date?

    init() { }

    // MARK: NSCoding compliable
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
