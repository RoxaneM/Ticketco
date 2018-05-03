//
//  TicketType.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/4/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import SwiftyJSON

class TicketType: Equatable {
    static func == (lhs: TicketType, rhs: TicketType) -> Bool {
        return lhs.typeId == rhs.typeId
    }

    var typeId: String
    var name: String

    init(from json: JSON) {
        let keys = APIConstants.TicketType.self

        typeId = json[keys.typeId].stringValue
        name = json[keys.name].stringValue
    }

    init() {
        typeId = ""
        name = "Manon"
    }
}
