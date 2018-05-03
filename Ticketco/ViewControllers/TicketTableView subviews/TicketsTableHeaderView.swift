//
//  TicketTableHeaderView.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/3/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit

class TicketsTableHeaderView: UIView {

    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var removedLabel: UILabel!
    @IBOutlet weak var lastUpdateDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.Ticketco.UpdateInfoHeaderBackgroundColor

        setupLabels()
    }

    func update(with info: UpdateInfo) {
        addedLabel.text = "Added # \(info.added)"
        updatedLabel.text = "Updated # \(info.updated)"
        removedLabel.text = "Deleted # \(info.removed)"

        if let dateDescription = info.updateDate.value?.mediumDescription() {
            lastUpdateDateLabel.isHidden = false
            lastUpdateDateLabel.text = "Last update # \(dateDescription)"
        } else {
            lastUpdateDateLabel.isHidden = true
        }
    }

    private func setupLabels() {
        let labels = [addedLabel, updatedLabel, removedLabel]

        for label in labels {
            label?.font = UIFont.Ticketco.UpdateInfoHeaderFont
            label?.textColor = UIColor.Ticketco.UpdateInfoHeaderTextColor
            label?.textAlignment = .left
        }

        lastUpdateDateLabel.font = UIFont.Ticketco.UpdateDateFont
        lastUpdateDateLabel.textColor = UIColor.Ticketco.UpdateDateTextColor
        lastUpdateDateLabel.textAlignment = .right
    }

}
