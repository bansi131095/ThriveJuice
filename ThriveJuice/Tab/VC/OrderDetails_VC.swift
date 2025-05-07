//
//  OrderDetails_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 15/08/23.
//

import UIKit
import ObjectMapper


class OrderDetails_VC: UIViewController {

    
    @IBOutlet weak var lbl_orderNo: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_DeliveryDateTitle: UILabel!
    @IBOutlet weak var lbl_deliveryDate: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_SubTotal: UILabel!
    @IBOutlet weak var vw_discount: UIView!
    @IBOutlet weak var lbl_discountTitle: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var vw_SubscribeDiscount: UIView!
    @IBOutlet weak var lbl_Subscribediscount: UILabel!
    @IBOutlet weak var lbl_SubscribeDiscountPrice: UILabel!
    @IBOutlet weak var vw_shippingCharge: UIView!
    @IBOutlet weak var lbl_ShippingCharge: UILabel!
    @IBOutlet weak var vw_TaxGST: UIView!
    @IBOutlet weak var lbl_taxGSTPrice: UILabel!
    @IBOutlet weak var vw_TaxPST: UIView!
    @IBOutlet weak var lbl_taxPSTPrice: UILabel!
    @IBOutlet weak var vw_bottleEnvirmentFees: UIView!
    @IBOutlet weak var lbl_BottleEnvir: UILabel!
    @IBOutlet weak var vw_bottleReturnAmount: UIView!
    @IBOutlet weak var lbl_bottleReturnAmount: UILabel!
    @IBOutlet weak var lbl_TotalAmount: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_mobileNo: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var vw_Address: UIView!
    @IBOutlet weak var vw_contactInfo: UIView!
    @IBOutlet weak var lbl_line: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_cancelOrder: UIButton!
    @IBOutlet weak var btn_repeatOrder: UIButton!
    @IBOutlet weak var lbl_week: UILabel!
    
    
    @IBOutlet weak var vwTime: UIView!
    @IBOutlet weak var vwTimeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTimeText: UILabel!
    
    @IBOutlet weak var lbl_OrderType: UILabel!
    
    @IBOutlet weak var vwSpecial_Discount: UIView!
    
    @IBOutlet weak var lblSpecial_Discount: UILabel!
    @IBOutlet weak var vwReward_PointDiscount: UIView!
    
    @IBOutlet weak var lblRewardPoint_Discount: UILabel!
    
    
    @IBOutlet weak var vw_Special_Discount_Description: UIView!
    @IBOutlet weak var lbl_SpecialDiscountDescription: UILabel!
    
    @IBOutlet weak var vw_Special_Instructions: UIView!
    @IBOutlet weak var lbl_Note: UILabel!
    
    @IBOutlet weak var vw_Payment_Mode: UIView!
    @IBOutlet weak var lbl_PaymentMode: UILabel!
    
    
    var subscribe_Week : String?
    var subscribe_Week_Cancel : String?
    
    var dict_order: Orders?
    var arrCartProduct: [Cart_Datas] = []
    var str_addon = ""
    var OrderId = String()
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_week.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_OrderDetailsAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_RepeatOrder(_ sender: UIButton) {
        global.shared.arr_AddCartData.removeAll()
        var arrcartData: [CartData] = []
        if let dict = self.dict_order {
            if let arr = dict.cart_Data {
                for i in 0..<arr.count {
                    let dictCart = arr[i]
                    let data = CartData(productId: (dictCart.product_Id ?? ""), cartQty: (dictCart.cart_Qty ?? ""), cartProductSize: (dictCart.cart_Product_Size ?? ""), cartDays: (dictCart.cart_Days ?? ""), cartAddon: (dictCart.cart_Addons ?? "") )
                    arrcartData.append(data)
                }
            }
            global.shared.arr_AddCartData = arrcartData
            let cart = self.storyboard?.instantiateViewController(withIdentifier: "Cart_VC") as! Cart_VC
            self.navigationController?.pushViewController(cart, animated: true)
        }
    }
    
