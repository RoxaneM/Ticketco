//
//  TicketTableViewCell.swift
//  Ticketco
//
//  Created by Roxane Gud on 5/2/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit

let ticketTableViewCellIdentifier = "TicketTableViewCellIdentifier"
let ticketTableViewCellNib = UINib(nibName: "TicketTableViewCell", bundle: nil)

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.backgroundColor = UIColor.Ticketco.TicketCellBackgroundColor
        setupLabels()
    }

    func update(with ticket: Ticket) {
        typeLabel.text = ticket.type?.name ?? ticket.typeId
        firstNameLabel.text = ticket.firstName
        lastNameLabel.text = ticket.lastName
        referenceLabel.text = ticket.referenceNumber

        if ticket.isUsed {
            usageLabel.text = "Already used"
            usageLabel.textColor = UIColor.Ticketco.TicketCellUsedTextColor
        } else {
            usageLabel.text = "Not used yet"
            usageLabel.textColor = UIColor.Ticketco.TicketCellNotUsedTextColor
        }
    }

    private func setupLabels() {
        let labels = [typeLabel, firstNameLabel, lastNameLabel, referenceLabel, usageLabel]

        for label in labels {
            label?.font = UIFont.Ticketco.TicketCellFont
            label?.textColor = UIColor.Ticketco.TicketCellTextColor
            label?.textAlignment = .left
        }
    }

}
