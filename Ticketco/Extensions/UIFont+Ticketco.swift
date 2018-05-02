//
//  UIFont+Ticketco.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/2/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit

extension UIFont {
    private struct OpenSans {
        static let light    = "OpenSans-Light"
        static let semibold    = "OpenSans-Semibold"
        static let normal = "OpenSans"
        static let bold   = "OpenSans-Bold"
    }

    struct Ticketco {
        static let NavigationBarFont = UIFont(name: OpenSans.bold, size: 15.0)
        static let TicketCellFont = UIFont(name: OpenSans.normal, size: 14.0)
    }
}
