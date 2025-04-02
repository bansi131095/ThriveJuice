//
//  AddressList_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 16/08/23.
//

import UIKit

class AddressList_cell: UITableViewCell {

    @IBOutlet weak var vw_address: CardView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var lbl_city: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_edit:(()->Void)?
    @IBAction func act_edit(_ sender: UIButton) {
        self.Act_edit?()
    }
    
    var Act_delete:(()->Void)?
    @IBAction func act_delete(_ sender: UIButton) {
        self.Act_delete?()
    }
   
    
}
