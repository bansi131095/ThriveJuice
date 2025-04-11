//
//  Cart_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 12/08/23.
//

import UIKit
import ObjectMapper


class Cart_VC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var lbl_TotalPrice: UILabel!
    @IBOutlet weak var lbl_TotalProduct: UILabel!
    @IBOutlet weak var vw_buyNow: UIView!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    @IBOutlet weak var vw_emptyCart: UIView!
    @IBOutlet weak var btn_clearAll: UIButton!
    @IBOutlet weak var vw_Msg: UIView!
    @IBOutlet weak var lbl_msg: UILabel!
    
    var arrCartData: [CartData] = []
    var arrCartProduct: [Cart_Products] = []
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.arrCartData = global.shared.arr_AddCartData
        if self.arrCartData.count != 0 {
            self.call_CartAPI()
        } else {
            self.tbl_vw.isHidden = true
            self.vw_buyNow.isHidden = true
        }
        if global.shared.arr_AddCartData.count != 0 {
            var total = 0
            for i in 0..<global.shared.arr_AddCartData.count {
                let qty = global.shared.arr_AddCartData[i].Cart_Qty
                if let val = Int(qty) {
                    total += val
                }
            }
            self.lbl_cartTotal.text = "\(total)"
            self.lbl_TotalProduct.text = "\(total) Product"
        }
    }
    
    
    //MARK:- Button Action
    @IBAction func act_Shop(_ sender: UIButton) {
        let shop = self.storyboard?.instantiateViewController(withIdentifier: "Shop_VC") as! Shop_VC
        self.navigationController?.pushViewController(shop, animated: true)
    }
    
    @IBAction func act_Offers(_ sender: UIButton) {
        let Offers = self.storyboard?.instantiateViewController(withIdentifier: "Offers_VC") as! Offers_VC
        self.navigationController?.pushViewController(Offers, animated: true)
    }
    
    @IBAction func act_Orders(_ sender: UIButton) {
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        if userId != "" {
            let orders = self.storyboard?.instantiateViewController(withIdentifier: "Orders_VC") as! Orders_VC
            self.navigationController?.pushViewController(orders, animated: true)
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
    
    @IBAction func act_buyNow(_ sender: Any) {
        let cartDetails = self.storyboard?.instantiateViewController(withIdentifier: "CartOrderDetails_VC") as! CartOrderDetails_VC
        self.navigationController?.pushViewController(cartDetails, animated: true)
    }

    @IBAction func act_ClearAll(_ sender: UIButton) {
        self.showAlertwithOptions(Title: "Clear Cart", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to remove all item?", completion: { tap in
            if tap{
                //LOgout
                global.shared.arr_AddCartData.removeAll()
                self.call_CartAddAPI()
            } else {
                //do nothing
            }
        })
    }
    
    //MARK:- API Call
    func call_CartAPI() {
        var JsonData_Cart = String()
        do {
            let jsonData = try JSONEncoder().encode(self.arrCartData)
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
        
        WebService.call.POSTT(filePath: global.shared.URL_Cart, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:CartModel = Mapper<CartModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.vw_Msg.isHidden = true
                    if let arr = eventResponseModel.cart_Products, arr.count != 0 {
                        self.arrCartProduct = arr
                        self.tbl_vw.isHidden = false
                        self.vw_buyNow.isHidden = false
                        self.vw_emptyCart.isHidden = true
                        self.tbl_vw.register(UINib(nibName: "Cart_cell", bundle: nil), forCellReuseIdentifier: "cell")
                        self.tbl_vw.register(UINib(nibName: "AddonCart_cell", bundle: nil), forCellReuseIdentifier: "cell1")
                        self.btn_clearAll.isHidden = false
                        self.tbl_vw.delegate = self
                        self.tbl_vw.dataSource = self
                        self.tbl_vw.reloadData()
                    } else {
                        self.btn_clearAll.isHidden = true
                        self.tbl_vw.isHidden = true
                        self.vw_buyNow.isHidden = true
                        self.vw_emptyCart.isHidden = false
                    }
                    if let totalPrice = eventResponseModel.cart_Product_Total {
                        self.lbl_TotalPrice.text = "Total: $" + totalPrice
                    }
                } else {
                    if let arr = eventResponseModel.cart_Products, arr.count != 0 {
                        self.arrCartProduct = arr
                        self.tbl_vw.isHidden = false
                        self.vw_buyNow.isHidden = false
                        self.vw_emptyCart.isHidden = true
                        self.tbl_vw.register(UINib(nibName: "Cart_cell", bundle: nil), forCellReuseIdentifier: "cell")
                        self.tbl_vw.register(UINib(nibName: "AddonCart_cell", bundle: nil), forCellReuseIdentifier: "cell1")
                        self.btn_clearAll.isHidden = false
                        self.tbl_vw.delegate = self
                        self.tbl_vw.dataSource = self
                        self.tbl_vw.reloadData()
                        if let msg = eventResponseModel.message, msg != "" {
                            self.vw_Msg.isHidden = false
                            self.lbl_msg.text = msg
                            self.vw_buyNow.isHidden = true
                        }
                    } else {
                        self.btn_clearAll.isHidden = true
                        self.tbl_vw.isHidden = true
                        self.vw_buyNow.isHidden = true
                        self.vw_emptyCart.isHidden = false
                    }
                }
                
            }
        }) {
            
        }
    }
    
    
    func call_CartAddAPI() {
            
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
        
        WebService.call.POSTT(filePath: global.shared.URL_Cart_Add, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:CartAddModel = Mapper<CartAddModel>().map(JSONObject: result) {
                
                if eventResponseModel.status == "1" {
                    do {
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(arrCartData) {
                            UserDefaults.standard.set(encodedData, forKey: "cartDataList")
                            self.arrCartData = arrCartData
                            if global.shared.arr_AddCartData.count != 0 {
                                var total = 0
                                for i in 0..<global.shared.arr_AddCartData.count {
                                    let qty = global.shared.arr_AddCartData[i].Cart_Qty
                                    if let val = Int(qty) {
                                        total += val
                                    }
                                }
                                self.lbl_cartTotal.text = "\(total)"
                                self.lbl_TotalProduct.text = "\(total) Product"
                            }
                            self.call_CartAPI()
                        } else {
                            print("Encoding failed")
                        }
                    } catch {
                        print("Encoding error: \(error)")
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


extension Cart_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let arr = self.arrCartProduct[indexPath.row].product_Addons, arr.count != 0 {
            if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? AddonCart_cell {
                let data = self.arrCartProduct[indexPath.row]
                var cart_data: CartData?
                var cart_countQty = Int(data.cart_Qty ?? "0") ?? 0
                cell.lbl_Name.text = data.product_Name ?? ""
                cell.lbl_count.text = data.cart_Qty ?? "0"
                cell.lbl_productPrice.text = "$" + (data.product_Price ?? "0")
                cell.vw_cart = self
                if data.cart_Days == "" && (data.cart_Product_Size == " " || data.cart_Product_Size == "") {
                    cell.vw_Sizes.isHidden = true
                    cell.vw_days.isHidden = true
                } else {
                    if let arr = data.product_Size, arr.count != 0 {
                        cell.arr_ProductSize = arr
                        for i in 0..<arr.count {
                            if let days = arr[i].product_Days {
                                if data.cart_Days == days {
                                    cell.arr_ProductDays.append(arr[i])
                                } else {
                                    if cell.arr_ProductDays.count != 0 {
                                        let DaysExists = cell.arr_ProductDays.contains { person in
                                            return person.product_Days == days
                                        }
                                        if !DaysExists {
                                            cell.arr_ProductDays.append(arr[i])
                                        }
                                    }
                                }
                            } else {
                                cell.arr_ProductSizes = arr
                            }
                        }
                        if cell.arr_ProductDays.count != 0 {
                            let filteredData = arr.filter { Data in
                                return Data.product_Days == (cell.arr_ProductDays[0].product_Days ?? "")
                            }
                            cell.arr_ProductSizes = filteredData
                        }
                        print("Product Days : \(cell.arr_ProductDays)")
                        print("Product Sizes : \(cell.arr_ProductSizes)")
                        if data.cart_Days != "" {
                            cell.vw_days.isHidden = false
                            if cell.arr_ProductDays.count == 1 {
                                if let days = cell.arr_ProductDays[0].product_Days, days != "" {
                                    cell.lbl_days.text = days
                                    cell.vw_day.isHidden = true
                                } else {
                                    cell.vw_days.isHidden = true
                                }
                            } else if cell.arr_ProductDays.count != 0 {
                                cell.lbl_days.text = ""
                                cell.vw_day.isHidden = false
                                cell.SetPickerVWDays()
                            } else {
                                cell.vw_days.isHidden = true
                            }
                        } else {
                            cell.vw_days.isHidden = true
                        }
                        if data.cart_Product_Size != "" || data.cart_Product_Size != " " {
                            cell.vw_Sizes.isHidden = false
                            if cell.arr_ProductSizes.count == 1 {
                                if let size = cell.arr_ProductSizes[0].product_Size, size != "" && size != " " {
                                    cell.lbl_size.text = size
                                    cell.vw_size.isHidden = true
                                } else {
                                    cell.vw_Sizes.isHidden = true
                                }
                            } else if cell.arr_ProductSizes.count != 0  {
                                cell.lbl_size.text = data.cart_Product_Size
                                cell.vw_size.isHidden = false
                                cell.SetPickerVWSizes()
                            } else {
                                cell.vw_Sizes.isHidden = true
                            }
                        }
                    }
                }
                var arrAddons: [Addons]
                if let arr1 = self.arrCartProduct[indexPath.row].cart_Addons_Price, arr1.count != 0 {
                    arrAddons = arr1
                    if arrAddons.count != 0 {
                        cell.tbl_addon.isHidden = false
                        cell.lbl_Addon.isHidden = false
                        cell.lbl_total.isHidden = false
                        cell.lbl_Addon.text = "Addon:"
                        cell.lbl_total.text = "Total: $" + (data.product_Addon_Price ?? "0")
                        cell.arr_addon = arrAddons
                        cell.tbl_addon_height_const.constant = CGFloat(cell.arr_addon.count*30)
                        cell.setTableView()
                    }
                } else {
                    cell.tbl_addon.isHidden = true
                    cell.tbl_addon_height_const.constant = 0
                    cell.lbl_Addon.text = ""
                    cell.lbl_Addon.isHidden = true
                    cell.lbl_total.isHidden = true
                    cell.lbl_total.text = ""
                }
                cell.lbl_TotalPrice.text = "$" + (data.cart_Product_Price ?? "0")
                if let arr = data.product_Image, arr.count != 0 {
                    let img = arr[0]
                    if img != "" {
                        cell.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                            // Your code inside completion block
                            if (error != nil) {
                                // Failed to load image
                                cell.img_vw.image = UIImage(named: "ProductDemo")
                            } else {
                                // Successful in loading image
                                cell.img_vw.image = image
                            }
                        }
                    }
                }
                cell.Act_cancel = {
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
//                                let count = global.shared.arr_AddCartData[index].Cart_Qty
//                                if let total = Int(count) {
//                                    cart_countQty -= total
//                                }
                                global.shared.arr_AddCartData.remove(at: index)
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_ChangeDays = { str in
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Days = "\(str)"
                            }
                        } else {
//                            cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
//                            if let data = cart_data {
//                                global.shared.arr_AddCartData.append(data)
//                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_ChangeSize = { str in
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Product_Size = "\(str)"
                            }
                        } else {
//                            cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
//                            if let data = cart_data {
//                                global.shared.arr_AddCartData.append(data)
//                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_AddPlus = {
                    cart_countQty += 1
                    cell.lbl_count.text = "\(cart_countQty)"
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 {
                            var joinedIds = ""
                            if let arr1 = self.arrCartProduct[indexPath.row].cart_Addons_Price, arr1.count != 0 {
                                joinedIds = arr1.compactMap { $0.addon_Id }.joined(separator: ",")
                            }
                            print("Join \(joinedIds)");
                            if let index = global.shared.arr_AddCartData.firstIndex(where: {
                                let cartAddonSet = Set($0.Cart_Addons.components(separatedBy: ","))
                                let joinedIdSet = Set(joinedIds.components(separatedBy: ","))
                                return cartAddonSet == joinedIdSet
                            }) {
                                print("Index \(index)");
                                global.shared.arr_AddCartData[indexPath.row].Cart_Qty = "\(cart_countQty)"
                            }
                        } else {
                            cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
                            if let data = cart_data {
                                global.shared.arr_AddCartData.append(data)
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_MinusCart = {
                    if cart_countQty != 0 {
                        cart_countQty -= 1
                    } else {
                        cart_countQty = 0
                    }
                    cell.lbl_count.text = "\(cart_countQty)"
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 {
                            var joinedIds = ""
                            if let arr1 = self.arrCartProduct[indexPath.row].cart_Addons_Price, arr1.count != 0 {
                                joinedIds = arr1.compactMap { $0.addon_Id }.joined(separator: ",")
                            }
                            print("Join \(joinedIds)");
                            if cart_countQty == 0 {
                                if let index = global.shared.arr_AddCartData.firstIndex(where: {
                                    let cartAddonSet = Set($0.Cart_Addons.components(separatedBy: ","))
                                    let joinedIdSet = Set(joinedIds.components(separatedBy: ","))
                                    return cartAddonSet == joinedIdSet
                                }) {
                                    print("Index \(index)");
                                    global.shared.arr_AddCartData.remove(at: indexPath.row)
                                }
                            } else {
                                if let index = global.shared.arr_AddCartData.firstIndex(where: {
                                    let cartAddonSet = Set($0.Cart_Addons.components(separatedBy: ","))
                                    let joinedIdSet = Set(joinedIds.components(separatedBy: ","))
                                    return cartAddonSet == joinedIdSet
                                }) {
                                    print("Index \(index)");
                                    global.shared.arr_AddCartData[index].Cart_Qty = "\(cart_countQty)"
                                }
                            }
                        } else {
                            if cart_countQty == 0 {
                                if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                    global.shared.arr_AddCartData.remove(at: index)
                                }
                            } else {
                                cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
                                if let data = cart_data {
                                    global.shared.arr_AddCartData.append(data)
                                }
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                return cell
            }
        } else {
            if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cart_cell {
                let data = self.arrCartProduct[indexPath.row]
                var cart_data: CartData?
                var cart_countQty = Int(data.cart_Qty ?? "0") ?? 0
                cell.lbl_Name.text = data.product_Name ?? ""
                cell.lbl_count.text = data.cart_Qty ?? "0"
                cell.lbl_productPrice.text = "$" + (data.product_Price ?? "0")
                cell.vw_cart = self
                if let special = data.is_Special, special == "1" {
                    if data.cart_Days == "" && (data.cart_Product_Size == " " || data.cart_Product_Size == "") {
                        cell.vw_Sizes.isHidden = true
                        cell.vw_days.isHidden = true
                    } else {
                        if let arr = data.product_Size, arr.count != 0 {
                            cell.arr_ProductSize = arr
                            if data.cart_Days != "" {
                                let filteredData = arr.filter { Data in
                                    return Data.product_Size == data.cart_Product_Size
                                }
                                cell.arr_ProductDays = filteredData
                                print("Product Days : \(cell.arr_ProductDays)")
                                cell.vw_days.isHidden = false
                                if cell.arr_ProductDays.count == 1 {
                                    if let days = cell.arr_ProductDays[0].product_Days, days != "" {
                                        cell.lbl_days.text = days
                                        cell.vw_day.isHidden = true
                                    } else {
                                        cell.vw_days.isHidden = true
                                    }
                                } else {
                                    cell.lbl_days.text = ""
                                    cell.vw_day.isHidden = false
                                    cell.SetPickerVWDays()
                                }
                            }
                            if data.cart_Product_Size != "" || data.cart_Product_Size != " " {
                                let filteredData = arr.filter { Data in
                                    return Data.product_Days == data.cart_Days
                                }
                                cell.arr_ProductSizes = filteredData
                                print("Product Sizes : \(cell.arr_ProductSizes)")
                                cell.vw_Sizes.isHidden = false
                                if cell.arr_ProductSizes.count == 1 {
                                    if let size = cell.arr_ProductSizes[0].product_Size, size != "" && size != " " {
                                        cell.vw_Sizes_height_const.constant = 25.0
                                        cell.lbl_size.text = size
                                        cell.vw_size.isHidden = true
                                        cell.vw_size_heigth_const.constant = 0.0
                                    } else {
                                        cell.vw_Sizes.isHidden = true
                                        cell.vw_Sizes_height_const.constant = 0.0
                                    }
                                } else {
                                    cell.lbl_size.text = ""
                                    cell.vw_size.isHidden = false
                                    cell.vw_size_heigth_const.constant = 35.0
                                    cell.vw_Sizes_height_const.constant = 35.0
                                    cell.SetPickerVWSizes()
                                }
                            }
                        }
                    }
                } else {
                    cell.vw_days.isHidden = true
                    if data.cart_Product_Size != "" && data.cart_Product_Size != " " {
                        if let arr = data.product_Size, arr.count != 0 {
                            cell.arr_ProductSizes = arr
                            print("Product Sizes : \(cell.arr_ProductSizes)")
                            cell.vw_Sizes.isHidden = false
                            if cell.arr_ProductSizes.count == 1 {
                                if let size = cell.arr_ProductSizes[0].product_Size, size != "" && size != " " {
                                    cell.lbl_size.text = size
                                    cell.vw_size.isHidden = true
                                } else {
                                    cell.vw_Sizes.isHidden = true
                                }
                            } else if cell.arr_ProductSizes.count != 0 {
                                cell.lbl_size.text = data.cart_Product_Size
                                cell.vw_size.isHidden = false
                                cell.SetPickerVWSizes()
                            }  else {
                                cell.lbl_size.text = ""
                                cell.vw_size.isHidden = false
                                cell.SetPickerVWSizes()
                            }
                        }
                    } else {
                        cell.vw_Sizes.isHidden = true
                    }
                }
                cell.lbl_total.text = "$" + (data.cart_Product_Price ?? "0")
                if let arr = data.product_Image, arr.count != 0 {
                    let img = arr[0]
                    if img != "" {
                        cell.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                            // Your code inside completion block
                            if (error != nil) {
                                // Failed to load image
                                cell.img_vw.image = UIImage(named: "ProductDemo")
                            } else {
                                // Successful in loading image
                                cell.img_vw.image = image
                            }
                        }
                    }
                }
                cell.Act_cancel = {
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
//                                let count = global.shared.arr_AddCartData[index].Cart_Qty
//                                if let total = Int(count) {
//                                    cart_countQty -= total
//                                }
                                global.shared.arr_AddCartData.remove(at: index)
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_ChangeDays = { str in
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Days = "\(str)"
                            }
                        } else {
//                            cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
//                            if let data = cart_data {
//                                global.shared.arr_AddCartData.append(data)
//                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_ChangeSize = { str in
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Product_Size = "\(str)"
                            }
                        } else {
//                            cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
//                            if let data = cart_data {
//                                global.shared.arr_AddCartData.append(data)
//                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_AddPlus = {
                    cart_countQty += 1
                    cell.lbl_count.text = "\(cart_countQty)"
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Qty = "\(cart_countQty)"
                            }
                        } else {
                            cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
                            if let data = cart_data {
                                global.shared.arr_AddCartData.append(data)
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                cell.Act_MinusCart = {
                    if cart_countQty != 0 {
                        cart_countQty -= 1
                    } else {
                        cart_countQty = 0
                    }
                    cell.lbl_count.text = "\(cart_countQty)"
                    if let id = data.product_Id {
                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if cart_countQty == 0 {
                                if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                    global.shared.arr_AddCartData.remove(at: index)
                                }
                            } else {
                                if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                    global.shared.arr_AddCartData[index].Cart_Qty = "\(cart_countQty)"
                                }
                            }
                        } else {
                            if cart_countQty == 0 {
                                if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                    global.shared.arr_AddCartData.remove(at: index)
                                }
                            } else {
                                cart_data = CartData(productId: data.product_Id ?? "", cartQty: "\(cart_countQty)", cartProductSize: data.cart_Product_Size ?? "0")
                                if let data = cart_data {
                                    global.shared.arr_AddCartData.append(data)
                                }
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}
