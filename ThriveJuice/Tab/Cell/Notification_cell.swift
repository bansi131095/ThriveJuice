//
//  Notification_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 18/09/23.
//

import UIKit

class Notification_cell: UITableViewCell {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
