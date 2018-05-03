//
//  Constants.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

final class APIConstants {
    struct Ticket {
        static let items = "items"

        static let ticketId = "id"
        static let typeId = "item_type_id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let reference = "ref_number"
        static let operation = "operation"
        static let isUsed = "is_used"

    }

    struct TicketType {
        static let items = "item_types"

        static let typeId = "id"
        static let name = "title"
    }

    struct Operation {
        static let add = "add"
        static let update = "replace"
        static let remove = "remove"
    }
}
