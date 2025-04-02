//
//  Address_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 14/09/23.
//

import UIKit

class Address_cell: UITableViewCell {

    
    @IBOutlet weak var vw_address: CardView!
    @IBOutlet weak var lbl_id: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
