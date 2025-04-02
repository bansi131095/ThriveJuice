//
//  Faq_cell.swift
//  Banthosh
//
//  Created by MacBook on 04/07/23.
//

import UIKit

class Faq_cell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_answer: UILabel!
    @IBOutlet weak var vw_answer: UIView!
    @IBOutlet weak var btn_arrow: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_Arrow:(()->Void)?
    @IBAction func act_Arrow(_ sender: UIButton) {
//        self.Act_Arrow?()
    }
    
    
}
