//
//  OrderProduct_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 15/08/23.
//

import UIKit

class OrderProduct_cell: UITableViewCell {

    
    @IBOutlet weak var lbl_product: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_Addon: UILabel!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_titleWidth_const: NSLayoutConstraint!
    @IBOutlet weak var act_cancel: UIButton!
    
    @IBOutlet weak var imgWrong: NSLayoutConstraint!
    @IBOutlet weak var priceleding: NSLayoutConstraint!
    @IBOutlet weak var imgLeding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_cancel:(()->Void)?
    @IBAction func act_Cancel(_ sender: Any) {
        self.Act_cancel?()
    }
    
    
}
