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

    func saveTicket(_ ticket: Ticket) {
        let ticketManagedObject = CDTicket(with: ticket, in: managedContext)
        saveContext()
    }

    func removeTicket(_ ticket: Ticket) {

    }

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

    private func saveContext () {
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
