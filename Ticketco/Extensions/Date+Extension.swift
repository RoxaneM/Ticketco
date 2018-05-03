//
//  Date+Extension.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/3/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import Foundation

extension Date {
    func mediumDescription() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium

        return dateFormatter.string(from: self)
    }

    func fullDescription() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        return dateFormatter.string(from: self)
    }
}
