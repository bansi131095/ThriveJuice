//
//  Product_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 07/08/23.
//

import UIKit

class Product_cell: UICollectionViewCell {

    
    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_ProductName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var btn_AddToCart: UIButton!
    @IBOutlet weak var vw_cart: UIView!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var lbl_cart: UILabel!
    @IBOutlet weak var btn_plus: UIButton!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var img_height_const: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var Act_AddToCart:(()->Void)?
    @IBAction func act_AddToCart(_ sender: UIButton) {
        self.Act_AddToCart?()
    }
    
    var Act_Like:(()->Void)?
    @IBAction func act_Like(_ sender: UIButton) {
        self.Act_Like?()
    }
    
    var Act_MinusCart:(()->Void)?
    @IBAction func act_minus(_ sender: UIButton) {
        self.Act_MinusCart?()
    }
    
    var Act_AddPlus:(()->Void)?
    @IBAction func act_Plus(_ sender: UIButton) {
        self.Act_AddPlus?()
    }
    
    
}
