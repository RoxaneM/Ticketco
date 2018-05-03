//
//  TicketcoServerManager+TicketTypes.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/4/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import Foundation

import RxSwift
import SwiftyJSON

extension TicketcoServerManager {

    func getTicketTypes() -> Observable<[TicketType]> {
        return Observable.create { [weak self] observer in
            let endpoint = "item_types"
            _ = self?.sendRequest(endpoint: endpoint)
                .subscribe(onNext: { [weak self] (json, error) in
                    if let error = error {
                        observer.onError(error)
                    } else {

                        if let types = self?.parseTicketTypes(json) {
                            observer.onNext(types)
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

    private func parseTicketTypes(_ json: JSON) -> [TicketType]? {
        guard let jsonArray = json[APIConstants.TicketType.items].array else {
            return nil
        }

        var resultArray = [TicketType]()
        for jsonItem in jsonArray {
            let item = TicketType(from: jsonItem)
            resultArray.append(item)
        }

        return resultArray
    }
}
