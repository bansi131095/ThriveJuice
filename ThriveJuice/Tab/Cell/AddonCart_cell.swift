//
//  AddonCart_cell.swift
//  ThriveJuice
//
//  Created by MacBook on 02/11/23.
//

import UIKit

class AddonCart_cell: UITableViewCell {

    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var vw_size: UIView!
    @IBOutlet weak var vw_Sizes: UIView!
    @IBOutlet weak var txt_size: UITextField!
    @IBOutlet weak var lbl_days: UILabel!
    @IBOutlet weak var vw_day: UIView!
    @IBOutlet weak var vw_days: UIView!
    @IBOutlet weak var txt_days: UITextField!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_Addon: UILabel!
    @IBOutlet weak var tbl_addon: UITableView!
    @IBOutlet weak var tbl_addon_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_TotalPrice: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    
    var arr_ProductDays: [Product_Size] = []
    var arr_ProductSizes: [Product_Size] = []
    var arr_ProductSize: [Product_Size] = []
    var arr_addon: [Addons] = []
    let pickerDaysView = UIPickerView()
    let pickerSizesView = UIPickerView()
    var vw_cart = Cart_VC()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var Act_MinusCart:(()->Void)?
    @IBAction func act_minus(_ sender: UIButton) {
        self.Act_MinusCart?()
    }
    
    var Act_AddPlus:(()->Void)?
    @IBAction func act_Plus(_ sender: UIButton) {
        self.Act_AddPlus?()
    }
    
    var Act_cancel:(()->Void)?
    @IBAction func act_cancel(_ sender: UIButton) {
        self.Act_cancel?()
    }
    
    var Act_ChangeSize:((_ str:String)->Void)?
    
    var Act_ChangeDays:((_ str: String)->Void)?
    
    
    
    //MARK:- Function
    func SetPickerVWDays() {
        pickerDaysView.delegate = self
        pickerDaysView.dataSource = self
                
        // Assign the picker view as the input view for the text field
        self.txt_days.inputView = pickerDaysView
        for i in 0..<self.arr_ProductDays.count {
//            if self.arr_ProductDays[i].is_Selected != nil {
                if let select = self.arr_ProductDays[i].is_Selected {
                    if select {
                        self.txt_days.text = self.arr_ProductDays[i].product_Days ?? ""
                    } else {
                        
                    }
                }
//            }
        }
        
    }
    
    func SetPickerVWSizes() {
        pickerSizesView.delegate = self
        pickerSizesView.dataSource = self
                
        // Assign the picker view as the input view for the text field
        self.txt_size.inputView = pickerSizesView
        for i in 0..<self.arr_ProductSizes.count {
//            if self.arr_ProductSizes[i].is_Selected != nil {
                if let select = self.arr_ProductSizes[i].is_Selected {
                    if select {
                        self.txt_size.text = self.arr_ProductSizes[i].product_Size ?? ""
                    } else {
                        
                    }
                }
//            }
        }      
    }
    
    func setTableView() {
        self.tbl_addon.register(UINib(nibName: "AddonList_cell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_addon.dataSource = self
        self.tbl_addon.delegate = self
        self.tbl_addon.reloadData()
    }
    
}


extension AddonCart_cell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_addon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbl_addon.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddonList_cell
        cell.lbl_title.text = ""
        cell.lbl_AddonName.text = self.arr_addon[indexPath.row].addon_Name
        cell.lbl_price.text = "$" + (self.arr_addon[indexPath.row].addon_Price ?? "0")
        return cell
    }
    
}

extension AddonCart_cell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of components in the picker view (columns)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == self.pickerDaysView {
            count = self.arr_ProductDays.count
        } else if pickerView == self.pickerSizesView {
            count = self.arr_ProductSizes.count
        }
        return count// Replace with the actual data source count
    }
    
    // Content for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var str = ""
        if pickerView == self.pickerDaysView {
            str = self.arr_ProductDays[row].product_Days ?? ""
        } else if pickerView == self.pickerSizesView {
            str = self.arr_ProductSizes[row].product_Size ?? ""
        }
        return str// Replace with the actual data
    }
    
    // Handle selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerDaysView {
            self.txt_days.text = self.arr_ProductDays[row].product_Days ?? "" // Update the text field's text
            self.lbl_total.text = "$" + (self.arr_ProductDays[row].product_Price ?? "0")
            let filteredData = self.arr_ProductSize.filter { Data in
                return Data.product_Days == (self.arr_ProductDays[row].product_Days ?? "")
            }
            self.arr_ProductSizes = filteredData
            self.Act_ChangeDays?(self.txt_days.text ?? "")
            self.pickerSizesView.reloadAllComponents()
        } else if pickerView == self.pickerSizesView {
            self.txt_size.text = self.arr_ProductSizes[row].product_Size ?? "" // Update the text field's text
            self.lbl_total.text = "$" + (self.arr_ProductSizes[row].product_Price ?? "0")
            self.Act_ChangeSize?(self.txt_size.text ?? "")
        }
        
        self.endEditing(true)
    }
    
}
