//
//  CDTicketType+CoreDataClass.swift
//  
//
//  Created by Roxane Gud on 5/2/18.
//
//

import Foundation
import CoreData

@objc(CDTicketType)
public class CDTicketType: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTicketType> {
        return NSFetchRequest<CDTicketType>(entityName: "CDTicketType")
    }

    @NSManaged public var typeID: String?
    @NSManaged public var name: String?

}
