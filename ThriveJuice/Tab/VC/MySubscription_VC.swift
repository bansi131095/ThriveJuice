//
//  MySubscription_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 17/08/23.
//

import UIKit
import ObjectMapper


class MySubscription_VC: UIViewController {

    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_EmptyData: UIView!
    
    var arr_order: [Orders] = []
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tbl_vw.register(UINib(nibName: "Order_cell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        
        let footerView = BlankFooterView(frame: CGRect(x: 0, y: 0, width: self.tbl_vw.frame.size.width, height: 70.0))
        self.tbl_vw.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_OrdersAPI()
    }

    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- API Call
    func call_OrdersAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Type"] = "Subscription_Orders"
        
        WebService.call.POSTT(filePath: global.shared.URL_Orders, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:OrderListModel = Mapper<OrderListModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.orders, arr.count != 0 {
                    self.arr_order = arr
                    self.tbl_vw.isHidden = false
                    self.vw_EmptyData.isHidden = true
                    self.tbl_vw.reloadData()
                } else {
                    self.tbl_vw.isHidden = true
                    self.vw_EmptyData.isHidden = false
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
                        self.call_OrdersAPI()
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



extension MySubscription_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Order_cell {
            let dict = self.arr_order[indexPath.row]
            var heights = 0
            if let arr = dict.cart_Data, arr.count != 0 {
                cell.arr_cartData = arr
                let count = cell.arr_cartData.count
                if count != 0 {
                    for i in 0..<cell.arr_cartData.count {
                        heights += 60
                        if let arr = cell.arr_cartData[i].cart_Addons_Price, arr.count != 0 {
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
                cell.tbl_height_const.constant = CGFloat(heights)
                cell.tbl_vw.reloadData()
                cell.set_TableView()
            }
            cell.lbl_order.text = "#" + (dict.order_Id ?? "0")
            cell.lbl_date.text = dict.order_Added_At ?? ""
            if let status = dict.order_Status {
                if status == "Pending" {
                    cell.lbl_status.textColor = UIColor(named: "Green")
                } else if status == "Completed" {
                    cell.lbl_status.textColor = UIColor(named: "Green")
                }
            }
            cell.lbl_status.text = "." + (dict.order_Status ?? "")
            cell.lbl_DeliveryDate.text = dict.delivery_Date ?? ""
            cell.lbl_total.text = "Total: \n$" + (dict.grand_Total ?? "")
            if let subweek = dict.subscribe_Week {
                if Int(subweek)! > 0 {
                    if let subCancel = dict.subscribe_Week_Cancel {
                        if subCancel == "0" {
                            cell.btn_Cancel.isHidden = false
                            cell.btn_repeat.isHidden = true
                        } else {
                            cell.btn_Cancel.isHidden = true
                            cell.btn_repeat.isHidden = true
                        }
                    }
                    cell.lbl_week.text = subweek + " Weeks"
                } else {
                    cell.lbl_week.text = ""
                    cell.btn_Cancel.isHidden = true
                    cell.btn_repeat.isHidden = false
                }
            } else {
                cell.lbl_week.text = ""
                cell.btn_Cancel.isHidden = true
                cell.btn_repeat.isHidden = false
            }
            cell.Act_RepeatOrder = {
                global.shared.arr_AddCartData.removeAll()
                var arrcartData: [CartData] = []
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
            cell.Act_Cancel = {
                if let id = dict.order_Id {
                    self.showAlertwithOptions(Title: "", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to cancel this subscription?", completion: { tap in
                        if tap{
                            //LOgout
                            self.call_CancelSubscriptionAPI(OrderId: id)
                        } else {
                            //do nothing
                        }
                    })
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetails_VC") as! OrderDetails_VC
        details.OrderId = self.arr_order[indexPath.row].order_Id ?? ""
        if let subweek = self.arr_order[indexPath.row].subscribe_Week {
            if Int(subweek)! > 0 {
                details.subscribe_Week = subweek
                details.subscribe_Week_Cancel = self.arr_order[indexPath.row].subscribe_Week_Cancel
            }
        }
        self.navigationController?.pushViewController(details, animated: true)
    }
    
}
