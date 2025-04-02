//
//  StoreList_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 01/09/23.
//

import UIKit

class StoreList_cell: UITableViewCell {

    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_City: UILabel!
    @IBOutlet weak var vw_card: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
