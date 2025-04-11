//
//  Shop_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 04/08/23.
//

import UIKit
import MMBannerLayout
import ObjectMapper


class Shop_VC: UIViewController {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collect_category: UICollectionView!
    @IBOutlet weak var collect_category_height_const: NSLayoutConstraint!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_notifyCount: UILabel!
    @IBOutlet weak var lbl_orderType: UILabel!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    
    
    var arr_banner: [Banners] = []
    var arr_Category: [Categories] = []
    var arr_RecommendProductList: [ProductsList] = []
    var arr_TrendingProductList: [ProductsList] = []
    
    var arrCartData: [CartData] = []
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedData = UserDefaults.standard.data(forKey: "cartDataList") {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([CartData].self, from: savedData) {
                // Use the decodedItems array
                print(decodedItems)
                global.shared.arr_AddCartData = decodedItems
            } else {
                print("Decoding failed")
            }
        } else {
            print("No data found in UserDefaults")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(OrderTypeRedirect),name: NSNotification.Name ("OrderTypeSelect"),object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_DashboardAPI()
        self.call_ProfileAPI()
        
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        if userId != "" {
            
        }
        if OrderType == "" {
//            let filter = self.storyboard?.instantiateViewController(withIdentifier: "SelectOrderType_VC") as! SelectOrderType_VC
//            filter.modalPresentationStyle = .overFullScreen
//            self.present(filter, animated: true)
//            OrderType = "Right_Away"
            UserDefaults.standard.set(OrderType, forKey: "orderType")
            print("OrderType:- \(OrderType)")
            self.lbl_orderType.text = OrderType
        } else {
            if OrderType == "Right_Away"{
                self.lbl_orderType.text = "Pickup Today"
            }else if OrderType == "Store_Pickup"{
                self.lbl_orderType.text = "Store Pickup"
            }else if OrderType == "Local_Delivery"{
                self.lbl_orderType.text = "Local Delivery"
            }
        }
        self.call_StoreListAPI()
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
    
    @objc func OrderTypeRedirect(_ notification: Notification){
           //.... code process
        print(notification.userInfo?["userInfo"] as? [String: Any] ?? [:])
        if let info = notification.userInfo?["OrderType"] as? Bool {
            if info {
                var OrderType = String()
                if UserDefaults.standard.object(forKey: "orderType") != nil {
                    OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
                }
                if OrderType == "" {
                    let filter = self.storyboard?.instantiateViewController(withIdentifier: "SelectOrderType_VC") as! SelectOrderType_VC
                    filter.modalPresentationStyle = .overFullScreen
                    self.present(filter, animated: true)
                } else {
                    if OrderType == "Local_Delivery" {
                        self.lbl_orderType.text = "Local Delivery"
                    } else if OrderType == "Store_Pickup" {
                        self.lbl_orderType.text = "Store Pickup"
                    } else if OrderType == "Right_Away" {
                        self.lbl_orderType.text = "Pickup Today"
                    }
                }
            }
        }
    }
    
    
    //MARK:- Button Action
    @IBAction func act_Offers(_ sender: UIButton) {
        let offers = self.storyboard?.instantiateViewController(withIdentifier: "Offers_VC") as! Offers_VC
        self.navigationController?.pushViewController(offers, animated: true)
    }
    
    @IBAction func act_Switch(_ sender: UIButton) {
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
//        var userId = String()
//        if UserDefaults.standard.object(forKey: "u_id") != nil {
//            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
//        }
//        if userId != "" {
//
//        } else {
//            let sb = UIStoryboard(name: "Main", bundle:nil)
//            let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
//            navigation.modalPresentationStyle = .fullScreen
//            self.present(navigation, animated: true)
//        }
        let filter = self.storyboard?.instantiateViewController(withIdentifier: "SelectOrderType_VC") as! SelectOrderType_VC
        filter.modalPresentationStyle = .overFullScreen
        self.present(filter, animated: true)
    }
    
    @IBAction func act_switchStore(_ sender: UIButton) {
        let store = self.storyboard?.instantiateViewController(withIdentifier: "StoreList_VC") as! StoreList_VC
        self.navigationController?.pushViewController(store, animated: true)
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
    
    @IBAction func act_notification(_ sender: UIButton) {
        let notification = self.storyboard?.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    @IBAction func act_Search(_ sender: UIButton) {
        let Search = self.storyboard?.instantiateViewController(withIdentifier: "Search_VC") as! Search_VC
        self.navigationController?.pushViewController(Search, animated: true)
    }
    
    
    //MARK:- API Call
    func call_DashboardAPI() {
            
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Dashboard, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:DashboardModel = Mapper<DashboardModel>().map(JSONObject: result) {
                if let banner = eventResponseModel.banners, banner.count != 0 {
                    self.arr_banner = banner
                    self.view.layoutIfNeeded()
                    self.collection.showsHorizontalScrollIndicator = false
                    if let layout = self.collection.collectionViewLayout as? MMBannerLayout {
                        layout.itemSpace = 0
                        layout.itemSpace = 0
                        layout.itemSize = self.collection.frame.insetBy(dx: 40, dy: 0).size
                        layout.minimuAlpha = 0.4
                    }
                    (self.collection.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
                    (self.collection.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: false, completed: nil)
                    (self.collection.collectionViewLayout as? MMBannerLayout)?.angle = CGFloat(30.0)
                    self.collection.reloadData()
                }
                if let category = eventResponseModel.categories, category.count != 0 {
                    self.arr_Category = category
                    self.collect_category.register(UINib(nibName: "Category_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
                    self.collect_category.delegate = self
                    self.collect_category.dataSource = self
                    self.collect_category_height_const.constant = 130.0
                }
                var tblHeight = 0.0
                if let recommendPro = eventResponseModel.recommendProducts, recommendPro.count != 0 {
                    self.arr_RecommendProductList = recommendPro
                    tblHeight += 310
                }
                if let trendingPro = eventResponseModel.trendingProducts, trendingPro.count != 0 {
                    self.arr_TrendingProductList = trendingPro
                    tblHeight += 310
                }
                self.tbl_vw.register(UINib(nibName: "Product_ListCell", bundle: nil), forCellReuseIdentifier: "cell")
                self.tbl_vw.delegate = self
                self.tbl_vw.dataSource = self
                self.tbl_height_const.constant = tblHeight
                self.tbl_vw.reloadData()
            }
        }) {
            
        }
            
    }
    
    
    func call_CartAddAPI() {
            
        self.arrCartData = global.shared.arr_AddCartData
        var JsonData_Cart = String()
        do {
            let jsonData = try JSONEncoder().encode(self.arrCartData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonData)
            print(jsonString)
            JsonData_Cart = jsonString
        } catch { print(error) }
        
        var paramer: [String: Any] = [:]
        paramer["Cart_Data"] = JsonData_Cart
        
        WebService.call.POSTT(filePath: global.shared.URL_Cart_Add, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:CartAddModel = Mapper<CartAddModel>().map(JSONObject: result) {
                if eventResponseModel.status == "1" {
                    self.tbl_vw.reloadData()
                    do {
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(self.arrCartData) {
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
    
    
    func call_ProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let dict = eventResponseModel.user {
                    self.lbl_name.text = "Hi, " + (dict.name ?? "")
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_StoreListAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Stores, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:StoreList = Mapper<StoreList>().map(JSONObject: result) {
                if let selected = eventResponseModel.selected_Store_Id, selected != "" {
                    UserDefaults.standard.setValue(selected, forKey: "SelectedStoreId")
                    if let arr = eventResponseModel.stores, arr.count != 0 {
                        for i in 0..<arr.count {
                            if let id = arr[i].user_Id {
                                if selected == id {
                                    self.lbl_address.text = arr[i].name ?? ""
                                }
                            }
                        }
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
                        self.call_DashboardAPI()
                    } else if status == "2" {
                        self.call_DashboardAPI()
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


extension Shop_VC: BannerLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, focusAt indexPath: IndexPath?) {
//        print("Focus At \(String(describing: indexPath))")
    }
}

extension Shop_VC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.collection {
            count = self.arr_banner.count
        } else if collectionView == self.collect_category {
            count = self.arr_Category.count
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collection, let cell = self.collection.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            let dict = self.arr_banner[indexPath.item]
            if let img = dict.banner_Image, img != "" {
                cell.imgView.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                    // Your code inside completion block
                    if (error != nil) {
                        // Failed to load image
                        cell.imgView.image = UIImage(named: "Banner")
                    } else {
                        // Successful in loading image
                        cell.imgView.image = image
                    }
                }
            }
            return cell
        } else if collectionView == self.collect_category, let cell1 = self.collect_category.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Category_cell {
            let dict = self.arr_Category[indexPath.item]
            cell1.lbl_Store.text = dict.category_Name
            if let img = dict.category_Image, img != "" {
                cell1.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                    // Your code inside completion block
                    if (error != nil) {
                        // Failed to load image
                        cell1.img_vw.image = UIImage(named: "Juice")
                    } else {
                        // Successful in loading image
                        cell1.img_vw.image = image
                    }
                }
            }
            return cell1
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collect_category {
            return CGSize(width: 95, height: 130)
        }
        return self.collection.frame.insetBy(dx: 40, dy: 0).size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collect_category {
            if self.arr_Category[indexPath.row].is_Special == "1" {
                let List = self.storyboard?.instantiateViewController(withIdentifier: "SpecialProduct_VC") as! SpecialProduct_VC
                List.categoryId = self.arr_Category[indexPath.item].category_Id ?? ""
                List.CategoryName = self.arr_Category[indexPath.item].category_Name ?? ""
                self.navigationController?.pushViewController(List, animated: true)
            } else {
                let List = self.storyboard?.instantiateViewController(withIdentifier: "ShopList_VC") as! ShopList_VC
                List.categoryId = self.arr_Category[indexPath.item].category_Id ?? ""
                List.categoryName = self.arr_Category[indexPath.row].category_Name ?? ""
                //            CustomNavigationController().pushViewController(List, animated: true)
                self.navigationController?.pushViewController(List, animated: true)
            }
        }
    }
    
}


extension Shop_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Product_ListCell {
            
            self.view.setNeedsLayout()
            if indexPath.row == 0 {
                cell.lbl_Type.text = "Recommended For You"
                cell.arr_data = self.arr_RecommendProductList
            } else if indexPath.row == 1 {
                cell.lbl_Type.text = "Trending Product"
                cell.arr_data = self.arr_TrendingProductList
            }
            if cell.arr_data.count != 0 {
                cell.collect_height_const.constant = 270
                cell.collect_vw.isHidden = false
            } else {
                cell.collect_height_const.constant = 0
                cell.collect_vw.isHidden = true
            }
            cell.setCollect()
//            cell.collect_vw.reloadData()
            cell.controllerss = self
            return cell
        }
        return UITableViewCell()
    }
    
}
