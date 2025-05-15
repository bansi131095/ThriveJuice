//
//  OrderSummary_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 04/09/23.
//

import UIKit
import ObjectMapper
import StripePaymentSheet


class OrderSummary_VC: UIViewController {

    @IBOutlet weak var lbl_CouponStatus: UILabel!
    @IBOutlet weak var txt_couponCode: UITextField!
    @IBOutlet weak var vw_Reward: CardView!
    @IBOutlet weak var vw_rewards_height_const: NSLayoutConstraint!
    @IBOutlet weak var btn_rewards: UIButton!
    @IBOutlet weak var lbl_RewardsPrice: UILabel!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_subTotal: UILabel!
    @IBOutlet weak var vw_Discount: UIView!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_DiscountPrice: UILabel!
    @IBOutlet weak var vw_SubscribeDiscount: UIView!
    @IBOutlet weak var lbl_Subscribediscount: UILabel!
    @IBOutlet weak var lbl_SubscribeDiscountPrice: UILabel!
    @IBOutlet weak var vw_shippingCharge: UIView!
    @IBOutlet weak var lbl_shippingChargePrice: UILabel!
    @IBOutlet weak var vw_TaxGST: UIView!
    @IBOutlet weak var lbl_taxGSTPrice: UILabel!
    @IBOutlet weak var vw_TaxPST: UIView!
    @IBOutlet weak var lbl_taxPSTPrice: UILabel!
    @IBOutlet weak var lbl_TotalPrice: UILabel!
    @IBOutlet weak var vw_bottleEnvirmentFees: UIView!
    @IBOutlet weak var lbl_BottleEnvir: UILabel!
    @IBOutlet weak var vw_Coupon: UIView!
    @IBOutlet weak var vw_coupon_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_rewardsPointsMsg: UILabel!
    @IBOutlet weak var vw_cartEmpty: UIView!
    
    
    var OrderData_dict: OrderData?
    var RewardPointRate: String?
    var dict_CartData: CartModel?
    var arrCartProduct: [Cart_Products] = []
    var paymentSheet: PaymentSheet?
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_CartAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_Apply(_ sender: UIButton) {
        if self.txt_couponCode.text != "" {
            self.view.endEditing(true)
            self.call_CartAPI()
        }
    }
    
    @IBAction func act_PayNow(_ sender: UIButton) {
        self.call_AddOrderAPI()
    }
    
    @IBAction func act_Rewards(_ sender: UIButton) {
        if self.btn_rewards.currentImage?.pngData() == UIImage(named: "RdCheck")?.pngData() {
            self.btn_rewards.setImage(UIImage(named: "RdUnCheck"), for: .normal)
        } else {
            self.btn_rewards.setImage(UIImage(named: "RdCheck"), for: .normal)
        }
        self.call_CartAPI()
    }
    
