//
//  SpecialProduct_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 16/10/23.
//

import UIKit
import ObjectMapper

class SpecialProduct_VC: UIViewController {

    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var collect_vw: UICollectionView!
    @IBOutlet weak var collect_height_const: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    
    var CategoryName = String()
    var categoryId = String()
    var arr_Product: [Products] = []
    var arr_Faq: [FAQ] = []
//    var Totalcart = 0
    var selectFaqId = String()
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_title.text = self.CategoryName
        self.collect_vw.register(UINib(nibName: "Product_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collect_vw.dataSource = self
        self.collect_vw.delegate = self
    
        self.tbl_vw.register(UINib(nibName: "Faq_cell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        self.lbl_title.text = self.CategoryName
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProductAPI()
        self.call_FAQAPI()
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
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    //MARK:- API Call
    func call_ProductAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Type"] = "Category"
        paramer["Category_Id"] = self.categoryId
        
        WebService.call.POSTT(filePath: global.shared.URL_Products, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProductModel = Mapper<ProductModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.products, arr.count != 0 {
                    self.arr_Product = arr
                    self.collect_vw.isHidden = false
                    self.collect_height_const.constant = CGFloat(self.arr_Product.count*280)
                    self.collect_vw.reloadData()
                } else {
                    var OrderType = String()
                    var ordertype = String()
                    if UserDefaults.standard.object(forKey: "orderType") != nil {
                        OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
                    }
                    if OrderType == "Local_Delivery" {
                        ordertype = "Local Delivery"
                    } else if OrderType == "Store_Pickup" {
                        ordertype = "Store Pickup"
                    } else if OrderType == "Right_Away" {
                        ordertype = "Pickup Today"
                    }
                    self.showAlertToast(message: "\(CategoryName) doesn't have products in \(ordertype)")
                    self.collect_vw.isHidden = true
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
                self.collect_vw.reloadData()
                if eventResponseModel.status == "1" {
                    do {
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(arrCartData) {
                            UserDefaults.standard.set(encodedData, forKey: "cartDataList")
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
    
    func call_AddWishlistAPI(productId: String) {
        
        var paramer: [String: Any] = [:]
        paramer["Product_Id"] = productId
        
        WebService.call.POSTT(filePath: global.shared.URL_Add_To_Wishlist, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:StatusModel = Mapper<StatusModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        self.call_ProductAPI()
                    } else if status == "2" {
                        self.call_ProductAPI()
                    }
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_FAQAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Category_Id"] = self.categoryId
        
        WebService.call.POSTT(filePath: global.shared.URL_FAQ, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:FAQResponse = Mapper<FAQResponse>().map(JSONObject: result) {
                if let arr = eventResponseModel.fAQ, arr.count != 0 {
                    self.arr_Faq = arr
                    self.tbl_vw.isHidden = false
                    self.tbl_height_const.constant = CGFloat(self.arr_Faq.count*37)
                    self.tbl_vw.reloadData()
                } else {
                    self.tbl_vw.isHidden = true
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


extension SpecialProduct_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_Product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell1 = self.collect_vw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Product_cell {
            let dict = self.arr_Product[indexPath.row]
            cell1.lbl_ProductName.text = dict.product_Name
            var productSize = String()
            var productDays = String()
            var cart_data: CartData?
            var Cellcart = 0
            if let arr = dict.product_Size, arr.count != 0 {
                if arr.count == 1 {
                    cell1.lbl_price.text = "$" + (arr[0].product_Price ?? "0")
                    productSize = arr[0].product_Size ?? "0"
                    productDays = arr[0].product_Days ?? ""
                } else {
                    cell1.lbl_price.text = "From $" + (arr[0].product_Price ?? "0")
                    productSize = arr[0].product_Size ?? "0"
                    productDays = arr[0].product_Days ?? ""
                }
                if let stock = arr[0].available_Stock {
                    if stock == 0 {
                        cell1.btn_AddToCart.setTitle("Out of Stock", for: .normal)
                        cell1.btn_AddToCart.backgroundColor = UIColor(named: "Red")
                        cell1.btn_AddToCart.isUserInteractionEnabled = false
                    } else {
                        cell1.btn_AddToCart.setTitle("Add To Cart", for: .normal)
                        cell1.btn_AddToCart.backgroundColor = UIColor(named: "AccentColor")
                        cell1.btn_AddToCart.isUserInteractionEnabled = true
                    }
                }
            }
            if let isWishlist = dict.is_Wishlist {
                if isWishlist {
                    cell1.btn_like.setImage(UIImage(named: "Like"), for: .normal)
                } else {
                    cell1.btn_like.setImage(UIImage(named: "Unlike"), for: .normal)
                }
            }
            cell1.Act_Like = {
                if let id = dict.product_Id {
                    self.call_AddWishlistAPI(productId: id)
                }
            }
            if let arr = dict.product_Image, arr.count != 0 {
                let img = arr[0]
                if img != "" {
                    cell1.img_height_const.constant = 155.0
                    cell1.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                        // Your code inside completion block
                        if (error != nil) {
                            // Failed to load image
                            cell1.img_vw.image = UIImage(named: "ProductDemo")
                        } else {
                            // Successful in loading image
                            cell1.img_vw.image = image
                            
                        }
                    }
                }
            }
            let arr_cart = global.shared.arr_AddCartData
            if arr_cart.count != 0 {
                if let id = dict.product_Id {
                    let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                    if arrCart.count != 0 {
                        cell1.vw_cart.isHidden = false
                        Cellcart = Int(arrCart[0].Cart_Qty) ?? 0
                        cell1.lbl_cart.text = "\(Cellcart)"
                    } else {
                        cell1.vw_cart.isHidden = true
                    }
                }
            }
            cell1.Act_AddToCart = {
                var userId = String()
                if UserDefaults.standard.object(forKey: "u_id") != nil {
                    userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
                }
                if userId != "" {
                    if let arr = dict.product_Size, arr.count != 0 {
                        if let stock = arr[0].available_Stock {
                            if stock != 0 {
                                
                            } else {
                                self.showAlertToast(message: "Only {\(stock)} available at this moment")
                            }
                        }
                    }
                    cell1.vw_cart.isHidden = false
                    Cellcart += 1
                    cell1.lbl_cart.text = "\(Cellcart)"
                    if let id = dict.product_Id {
                        var arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                        if arrCart.count != 0 && arrCart.count == 1 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Qty = "\(Cellcart)"
                            }
                        } else {
                            if let Special = dict.is_Special, Special == "1" {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize, cartDays: productDays)
                                if let data = cart_data {
                                    global.shared.arr_AddCartData.append(data)
                                }
                            } else {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                if let data = cart_data {
                                    global.shared.arr_AddCartData.append(data)
                                }
                            }
                        }
                    }
                    self.call_CartAddAPI()
                    print("Arr data \(global.shared.arr_AddCartData)")
                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                } else {
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
                    navigation.modalPresentationStyle = .fullScreen
                    self.present(navigation, animated: true)
                }
            }
            cell1.Act_AddPlus = {
                if let arr = dict.product_Size, arr.count != 0 {
                    if let stock = arr[0].available_Stock {
                        if stock != 0 {
                            
                        } else {
                            self.showAlertToast(message: "Only {\(stock)} available at this moment")
                        }
                    }
                }
                Cellcart += 1
                cell1.lbl_cart.text = "\(Cellcart)"
                if let id = dict.product_Id {
                    var arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                    if arrCart.count != 0 && arrCart.count == 1 {
                        if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                            global.shared.arr_AddCartData[index].Cart_Qty = "\(Cellcart)"
                        }
                    } else {
                        if let Special = dict.is_Special, Special == "1" {
                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize, cartDays: productDays)
                            if let data = cart_data {
                                global.shared.arr_AddCartData.append(data)
                            }
                        } else {
                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
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
            cell1.Act_MinusCart = {
//                self.Totalcart -= 1
                if Cellcart != 0 {
                    Cellcart -= 1
                } else {
                    Cellcart = 0
                }
                if Cellcart == 0 {
                    cell1.vw_cart.isHidden = true
                } else {
                    cell1.lbl_cart.text = "\(Cellcart)"
                }
                if let id = dict.product_Id {
                    var arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                    if arrCart.count != 0 && arrCart.count == 1 {
                        if Cellcart == 0 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData.remove(at: index)
                            }
                        } else {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData[index].Cart_Qty = "\(Cellcart)"
                            }
                        }
                    } else {
                        if Cellcart == 0 {
                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                global.shared.arr_AddCartData.remove(at: index)
                            }
                        } else {
                            if let Special = dict.is_Special, Special == "1" {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize, cartDays: productDays)
                                if let data = cart_data {
                                    global.shared.arr_AddCartData.append(data)
                                }
                            } else {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                if let data = cart_data {
                                    global.shared.arr_AddCartData.append(data)
                                }
                            }
                        }
                    }
                }
                self.call_CartAddAPI()
                print("Arr data \(global.shared.arr_AddCartData)")
                print("Arr data count \(global.shared.arr_AddCartData.count)")
            }
            return cell1
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40 // Adjust the width according to your needs
        let height = 270.0// Calculate the height of your cell
                
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetails_VC") as! ProductDetails_VC
        details.ProductId = self.arr_Product[indexPath.item].product_Id ?? ""
        self.navigationController?.pushViewController(details, animated: true)
    }

    
}


extension SpecialProduct_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_Faq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Faq_cell
        let data = self.arr_Faq[indexPath.row]
        cell.lbl_title.text = data.faq_Question
        cell.vw_answer.isHidden = true
        if let id = self.arr_Faq[indexPath.row].faq_Id {
            if self.selectFaqId == id {
                cell.btn_arrow.setImage(UIImage(named: "up-arrow"), for: .normal)
                cell.lbl_answer.numberOfLines = 0
                cell.vw_answer.isHidden = false
                let labelText = "\n" + (data.faq_Answer ?? "") + "\n"
                cell.lbl_answer.text = labelText
            } else {
                cell.btn_arrow.setImage(UIImage(named: "down-arrow"), for: .normal)
                cell.lbl_answer.text = ""
                cell.vw_answer.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tbl_vw.cellForRow(at: indexPath) as? Faq_cell {
            if let id = self.arr_Faq[indexPath.row].faq_Id {
                if self.selectFaqId == id {
                    self.selectFaqId = ""
                    let labelText = self.arr_Faq[indexPath.row].faq_Answer ?? ""
                    let labelWidth: CGFloat = cell.lbl_answer.bounds.width
                    let labelHeight = cell.lbl_answer.heightForLabel(text: labelText, width: labelWidth)
                    self.tbl_height_const.constant = CGFloat(self.arr_Faq.count*37)
                    self.tbl_vw.reloadData()
                    print("Label height: \(labelHeight)")
                } else {
                    self.selectFaqId = id
                    let labelText = self.arr_Faq[indexPath.row].faq_Answer ?? ""
                    let labelWidth: CGFloat = cell.lbl_answer.bounds.width
                    let labelHeight = cell.lbl_answer.heightForLabel(text: labelText, width: labelWidth)
                    let heights = CGFloat(self.arr_Faq.count*37)
                    self.tbl_height_const.constant = heights+labelHeight
                    self.tbl_vw.reloadData()
                    print("Label height: \(labelHeight)")
                }
            }
        }
    }
    
}