    @IBAction func act_Cancel(_ sender: UIButton) {
        if let dict = self.dict_order {
            if let id = dict.order_Id {
                self.showAlertwithOptions(Title: "", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to cancel this subscription?", completion: { tap in
                    if tap{
                        //Logout
                        self.call_CancelSubscriptionAPI(OrderId: id)
                    } else {
                        //do nothing
                    }
                })
            }
        }
    }
    
    
    @IBAction func act_Order_cancel(_ sender: UIButton) {
        if let dict = self.dict_order {
            if let id = dict.order_Id {
                self.showAlertwithOptions(Title: "", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to cancel this order?", completion: { tap in
                    if tap{
                        //LOgout
                        self.call_CancelOrderAPI(OrderId: id)
                    } else {
                        //do nothing
                    }
                })
            }
        }
    }
    
    
    //MARK:- Function
    func SetData() {
        if let dict = self.dict_order {
            self.lbl_orderNo.text = "#" + (dict.order_Id ?? "0")
            
            
            if dict.order_Added_At != nil{
                self.lbl_date.text = dict.order_Added_At ?? ""
            }else{
                self.lbl_date.text = ""
            }
            
            if let status = dict.order_Status {
                /*if status == "Pending" {
                    self.lbl_status.textColor = UIColor(named: "Green")
                } else if status == "Completed" {
                    self.lbl_status.textColor = UIColor(named: "Green")
                }*/
                
                if status == "Cancel" {
                    self.lbl_status.textColor = UIColor(named: "Red")
                    self.lbl_status.text = "· " + "Cancelled"
                    btn_cancelOrder.isHidden = true
                }else{
                    self.lbl_status.textColor = UIColor(named: "Green")
                    self.lbl_status.text = "· " + (dict.order_Status ?? "")
                    btn_cancelOrder.isHidden = false
                }
            }
            
            
            
//            self.lbl_status.text = "." + (dict.order_Status ?? "")
            if let delivery = dict.delivery_Date {
                if delivery == "" {
                    self.lbl_DeliveryDateTitle.text = ""
                    self.lbl_deliveryDate.text = dict.delivery_Date ?? ""
                } else {
                    self.lbl_deliveryDate.text = dict.delivery_Date ?? ""
                }
            }
            
            if let delivery = dict.delivery_Time {
                if delivery == "" {
                    self.vwTimeHeight.constant = 0
                    self.lblTime.text = ""
                    self.lblTimeText.text = ""
                } else {
                    self.vwTimeHeight.constant = 30
                    self.lblTime.text = dict.delivery_Time ?? ""
                }
            }
            
            
            if dict.orderType != ""{
                if dict.orderType == "Local_Delivery" {
                    self.lbl_OrderType.text = "Local Delivery"
                }else if dict.orderType == "Store_Pickup" {
                    self.lbl_OrderType.text = "Store Pickup"
                }else if dict.orderType == "Right_Away"{
                    self.lbl_OrderType.text = "Pickup Today"
                }
            }else{
                self.lbl_OrderType.text = ""
            }
            
            
            if dict.special_Discount_Description != "" {
                self.vw_Special_Discount_Description.isHidden = false
                self.lbl_SpecialDiscountDescription.text = dict.special_Discount_Description ?? ""
            }else{
                self.vw_Special_Discount_Description.isHidden = true
                self.lbl_SpecialDiscountDescription.text = ""
            }
            
            if dict.orderNotes != "" {
                self.vw_Special_Instructions.isHidden = false
                self.lbl_Note.text = dict.orderNotes
            }else{
                self.vw_Special_Instructions.isHidden = true
                self.lbl_Note.text = ""
            }
            
            if dict.Payment_Mode != "" {
                self.vw_Payment_Mode.isHidden = false
                if dict.Payment_Mode == "Cash" {
                    self.lbl_PaymentMode.text = "\(dict.Payment_Mode ?? "")"
                }else if dict.Payment_Mode == "Card" {
                    self.lbl_PaymentMode.text = "\(dict.Payment_Mode ?? "")" + " (\(dict.Payment_Card_Type ?? "0")) "
                }else {
                    self.lbl_PaymentMode.text = "\(dict.Payment_Mode ?? "") " + " ( Cash : $\(dict.Cash_Collect ?? "0") | Card : $\(dict.Card_Collect ?? "0") ) "
                }
            }else{
                self.vw_Payment_Mode.isHidden = true
                self.lbl_PaymentMode.text = ""
            }
            
            self.lbl_SubTotal.text = "$" + (dict.product_Total ?? "")
            self.lbl_TotalAmount.text = "$" + (dict.grand_Total ?? "")
            if let id = dict._Address_Id, id != "0" {
                self.vw_Address.isHidden = false
                self.lbl_Address.text = dict.address?.address ?? ""
            } else {
                self.vw_Address.isHidden = true
            }
            self.vw_contactInfo.isHidden = false
            self.lbl_mobileNo.text = dict.store?.name
            var data = ""
            if let address = dict.store?.store_Address {
                data.append(address)
            }
            data.append("\n")
            if let mobile = dict.store?.mobile_No {
                data.append(mobile)
            }
            data.append("\n")
            if let city = dict.store?.store_City, let code = dict.store?.store_Postal_Code {
                let val = city + " - " + code
                data.append(val)
            }
            self.lbl_email.text = data
            var heights = 0
            if let arr = dict.cart_Data {
                self.arrCartProduct = arr
                self.tbl_vw.register(UINib(nibName: "OrderProduct_cell", bundle: nil), forCellReuseIdentifier: "cell")
                let count = self.arrCartProduct.count
                if count != 0 {
                    for i in 0..<self.arrCartProduct.count {
                        heights += 55
                        if let arr = self.arrCartProduct[i].cart_Addons_Price, arr.count != 0 {
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
                            let widths = 240.0
                            let height = str.textHeight(withWidth: widths)
                            heights += Int(height)
                        }
                    }
                }
                self.tbl_vw.delegate = self
                self.tbl_vw.dataSource = self
                self.tbl_vw.rowHeight = UITableView.automaticDimension
                self.tbl_vw.estimatedRowHeight = 60
                self.tbl_vw.reloadData()
                self.tbl_vw.layoutIfNeeded()
                self.tbl_height_const.constant = CGFloat(heights)
            }
            if let subweek = self.subscribe_Week {
                if Int(subweek)! > 0 {
                    if let subCancel = self.subscribe_Week_Cancel {
                        if subCancel == "0" {
                            self.btn_cancel.isHidden = false
                            self.btn_repeatOrder.isHidden = true
                        } else {
                            self.btn_cancel.isHidden = true
                            self.btn_repeatOrder.isHidden = true
                        }
                    }
                    
                    self.lbl_week.text = subweek + " Weeks"
                    self.btn_cancelOrder.isHidden = true
                } else {
                    var status = ""
                    if let Status = dict.order_Status {
                        status = Status;
                    }
                    if (Int(subweek)! == 0 && status == "Pending") {
                        self.btn_cancelOrder.isHidden = false
                    } else {
                        self.btn_cancelOrder.isHidden = true
                    }
                    self.lbl_week.text = ""
                    self.btn_cancel.isHidden = true
                    self.btn_repeatOrder.isHidden = false
                }
            } else {
                self.lbl_week.text = ""
                self.btn_cancel.isHidden = true
                self.btn_repeatOrder.isHidden = false
            }
          /*  if let subCancel = dict.subscribe_Week_Cancel, let subweek = dict.subscribe_Week {
                if Int(subweek)! > 0 {
                    self.lbl_week.text = subweek + " Weeks"
                } else {
                    self.lbl_week.text = ""
                }
                if subCancel == "1" {
                    
                    self.btn_cancel.isHidden = false
                    self.btn_repeatOrder.isHidden = true
                } else if subCancel == "0" {
                    self.btn_cancel.isHidden = true
                    self.btn_repeatOrder.isHidden = false
                }
                if Int(subweek)! > 1 && subCancel == "1" {
                    self.btn_cancel.isHidden = false
                    self.btn_repeatOrder.isHidden = true
                } else if subweek == "0" && subCancel == "0" {
                    self.btn_cancel.isHidden = true
                    self.btn_repeatOrder.isHidden = false
                }  else if subweek == "1" && subCancel == "0" {
                    self.btn_cancel.isHidden = false
                    self.btn_repeatOrder.isHidden = true
                } else {
                    self.btn_cancel.isHidden = true
                    self.btn_repeatOrder.isHidden = true
                }
            }*/
            if let TaxCharge = dict.tax_GST_Charge , let double = Double(TaxCharge) {
                if double == 0 {
                    self.vw_TaxGST.isHidden = true
                } else {
                    self.vw_TaxGST.isHidden = false
                    self.lbl_taxGSTPrice.text = "$" + TaxCharge
                }
            }
            if let TaxPSTCharge = dict.tax_PST_Charge , let double = Double(TaxPSTCharge) {
                if double == 0 {
                    self.vw_TaxPST.isHidden = true
                } else {
                    self.vw_TaxPST.isHidden = false
                    self.lbl_taxPSTPrice.text = "$" + TaxPSTCharge
                }
            }
            if let BottleEnviFees = dict.bottle_Environment_Fees , let double = Double(BottleEnviFees) {
                if double > 0 {
                    self.vw_bottleEnvirmentFees.isHidden = false
                    self.lbl_BottleEnvir.text = "$" + BottleEnviFees
                } else {
                    self.vw_bottleEnvirmentFees.isHidden = true
                }
            }
            if let BottleReturnFees = dict.bottle_Return_Amount , let double = Double(BottleReturnFees) {
                if double > 0 {
                    self.vw_bottleReturnAmount.isHidden = false
                    self.lbl_bottleReturnAmount.text = "- $" + BottleReturnFees
                } else {
                    self.vw_bottleReturnAmount.isHidden = true
                }
            }
            if let discount = dict.discount_Amount, let double = Double(discount) {
                if double == 0 {
                    if let discount1 = dict.reward_Points_Amount, let double1 = Double(discount1) {
                        if double1 == 0 {
                            self.vw_discount.isHidden = true
                        } else {
                            self.vw_discount.isHidden = false
                            self.lbl_discountTitle.text = "Reward Point Discount"
                            self.lbl_discount.text = "- $" + discount1
                        }
                    }
                    
                } else {
                    self.vw_discount.isHidden = false
                    self.lbl_discountTitle.text = "Discount"
                    self.lbl_discount.text = "- $" + discount
                }
            }
            if let subscribeAmount = dict.subscribe_Discount_Amount, let double = Double(subscribeAmount) {
                if double == 0 {
                    self.vw_SubscribeDiscount.isHidden = true
                } else {
                    self.vw_SubscribeDiscount.isHidden = false
                    self.lbl_SubscribeDiscountPrice.text = "- $" + subscribeAmount
                }
            }
            if let shippingCharge = dict.shipping_Charge, let double = Double(shippingCharge) {
                if double == 0 {
                    self.vw_shippingCharge.isHidden = true
                } else {
                    self.vw_shippingCharge.isHidden = false
                    self.lbl_ShippingCharge.text = "$" + shippingCharge
                }
            }
            
            
            /*if let reward_Points_Amount = dict.reward_Points_Amount, let double = Double(reward_Points_Amount) {
                if double == 0 {
                    self.vwReward_PointDiscount.isHidden = true
                }else{
                    self.vwReward_PointDiscount.isHidden = false
                    self.lblRewardPoint_Discount.text = "- $" + reward_Points_Amount
                }
            }*/
        }
    }

    
    //MARK:- API Call
    func call_OrderDetailsAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Order_Id"] = self.OrderId
        
        WebService.call.POSTT(filePath: global.shared.URL_Order_Details, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:OrderDetailsModel = Mapper<OrderDetailsModel>().map(JSONObject: result) {
                if let dict = eventResponseModel.order {
                    self.dict_order = dict
                    self.SetData()
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_CancelSubscriptionAPI(OrderId: String) {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Order_Id"] = OrderId
        
        WebService.call.POSTT(filePath: global.shared.URL_Cancel_Subscription, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:OrderModel = Mapper<OrderModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                        self.call_OrderDetailsAPI()
                    } else {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                    }
                }
            }
        }) {
            
        }
            
    }
    
    func call_CancelOrderAPI(OrderId: String) {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Order_Id"] = OrderId
        
        WebService.call.POSTT(filePath: global.shared.URL_Order_Cancel, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:OrderModel = Mapper<OrderModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                    }
                }
            }
        }) {
            
        }
            
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension OrderDetails_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderProduct_cell {
            cell.lbl_price.text = "$" + (self.arrCartProduct[indexPath.row].cart_Product_Price ?? "0")
            cell.lbl_product.text = self.arrCartProduct[indexPath.row].product_Name
            cell.lbl_qty.text = "X " + (self.arrCartProduct[indexPath.row].cart_Qty ?? "0")
            if let arr = self.arrCartProduct[indexPath.row].cart_Addons_Price, arr.count != 0 {
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
            cell.imgWrong.constant = 0
            cell.priceleding.constant = 0
            cell.imgLeding.constant = 3
            cell.act_cancel.isHidden = true
            var str = ""
            if let days = self.arrCartProduct[indexPath.row].cart_Days {
                if days != "" {
                    str += "Day: " + days
                }
            }
            if let size = self.arrCartProduct[indexPath.row].cart_Product_Size {
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
