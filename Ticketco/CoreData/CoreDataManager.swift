//
//  CoreDataManager.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/2/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    // MARK: - Tickets
    func getAllTickets() -> [Ticket] {
        let request = CDTicket.fetchTicketsRequest()

        do {

            let results = try managedContext.fetch(request)
            return results.map { $0.ticket() }
        } catch {

            let nserror = error as NSError
            fatalError("Error getting Tickets:\n \(nserror), \(nserror.userInfo)")
        }

        return [Ticket]()
    }

    func saveTicket(_ ticket: Ticket, saveImmediately: Bool = true) {
        if let existingTicketManagedObject = getTicketManagedObject(for: ticket.ticketId) {

            existingTicketManagedObject.update(with: ticket)
        } else {

            _ = CDTicket(with: ticket, in: managedContext)
        }

        if saveImmediately { saveContext() }
    }

    func removeTicket(_ ticket: Ticket, saveImmediately: Bool = true) {
        if let existingTicketManagedObject = getTicketManagedObject(for: ticket.ticketId) {

            managedContext.delete(existingTicketManagedObject)
            if saveImmediately { saveContext() }
        }
    }

    private func getTicketManagedObject(for ticketId: String) -> CDTicket? {
        let request = CDTicket.fetchTicketsRequest()
        request.predicate = CDTicket.equalTicketIdPredicate(ticketId)

        do {

            let results = try managedContext.fetch(request)
            return results.first
        } catch {

            let nserror = error as NSError
            fatalError("Error getting Tickets:\n \(nserror), \(nserror.userInfo)")
        }

        return nil
    }

    // MARK: - Tocket Types

    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "TicketcoModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Error initializing Store:\n \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = managedContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context:\n \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