    //MARK:- Function
    func setStripeMethod() {
        
    }
    
    
    //MARK:- API Call
    func call_CartAPI() {
        let arrCartData = global.shared.arr_AddCartData
        var JsonData_Cart = String()
        do {
            let jsonData = try JSONEncoder().encode(arrCartData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonData)
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            JsonData_Cart = jsonString
            // and decode it back
//            let decodedSentences = try JSONDecoder().decode([Commodity_Qty].self, from: jsonData)
//            print(decodedSentences)
        } catch { print(error) }
        
        var paramer: [String: Any] = [:]
        paramer["Cart_Data"] = JsonData_Cart
        paramer["Order_Type"] = self.OrderData_dict?.OrderType
        if self.OrderData_dict?.SubscribeWeek != ""{
            paramer["Subscribe_Week"] = self.OrderData_dict?.SubscribeWeek
        }
        paramer["Use_Reward_Points"] = self.btn_rewards.currentImage?.pngData() == UIImage(named: "RdCheck")?.pngData() ? "1" : "0"
        if let code = self.txt_couponCode.text, code != "" {
            paramer["Coupon_Code"] = code
        }
        
        WebService.call.POSTT(filePath: global.shared.URL_Cart, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            
            if let eventResponseModel:CartModel = Mapper<CartModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.vw_cartEmpty.isHidden = true
                    if let rewardPointRate = eventResponseModel.available_Reward_Points_Rate {
                        self.RewardPointRate = rewardPointRate
                        self.lbl_RewardsPrice.text = "$" + (self.RewardPointRate ?? "0")
                    }
                    self.dict_CartData = eventResponseModel
                    if let arr = eventResponseModel.cart_Products, arr.count != 0 {
                        self.arrCartProduct = arr
                        var heights = 0
                        for i in 0..<self.arrCartProduct.count {
                            if let arr1 = self.arrCartProduct[i].cart_Addons_Price, arr1.count != 0 {
                                var str = ""
                                for i in 0..<arr1.count {
                                    if i != 0 {
                                        str += ", "
                                    }
                                    if let name = arr1[i].addon_Name {
                                        str += name
                                    }
                                }
                                print("Addon: ", str)
                                let widths = self.tbl_vw.bounds.width - 50
                                let height = str.textHeight(withWidth: widths)
                                print("Addon: ", str)
                                heights += 60
                                heights += Int(height)
                            } else {
                                heights += 60
                            }
                        }
                        self.tbl_height_const.constant = CGFloat(heights)
                        self.tbl_vw.register(UINib(nibName: "OrderProduct_cell", bundle: nil), forCellReuseIdentifier: "cell")
                        self.tbl_vw.delegate = self
                        self.tbl_vw.dataSource = self
                        self.tbl_vw.reloadData()
                    }
                    if let subTotal = eventResponseModel.cart_Product_Total {
                        self.lbl_subTotal.text = "$" + subTotal
                    }
                    if let Total = eventResponseModel.grand_Total {
                        self.lbl_TotalPrice.text = "$" + Total
                    }
                    if let availableRewards = eventResponseModel.available_Reward_Points_Rate,let double = Double(availableRewards), let minumumPoints = eventResponseModel.minimum_Point_Usage, let MinimumPoints = Double(minumumPoints) {
                        if double > 0 {
                            self.vw_Reward.isHidden = false
                            self.vw_rewards_height_const.constant = 50.0
                            if double > MinimumPoints {
                                self.btn_rewards.isEnabled = true
                            } else {
                                self.btn_rewards.isEnabled = false
                            }
                        } else {
                            self.vw_Reward.isHidden = true
                            self.vw_rewards_height_const.constant = 0
                        }
                    }
                    if let points = eventResponseModel.earn_Reward_Points, let double = Double(points) {
                        if double > 0 {
                            self.lbl_rewardsPointsMsg.text = "You will Earn \(points) point from this order"
                        } else {
                            self.lbl_rewardsPointsMsg.text = ""
                        }
                    } else {
                        self.lbl_rewardsPointsMsg.text = ""
                    }
                    
                    if let TaxCharge = eventResponseModel.tax_GST_Charge , let double = Double(TaxCharge) {
                        if double == 0 {
                            self.vw_TaxGST.isHidden = true
                        } else {
                            self.vw_TaxGST.isHidden = false
                            self.lbl_taxGSTPrice.text = "$" + TaxCharge
                        }
                    }
                    if let TaxPSTCharge = eventResponseModel.tax_PST_Charge , let double = Double(TaxPSTCharge) {
                        if double == 0 {
                            self.vw_TaxPST.isHidden = true
                        } else {
                            self.vw_TaxPST.isHidden = false
                            self.lbl_taxPSTPrice.text = "$" + TaxPSTCharge
                        }
                    }
                    if let BottleEnviFees = eventResponseModel.bottle_Environment_Fees , let double = Double(BottleEnviFees) {
                        if double > 0 {
                            self.vw_bottleEnvirmentFees.isHidden = false
                            self.lbl_BottleEnvir.text = "$" + BottleEnviFees
                        } else {
                            self.vw_bottleEnvirmentFees.isHidden = true
                        }
                    }
                    if let discount = eventResponseModel.discount_Amount, let double = Double(discount) {
                        if double == 0 {
                            if self.txt_couponCode.text != "" {
                                self.vw_Coupon.isHidden = false
                                self.vw_coupon_height_const.constant = 35
                                self.lbl_CouponStatus.textColor = UIColor(named: "Red")
                                self.lbl_CouponStatus.text = eventResponseModel.message ?? ""
                            } else {
                                self.vw_Discount.isHidden = true
                                self.vw_Coupon.isHidden = true
                                self.vw_coupon_height_const.constant = 0
                            }
                            if self.btn_rewards.currentImage?.pngData() == UIImage(named: "RdCheck")?.pngData() {
                                self.vw_Discount.isHidden = false
                                self.lbl_discount.text = "Reward Point Discount"
                                self.lbl_DiscountPrice.text = "- $" + (eventResponseModel.reward_Points_Amount ?? "0")
                            } else {
                                self.vw_Discount.isHidden = true
                            }
                        } else {
                            self.vw_Coupon.isHidden = false
                            self.vw_coupon_height_const.constant = 35
                            self.lbl_CouponStatus.textColor = UIColor(named: "Green")
                            self.lbl_CouponStatus.text = eventResponseModel.message ?? ""
                            self.vw_Discount.isHidden = false
                            self.lbl_discount.text = "Discount"
                            self.lbl_DiscountPrice.text = "- $" + discount
                        }
                    }
                    if let shippingCharge = eventResponseModel.shipping_Charge, let double = Double(shippingCharge) {
                        if double == 0 {
                            self.vw_shippingCharge.isHidden = true
                        } else {
                            self.vw_shippingCharge.isHidden = false
                            self.lbl_shippingChargePrice.text = "$" + shippingCharge
                        }
                    }
                    if let subscribeAmount = eventResponseModel.subscribe_Discount_Amount, let double = Double(subscribeAmount) {
                        if double == 0 {
                            self.vw_SubscribeDiscount.isHidden = true
                        } else {
                            self.vw_SubscribeDiscount.isHidden = false
                            self.lbl_SubscribeDiscountPrice.text = "- $" + subscribeAmount
                        }
                    }
                    
                } else {
                    self.vw_cartEmpty.isHidden = false
                }
                
            }
        }) {
            
        }
            
    }
    
    
    func call_AddOrderAPI() {
        // Delivery_Date, Subscribe_Week, Order_Type = Local_Delivery / Store_Pickup
        // Cart_Data
        
        let arrCartData = global.shared.arr_AddCartData
        var JsonData_Cart = String()
        do {
            let jsonData = try JSONEncoder().encode(arrCartData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonData)
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            JsonData_Cart = jsonString
            // and decode it back
//            let decodedSentences = try JSONDecoder().decode([Commodity_Qty].self, from: jsonData)
//            print(decodedSentences)
        } catch { print(error) }
        
        var paramer: [String: Any] = [:]
        paramer["Cart_Data"] = JsonData_Cart
        paramer["Order_Type"] = self.OrderData_dict?.OrderType
        paramer["Delivery_Date"] = self.OrderData_dict?.DeliveryDate
        paramer["Delivery_Time"] = self.OrderData_dict?.DeliveryTime
        paramer["Order_Notes"] = self.OrderData_dict?.OrderNotes
        if self.OrderData_dict?.SubscribeWeek != ""{
            paramer["Subscribe_Week"] = self.OrderData_dict?.SubscribeWeek
        }
        paramer["Use_Reward_Points"] = self.btn_rewards.currentImage?.pngData() == UIImage(named: "RdCheck")?.pngData() ? "1" : "0"
        if let code = self.txt_couponCode.text, code != "" {
            paramer["Coupon_Code"] = code
        }

        WebService.call.POSTT(filePath: global.shared.URL_Add_Order, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:OrderModel = Mapper<OrderModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            // Code to execute after a 2-second delay
                            if let PaymentStatus = eventResponseModel.payment_Status {
                                if PaymentStatus == "Pending" {
                                    self.call_StripepaymentAPI(orderId: eventResponseModel.orderId ?? "")
                                } else {
                                    UserDefaults.standard.removeObject(forKey: "cartDataList")
                                    global.shared.arr_AddCartData.removeAll()
                                    let complete = self.storyboard?.instantiateViewController(withIdentifier: "OrderComplete_VC") as! OrderComplete_VC
                                    complete.OrderId = eventResponseModel.orderId ?? "0"
                                    complete.EarnRewardPoints = eventResponseModel.earnRewardPoints ?? "0"
                                    self.navigationController?.pushViewController(complete, animated: true)
                                }
                            }
                        }
                    } else {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                    }
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_StripepaymentAPI(orderId: String) {
        
        var paramer: [String: Any] = [:]
        paramer["Order_Id"] = orderId
        

        WebService.call.POSTT(filePath: global.shared.URL_StripepaymentAPI, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:StripeaPaymentResponse = Mapper<StripeaPaymentResponse>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        let customerId = eventResponseModel.customer ?? ""
                        let customerEphemeralKeySecret = eventResponseModel.ephemeralKey ?? ""
                        let paymentIntentClientSecret = eventResponseModel.paymentIntent ?? ""
                        let publishableKey = eventResponseModel.publishableKey ?? ""
                        STPAPIClient.shared.publishableKey = publishableKey
                        // MARK: Create a PaymentSheet instance
                        var configuration = PaymentSheet.Configuration()
                        configuration.merchantDisplayName = ""
                        configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
                        // Set `allowsDelayedPaymentMethods` to true if your business handles
                        // delayed notification payment methods like US bank accounts.
                        configuration.allowsDelayedPaymentMethods = true
                        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)

                        self.paymentSheet?.present(from: self) { paymentResult in
                            // MARK: Handle the payment result
                            switch paymentResult {
                            case .completed:
                              print("Your order is confirmed")
                                self.call_CompleteOrderAPI(orderId: orderId)
                            case .canceled:
                              print("Canceled!")
                            case .failed(let error):
                              print("Payment failed: \(error)")
                            }
                          }
                    } else {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                    }
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_CompleteOrderAPI(orderId: String) {
        
        var paramer: [String: Any] = [:]
        paramer["Order_Id"] = orderId
        

        WebService.call.POSTT(filePath: global.shared.URL_Complete_Order_Payment, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:OrderModel = Mapper<OrderModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        self.showAlertToast(message: eventResponseModel.message ?? "")
                        UserDefaults.standard.removeObject(forKey: "cartDataList")
                        global.shared.arr_AddCartData.removeAll()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            // Code to execute after a 2-second delay
                            let complete = self.storyboard?.instantiateViewController(withIdentifier: "OrderComplete_VC") as! OrderComplete_VC
                            complete.OrderId = eventResponseModel.orderId ?? "0"
                            complete.EarnRewardPoints = eventResponseModel.earnRewardPoints ?? "0"
                            self.navigationController?.pushViewController(complete, animated: true)
                        }
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


extension OrderSummary_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderProduct_cell {
            let data = self.arrCartProduct[indexPath.row]
            cell.lbl_price.text = "$" + (data.cart_Product_Price ?? "0")
            cell.lbl_product.text = data.product_Name
            cell.lbl_qty.text = "X " + (data.cart_Qty ?? "0")
            if let days = data.cart_Days {
                if days == "" {
                    cell.lbl_size.text = ""
                } else {
                    cell.lbl_size.text = "Day: " + days
                }
            }
            if let size = data.cart_Product_Size {
                if size == "" || size == " " {
                    cell.lbl_size.text?.append("")
                } else {
                    cell.lbl_size.text?.append("   Size: \(size)")
                }
            }
            if let arr = data.cart_Addons_Price, arr.count != 0 {
                var str_addon = ""
                for i in 0..<arr.count {
                    if let name = arr[i].addon_Name {
                        str_addon.append("\(name),")
                    }
                }
                if str_addon.last == "," {
                    str_addon.removeLast()
                }
                cell.lbl_Addon.text = str_addon
                cell.lbl_title.text = "Addon: "
                cell.lbl_titleWidth_const.constant = 43.0
            } else {
                cell.lbl_Addon.text = ""
                cell.lbl_title.text = ""
                cell.lbl_titleWidth_const.constant = 0.0
            }
            cell.act_cancel.isHidden = true
            /*cell.Act_cancel = {
                if let id = data.product_Id {
                    let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                    if arrCart.count != 0 {
                        if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
//                            let count = global.shared.arr_AddCartData[index].Cart_Qty
//                            if let total = Int(count) {
//                                cart_countQty -= total
//                            }
                            global.shared.arr_AddCartData.remove(at: index)
                        }
                    }
                }
                self.call_CartAPI()
                print("Arr data \(global.shared.arr_AddCartData)")
                print("Arr data count \(global.shared.arr_AddCartData.count)")
            } */
            return cell
        }
        return UITableViewCell()
    }
    
}
