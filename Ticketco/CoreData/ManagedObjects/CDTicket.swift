//
//  CDTicket+CoreDataClass.swift
//  
//
//  Created by Roxane Gud on 5/2/18.
//
//

import Foundation
import CoreData

//@objc(CDTicket)
public class CDTicket: NSManagedObject {

    @nonobjc public class func fetchTicketsRequest() -> NSFetchRequest<CDTicket> {
        return NSFetchRequest<CDTicket>(entityName: "CDTicket")
    }

    @NSManaged public var ticketID: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var reference: String?
    @NSManaged public var type: CDTicketType?

    convenience init(with ticket: Ticket, in context: NSManagedObjectContext) {
        self.init(context: context)

        ticketID = ticket.ticketId
        firstName = ticket.firstName
        lastName = ticket.lastName
        reference = ticket.referenceNumber
    }

    func ticket() -> Ticket {
        let ticket = Ticket()

        ticket.ticketId = ticketID ?? ""
        ticket.firstName = firstName ?? ""
        ticket.lastName = lastName ?? ""
        ticket.referenceNumber = reference ?? ""

        return Ticket()
    }

}
