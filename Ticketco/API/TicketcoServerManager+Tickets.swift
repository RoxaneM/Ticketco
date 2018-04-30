//
//  TicketcoServerManager+Tickets.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import RxSwift
import SwiftyJSON

extension TicketcoServerManager {

    func getTickets() -> Observable<[Ticket]> {
        return Observable.create { [weak self] observer in
            let endpoint = "items"
            _ = self?.sendRequest(endpoint: endpoint)
                .subscribe(onNext: { [weak self] (json, error) in
                    if let error = error {
                        observer.onError(error)
                    } else {

                        if let tickets = self?.parseTickets(json) {
                            observer.onNext(tickets)
                        } else {
                            observer.onError(TicketcoError.invalidJSON(json.stringValue))
                        }
                    }
                }, onError: { error in
                    print(error)
                    observer.onError(error)
                })

            return Disposables.create()
        }
    }

    private func parseTickets(_ json: JSON) -> [Ticket]? {
        guard let jsonArray = json[APIConstants.Ticket.items].array else {
            return nil
        }

        var resultArray = [Ticket]()
        for jsonItem in jsonArray {
            let item = Ticket(from: jsonItem)
            resultArray.append(item)
        }

        return resultArray
    }
}
