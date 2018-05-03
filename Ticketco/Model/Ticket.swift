//
//  Ticket.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import SwiftyJSON

enum TicketOperationType {
    case add
    case update
    case remove
    case unknown

    static func getType(from string: String) -> TicketOperationType {
        let operationKeys = APIConstants.Operation.self

        switch string {
        case operationKeys.add:
            return .add
        case operationKeys.update:
            return .update
        case operationKeys.remove:
            return .remove
        default:
            return .unknown
        }
    }
}

class Ticket: Equatable {
    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        return lhs.ticketId == rhs.ticketId
    }

    var ticketId: String
    var typeId: String

    var firstName: String
    var lastName: String
    var referenceNumber: String
    var isUsed: Bool
    var operation: TicketOperationType

    var type: TicketType?

    init(from json: JSON) {
        let keys = APIConstants.Ticket.self

        ticketId = json[keys.ticketId].stringValue
        typeId = json[keys.typeId].stringValue

        firstName = json[keys.firstName].stringValue
        lastName = json[keys.lastName].stringValue
        referenceNumber = json[keys.reference].stringValue
        isUsed = json[keys.isUsed].boolValue

        operation = TicketOperationType.getType(from: json[keys.operation].stringValue)
    }

    init() {
        ticketId = "1"
        typeId = "NoTypeForNow"

        firstName = "Manon"
        lastName = "Blackbeak"
        referenceNumber = "whatevs"
        isUsed = false

        operation = .unknown
    }

}
