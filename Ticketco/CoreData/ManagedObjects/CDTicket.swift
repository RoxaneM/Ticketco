//
//  CDTicket+CoreDataClass.swift
//  
//
//  Created by Roxane Gud on 5/2/18.
//
//

import Foundation
import CoreData

class CDTicket: NSManagedObject {

    class func fetchTicketsRequest() -> NSFetchRequest<CDTicket> {
        return NSFetchRequest<CDTicket>(entityName: "CDTicket")
    }

    class func equalTicketIdPredicate(_ ticketId: String) -> NSPredicate {
        return NSPredicate(format: "ticketID == %@", ticketId)
    }

    @NSManaged public var ticketID: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var reference: String
    @NSManaged public var type: CDTicketType?

    func update(with ticket: Ticket) {
        ticketID = ticket.ticketId
        firstName = ticket.firstName
        lastName = ticket.lastName
        reference = ticket.referenceNumber
    }

    func ticket() -> Ticket {
        let ticket = Ticket()

        ticket.ticketId = ticketID
        ticket.firstName = firstName
        ticket.lastName = lastName
        ticket.referenceNumber = reference

        ticket.type = type?.ticketType()

        return ticket
    }

}
