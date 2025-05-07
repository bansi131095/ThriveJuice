//
//  Orders_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 04/08/23.
//

import UIKit
import ObjectMapper


class BlankFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear // Set the background color to clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class Orders_VC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var vw_emptyData: UIView!
    @IBOutlet weak var lbl_sortOrder: UILabel!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    
    
    var str_offset = "0"
    var offset = 0
    var isLoading = false
    var hasMoreData = true
    var arr_order: [Orders] = []
    var strFilterType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_vw.register(UINib(nibName: "Order_cell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        self.tbl_vw.reloadData()
        let footerView = BlankFooterView(frame: CGRect(x: 0, y: 0, width: self.tbl_vw.frame.size.width, height: 70.0))
        self.tbl_vw.tableFooterView = footerView
        
        self.call_OrdersAPI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_OrdersAPI()
        if global.shared.arr_AddCartData.count != 0 {
            var total = 0
            for i in 0..<global.shared.arr_AddCartData.count {
                let qty = global.shared.arr_AddCartData[i].Cart_Qty
                if let val = Int(qty) {
                    total += val
                }
            }
            self.lbl_cartTotal.text = "\(total)"
        }
    }
   
    
    //MARK:- Button Action
    @IBAction func act_Shop(_ sender: UIButton) {
        let shop = self.storyboard?.instantiateViewController(withIdentifier: "Shop_VC") as! Shop_VC
        self.navigationController?.pushViewController(shop, animated: true)
    }
    
    @IBAction func act_Offers(_ sender: UIButton) {
        let offers = self.storyboard?.instantiateViewController(withIdentifier: "Offers_VC") as! Offers_VC
        self.navigationController?.pushViewController(offers, animated: true)
    }
    
    
    @IBAction func act_Cart(_ sender: UIButton) {
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        if userId != "" {
            let cart = self.storyboard?.instantiateViewController(withIdentifier: "Cart_VC") as! Cart_VC
            self.navigationController?.pushViewController(cart, animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
        }
    }
    
    @IBAction func act_Account(_ sender: UIButton) {
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        if userId != "" {
            let account = self.storyboard?.instantiateViewController(withIdentifier: "Account_VC") as! Account_VC
            self.navigationController?.pushViewController(account, animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
        }
    }
    
    @IBAction func act_AllOrderFilter(_ sender: UIButton) {
        let filter = self.storyboard?.instantiateViewController(withIdentifier: "Filter_VC") as! Filter_VC
        filter.modalPresentationStyle = .overFullScreen
        filter.isOrder = true
        filter.delegate = self
        filter.selected_Sort = lbl_sortOrder.text ?? ""
        self.present(filter, animated: true)
    }
    
    
    //MARK:- API Call
    func call_OrdersAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Offset"] = self.str_offset
        paramer["Type"] = "My_Orders"
        paramer["Filter_Order_Type"] = self.strFilterType
        
        WebService.call.POSTT(filePath: global.shared.URL_Orders, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:OrderListModel = Mapper<OrderListModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.orders, arr.count != 0 {
                    if offset == 0 {
                        self.arr_order = arr
                    } else {
                        self.arr_order += arr
                    }
                    if let limit = eventResponseModel.limit {
                        offset += limit
                    }
                    self.isLoading = false
                    self.str_offset = "\(offset)"
                    // Append the newData to your existing data source
                    self.tbl_vw.isHidden = false
                    self.vw_emptyData.isHidden = true
                    self.tbl_vw.reloadData()
                } else {
                    if offset == 0 {
                        self.tbl_vw.isHidden = true
                        self.vw_emptyData.isHidden = false
                    } else {
                        self.tbl_vw.isHidden = false
                        self.vw_emptyData.isHidden = true
                    }
                    self.hasMoreData = false
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
                        self.str_offset = "0"
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


extension Orders_VC: UITableViewDelegate, UITableViewDataSource {
    
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
                        if let name = cell.arr_cartData[i].product_Name {
                            if name.count < 24 {
                                heights += 70
                            } else {
                                heights += 85
                            }
                        } else {
                            heights += 70
                        }
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
                            let widths = 250.0
                            let height = str.textHeight(withWidth: widths)
                            heights += Int(height)
                        }
                    }
                }
                cell.tbl_height_const.constant = CGFloat(heights)
                cell.tbl_vw.reloadData()
                cell.tbl_vw.layoutIfNeeded()
                cell.set_TableView()
            }
            cell.lbl_order.text = "#" + (dict.order_Id ?? "0")
            cell.lbl_date.text = dict.order_Added_At ?? ""
            if let status = dict.order_Status {
                /*if status == "Pending" {
                    cell.lbl_status.textColor = UIColor(named: "Green")
                    cell.lbl_status.text = "· " + "Pending"
                } else if status == "Completed" {
                    cell.lbl_status.textColor = UIColor(named: "Green")
                    cell.lbl_status.text = "· " + "In-P"
                }*/
                
                if status == "Cancel" {
                    cell.lbl_status.textColor = UIColor(named: "Red")
                    cell.lbl_status.text = "· " + "Cancelled"
                }else{
                    cell.lbl_status.textColor = UIColor(named: "Green")
                    cell.lbl_status.text = "· " + (dict.order_Status ?? "")
                }
            }
//            cell.lbl_status.text = "." + (dict.order_Status ?? "")
            if let delivery = dict.delivery_Date {
                if delivery == "" {
                    cell.lbl_DeliveryDateTitle.text = ""
                    cell.lbl_DeliveryDate.text = dict.delivery_Date ?? ""
                } else {
                    cell.lbl_DeliveryDate.text = dict.delivery_Date ?? ""
                }
            }
            
            if let deliveryTime = dict.delivery_Time {
                if deliveryTime == "" {
                    cell.vwHeight.constant = 0
                    cell.lblDeliveryTime.text = ""
                } else {
                    cell.vwHeight.constant = 30
                    cell.lblDeliveryTime.text = dict.delivery_Time ?? ""
                }
            }
            
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



extension Orders_VC: FilterDataDelegate {
    
    func didFinishTask(data: String, type: String, name: String) {
        if type == "Order" {
            offset = 0
            self.str_offset = "0"
            if data == "All Orders" {
                self.strFilterType = ""
            } else if (data == "In-Progress") {
                self.strFilterType = "In_Progress"
            } else if (data == "Cancelled") {
                self.strFilterType = "Cancel"
            } else {
                self.strFilterType = data
            }
            self.lbl_sortOrder.text = data
            self.call_OrdersAPI()
        }
    }
}
