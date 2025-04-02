//
//  AddonList_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 31/10/23.
//

import UIKit

class AddonList_cell: UITableViewCell {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_AddonName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
