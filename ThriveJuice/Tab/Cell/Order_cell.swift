//
//  Order_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 14/08/23.
//

import UIKit


class Order_cell: UITableViewCell {

    
    @IBOutlet weak var lbl_order: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_DeliveryDateTitle: UILabel!
    @IBOutlet weak var lbl_DeliveryDate: UILabel!
    @IBOutlet weak var btn_repeat: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var lbl_week: UILabel!
    
    var arr_cartData: [Cart_Datas] = []
//    var str_addon = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set_TableView() {
        self.tbl_vw.register(UINib(nibName: "OrderProduct_cell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        self.tbl_vw.reloadData()
    }
    
    var Act_RepeatOrder:(()->Void)?
    @IBAction func act_Repeat(_ sender: UIButton) {
        self.Act_RepeatOrder?()
    }
    
    
    var Act_Cancel:(()->Void)?
    @IBAction func act_Cancel(_ sender: UIButton) {
        self.Act_Cancel?()
    }
    
    
}


extension Order_cell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_cartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderProduct_cell {
            cell.lbl_price.text = "$" + (self.arr_cartData[indexPath.row].cart_Product_Price ?? "0")
            cell.lbl_product.text = self.arr_cartData[indexPath.row].product_Name
            cell.lbl_qty.text = "X " + (self.arr_cartData[indexPath.row].cart_Qty ?? "0")
            if let arr = self.arr_cartData[indexPath.row].cart_Addons_Price, arr.count != 0 {
                var str = ""
                for i in 0..<arr.count {
                    if i != 0 {
                        str += ", "
                    }
                    if let name = arr[i].addon_Name {
                        str += name
                    }
                }
                print("Addon: ", str)
                cell.lbl_Addon.text = str
                cell.lbl_title.text = "Addon: "
                cell.lbl_titleWidth_const.constant = 43.0
            } else {
                cell.lbl_Addon.text = ""
                cell.lbl_title.text = ""
                cell.lbl_titleWidth_const.constant = 0.0
            }
            var str = ""
            if let days = self.arr_cartData[indexPath.row].cart_Days {
                if days != "" {
                    str += "Day: " + days
                }
            }
            if let size = self.arr_cartData[indexPath.row].cart_Product_Size {
                if size != "" && size != " " {
                    str += "   "
                    str += "Size: " + size
                }
            }
            cell.lbl_size.text = str
            return cell
        }
        return UITableViewCell()
    }
    
}
