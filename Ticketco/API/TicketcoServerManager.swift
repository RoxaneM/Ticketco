//
//  TicketcoServerManager.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import Foundation

class TicketcoServerManager {
    private static let serverURL = "https://ticketco-ticketco-test-assignment.auto.cmd.as"
    private static let apiVersion = "api/v1"

    
    private static var baseURL: String {
        return "\(serverURL)/\(apiVersion)/"
    }

    private static let authorizationToken = "OUm7OXrcLLn_5aXhAQoViw"
    
    static let shared = TicketcoServerManager()
    
}
