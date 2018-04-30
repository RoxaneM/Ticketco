//
//  TicketcoServerManager.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import RxSwift
import RxAlamofire
import SwiftyJSON

import Alamofire

enum TicketcoError: Error {
    case serverError(TicketcoErrorCode, String)
    case invalidJSON(String)
}

enum TicketcoErrorCode: Int {
    case success        = 200
    case internalError  = 500

    case unrecognizedCode = 0
}

class TicketcoServerManager {
    private static let serverURL = "https://ticketco-ticketco-test-assignment.auto.cmd.as"
    private static let apiVersion = "api/v1"

    static let shared = TicketcoServerManager()

    private let authorizationToken = "OUm7OXrcLLn_5aXhAQoViw"

    private var baseURL: String {
        return "\(TicketcoServerManager.serverURL)/\(TicketcoServerManager.apiVersion)/"
    }

    func sendRequest(endpoint: String,
                     method: HTTPMethod = .get,
                     parameters: Parameters = Parameters()) -> Observable<(JSON?, TicketcoError?)> {
        let fullURL = baseURL + endpoint
        let fullParameters = parameters.dictionary(byAppending: ["token": authorizationToken])

        return RxAlamofire
            .requestJSON(method, fullURL, parameters: fullParameters, headers: nil)
            .map { (response, json) in

                if let error = TicketcoServerManager.validateResponse(response) {
                    return (JSON(response), error)
                } else {
                    return (JSON(json), nil)
                }
        }
    }

    private static func validateResponse(_ response: HTTPURLResponse) -> TicketcoError? {
        let statusCode = TicketcoErrorCode(rawValue: response.statusCode) ?? .unrecognizedCode

        switch statusCode {
        case .success:
            return nil
        case .internalError:
            return .serverError(statusCode, response.description)
        case .unrecognizedCode:
            fatalError("Unrecognized code was sent from server: \n \(response.description)")
        }
    }
}
