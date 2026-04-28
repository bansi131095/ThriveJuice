//
//  FreeProductCell.swift
//  ThriveJuice
//
//  Created by mini new on 19/12/25.
//

import UIKit

class FreeProductCell: UITableViewCell {

    
    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_size: UILabel!
    /*@IBOutlet weak var vw_size: UIView!
    @IBOutlet weak var vw_size_heigth_const: NSLayoutConstraint!*/
    @IBOutlet weak var vw_Sizes: UIView!
    @IBOutlet weak var vw_Sizes_height_const: NSLayoutConstraint!
//    @IBOutlet weak var txt_size: UITextField!
    @IBOutlet weak var lbl_days: UILabel!
//    @IBOutlet weak var vw_day: UIView!
    @IBOutlet weak var vw_days: UIView!
//    @IBOutlet weak var txt_days: UITextField!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var vw_change: UIView!
    @IBOutlet weak var btn_change: UIButton!
    
    @IBOutlet weak var lbl_Offer: UILabel!
    @IBOutlet weak var lbl_Free: UILabel!
    
    @IBOutlet weak var lbl_Price: UILabel!
    
    @IBOutlet weak var lbl_FProductPrice: UILabel!
    @IBOutlet weak var lbl_SProductPrice: UILabel!
    
    var arr_addon: [Product_Addons] = []
    var arr_ProductDays: [Product_Size] = []
    var arr_ProductSizes: [Product_Size] = []
    var arr_ProductSize: [Product_Size] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_Free.textColor = .black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var Act_Change:(()->Void)?
    @IBAction func act_Change(_ sender: UIButton) {
        self.Act_Change?()
    }
    
    var Act_cancel:(()->Void)?
    @IBAction func act_cancel(_ sender: UIButton) {
        self.Act_cancel?()
    }
    
}
