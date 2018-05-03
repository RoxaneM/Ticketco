//
//  CDTicketType+CoreDataClass.swift
//  
//
//  Created by Roxane Gud on 5/2/18.
//
//

import Foundation
import CoreData

public class CDTicketType: NSManagedObject {

    class func fetchTicketTypesRequest() -> NSFetchRequest<CDTicketType> {
        return NSFetchRequest<CDTicketType>(entityName: "CDTicketType")
    }

    class func equalTicketTypeIdPredicate(_ typeId: String) -> NSPredicate {
        return NSPredicate(format: "typeID == %@", typeId)
    }

    @NSManaged public var typeID: String
    @NSManaged public var name: String

    convenience init(with type: TicketType, in context: NSManagedObjectContext) {
        self.init(context: context)

        update(with: type)
    }

    func update(with type: TicketType) {
        typeID = type.typeId
        name = type.name
    }

    func ticketType() -> TicketType {
        let type = TicketType()

        type.typeId = typeID
        type.name = name

        return type
    }

}
