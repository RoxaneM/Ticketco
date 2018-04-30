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

    func getTickets() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            let endpoint = "items"
            _ = self?.sendRequest(endpoint: endpoint)
                .subscribe(onNext: { (json, error) in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        print(json ?? "lap")
                        observer.onCompleted()
                    }
                }, onError: { error in
                    print(error)
                    observer.onError(error)
                })

            return Disposables.create()
        }
    }
}
