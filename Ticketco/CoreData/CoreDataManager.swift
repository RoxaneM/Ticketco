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
        request.relationshipKeyPathsForPrefetching = ["type"]

        do {

            let results = try defaultContext.fetch(request)
            return results.map { $0.ticket() }
        } catch {

            let nserror = error as NSError
            fatalError("Error getting Tickets:\n \(nserror), \(nserror.userInfo)")
        }

        return [Ticket]()
    }

    func updateAllTickets(_ tickets: [Ticket], onBackground: Bool = true) {
        let context = onBackground ? privateContext : defaultContext

        context.perform { [weak self] in
            for ticket in tickets {
                switch ticket.operation {

                case .add, .update:
                    self?.saveTicket(ticket, in: context, saveImmediately: false)
                case .remove:
                    self?.removeTicket(ticket, in: context, saveImmediately: false)
                case .unknown:
                    print("⚠️Warning: no ticket should have unknown operation type!")
                }
            }

            self?.saveContext(context, saveParent: onBackground)
        }
    }

    private func saveTicket(_ ticket: Ticket,
                            in context: NSManagedObjectContext? = nil,
                            saveImmediately: Bool = true) {
        let context = context ?? defaultContext

        let ticketManagedObject = getTicketManagedObject(for: ticket.ticketId, in: context) ??
            CDTicket(context: context)

        ticketManagedObject.update(with: ticket)
        if ticketManagedObject.type == nil || ticketManagedObject.type?.typeID != ticket.typeId {
            if let typeManagedObject = getTicketTypeManagedObject(for: ticket.typeId, in: context) {

                ticketManagedObject.type = typeManagedObject
            } else {

                if let type = ticket.type {
                    ticketManagedObject.type = CDTicketType(with: type, in: context)
                }
            }
        }

        if saveImmediately { saveContext(context) }
    }

    private func removeTicket(_ ticket: Ticket,
                              in context: NSManagedObjectContext? = nil,
                              saveImmediately: Bool = true) {
        let context = context ?? defaultContext

        if let existingTicketManagedObject = getTicketManagedObject(for: ticket.ticketId, in: context) {

            context.delete(existingTicketManagedObject)
            if saveImmediately { saveContext(context) }
        }
    }

    private func getTicketManagedObject(for ticketId: String,
                                        in context: NSManagedObjectContext? = nil) -> CDTicket? {
        let context = context ?? defaultContext

        let request = CDTicket.fetchTicketsRequest()
        request.predicate = CDTicket.equalTicketIdPredicate(ticketId)

        do {

            let results = try context.fetch(request)
            return results.first
        } catch {

            let nserror = error as NSError
            fatalError("Error getting Tickets:\n \(nserror), \(nserror.userInfo)")
        }

        return nil
    }

    // MARK: - Ticket Types
    func getTicketType(for typeId: String) -> TicketType? {
        return getTicketTypeManagedObject(for: typeId)?.ticketType()
    }

    private func saveTicketType(_ type: TicketType,
                                in context: NSManagedObjectContext? = nil,
                                saveImmediately: Bool = true) {
        let context = context ?? defaultContext

        let ticketTypeManagedObject = getTicketTypeManagedObject(for: type.typeId, in: context) ??
            CDTicketType(context: context)

        ticketTypeManagedObject.update(with: type)

        if saveImmediately { saveContext(context) }
    }

    private func getTicketTypeManagedObject(for typeId: String,
                                            in context: NSManagedObjectContext? = nil) -> CDTicketType? {
        let context = context ?? defaultContext

        let request = CDTicketType.fetchTicketTypesRequest()
        request.predicate = CDTicketType.equalTicketTypeIdPredicate(typeId)

        do {

            let results = try context.fetch(request)
            return results.first
        } catch {

            let nserror = error as NSError
            fatalError("Error getting Tickets:\n \(nserror), \(nserror.userInfo)")
        }

        return nil
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

    private var defaultContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var privateContext: NSManagedObjectContext {
        let privateManagedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedContext.parent = defaultContext

        return privateManagedContext
    }

    private func saveContext (_ context: NSManagedObjectContext, saveParent: Bool = false) {

        if context.hasChanges {
            do {
                try context.save()
                if saveParent { saveContext(defaultContext)}
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context:\n \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
