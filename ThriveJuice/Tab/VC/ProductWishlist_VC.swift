//
//  ProductWishlist_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 16/08/23.
//

import UIKit
import ObjectMapper


class ProductWishlist_VC: UIViewController {

    @IBOutlet weak var collect_vw: UICollectionView!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    @IBOutlet weak var vw_EmptyData: UIView!
    @IBOutlet weak var btn_clearAll: UIButton!
    
    fileprivate var activityIndicator_coll: LoadMoreActivityIndicator!
    
    var arr_Product: [Products] = []
    var str_offset = "0"
    var offset = 0
    var isLoading = false
    var hasMoreData = true
//    var Totalcart = 0
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collect_vw.register(UINib(nibName: "Product_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collect_vw.dataSource = self
        self.collect_vw.delegate = self
        activityIndicator_coll = LoadMoreActivityIndicator(scrollView: collect_vw, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProductAPI()
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
    
    @IBAction func act_clearAll(_ sender: UIButton) {
        
        self.showAlertwithOptions(Title: "Clear Whistlist", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to remove all item?", completion: { tap in
            if tap{
                //LOgout
                self.call_ClearAllWishlistAPI()
            } else {
                //do nothing
            }
        })
    }
    
    func fetchMoreData() {
        guard !isLoading && hasMoreData else {
            return
        }
        isLoading = true
        call_ProductAPI()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if contentOffsetY + scrollViewHeight >= contentHeight - scrollViewHeight {
            fetchMoreData()
        }
    }
    
    //MARK:- API Call
    func call_ProductAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Offset"] = self.str_offset
        paramer["Type"] = "Wishlist"
        
        WebService.call.POSTT(filePath: global.shared.URL_Products, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProductModel = Mapper<ProductModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.products, arr.count != 0 {
                    if offset == 0 {
                        self.arr_Product = arr
                    } else {
                        self.arr_Product += arr
                    }
                    if let limit = eventResponseModel.limit {
                        offset += limit
                    }
                    self.isLoading = false
                    self.str_offset = "\(offset)"
                    // Append the newData to your existing data source
                    self.collect_vw.isHidden = false
                    self.vw_EmptyData.isHidden = true
                    self.btn_clearAll.isHidden = false
                    self.collect_vw.reloadData()
                } else {
                
                    if offset == 0 {
                        self.collect_vw.isHidden = true
                        self.vw_EmptyData.isHidden = false
                        self.btn_clearAll.isHidden = true
                    
                    } else {
                        self.collect_vw.isHidden = false
                        self.vw_EmptyData.isHidden = true
                        self.btn_clearAll.isHidden = false
                    }
                    self.hasMoreData = false
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
                    self.offset = 0
                    self.str_offset = "\(self.offset)"
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
    
    
    func call_ClearAllWishlistAPI() {
        
        var paramer: [String: Any] = [:]
        paramer["Product_Id"] = "0"
        paramer["Type"] = "Clear_All"
        
        WebService.call.POSTT(filePath: global.shared.URL_Add_To_Wishlist, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:StatusModel = Mapper<StatusModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    self.offset = 0
                    self.str_offset = "\(self.offset)"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProductWishlist_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            var cart_data: CartData?
            var Cellcart = 0
            if let arr = dict.product_Size, arr.count != 0 {
                if arr.count == 1 {
                    cell1.lbl_price.text = "$" + (arr[0].product_Price ?? "0")
                    productSize = arr[0].product_Size ?? "0"
                } else {
                    cell1.lbl_price.text = "From $" + (arr[0].product_Price ?? "0")
                    productSize = arr[0].product_Size ?? "0"
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
                                cell1.vw_cart.isHidden = false
                                Cellcart += 1
                                cell1.lbl_cart.text = "\(Cellcart)"
                                if let id = dict.product_Id {
                                    let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                                    if arrCart.count != 0 && arrCart.count == 1 {
                                        if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                            global.shared.arr_AddCartData[index].Cart_Qty = "\(Cellcart)"
                                        }
                                    } else {
                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                        if let data = cart_data {
                                            global.shared.arr_AddCartData.append(data)
                                        }
                                    }
                                }
                                self.call_CartAddAPI()
                                print("Arr data \(global.shared.arr_AddCartData)")
                                print("Arr data count \(global.shared.arr_AddCartData.count)")
                             /*   if arr.count == 1 {
                                    cell1.vw_cart.isHidden = false
                                    Cellcart += 1
                                    cell1.lbl_cart.text = "\(Cellcart)"
                                    if let id = dict.product_Id {
                                        let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                                        if arrCart.count != 0 && arrCart.count == 1 {
                                            if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                                global.shared.arr_AddCartData[index].Cart_Qty = "\(Cellcart)"
                                            }
                                        } else {
                                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                            if let data = cart_data {
                                                global.shared.arr_AddCartData.append(data)
                                            }
                                        }
                                    }
                                    self.call_CartAddAPI()
                                    print("Arr data \(global.shared.arr_AddCartData)")
                                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                                } else {
                                    let details = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetails_VC") as! ProductDetails_VC
                                    details.ProductId = self.arr_Product[indexPath.item].product_Id ?? ""
                                    self.navigationController?.pushViewController(details, animated: true)
                                } */
                            } else {
                                self.showAlertToast(message: "Only {\(stock)} available at this moment")
                            }
                        }
                        
                    }
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
                            Cellcart += 1
                            cell1.lbl_cart.text = "\(Cellcart)"
                            if let id = dict.product_Id {
                                let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                                if arrCart.count != 0 && arrCart.count == 1 {
                                    if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                        global.shared.arr_AddCartData[index].Cart_Qty = "\(Cellcart)"
                                    }
                                } else {
                                    cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                    if let data = cart_data {
                                        global.shared.arr_AddCartData.append(data)
                                    }
                                }
                            }
                            self.call_CartAddAPI()
                        } else {
                            self.showAlertToast(message: "Only {\(stock)} available at this moment")
                        }
                    }
                }
                print("Arr data \(global.shared.arr_AddCartData)")
                print("Arr data count \(global.shared.arr_AddCartData.count)")
            }
            cell1.Act_MinusCart = {
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
                    let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
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
            return cell1
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 42) / 2 // Adjust the width according to your needs
        let height = 270.0// Calculate the height of your cell
                
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetails_VC") as! ProductDetails_VC
        details.ProductId = self.arr_Product[indexPath.item].product_Id ?? ""
        self.navigationController?.pushViewController(details, animated: true)
    }
    
}
