//
//  ViewController.swift
//  Ticketco
//
//  Created by Roxane Gud on 4/30/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    private func loadData() {
        let tickets = TicketcoServerManager.shared.getTickets()
        tickets
            .subscribe(onCompleted: {
                print("Success!")
            })
            .disposed(by: disposeBag)
    }

}
