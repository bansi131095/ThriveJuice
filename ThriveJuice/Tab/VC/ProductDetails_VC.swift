//
//  ProductDetails_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 10/08/23.
//

import UIKit
import ObjectMapper
import ImageSlideshow



class ProductDetails_VC: UIViewController {

    
    @IBOutlet weak var vw_addon: UIView!
    @IBOutlet weak var vw_addon_height_const: NSLayoutConstraint!
    @IBOutlet weak var tbl_addon_vw: UITableView!
    @IBOutlet weak var tbl_addon_height_const: NSLayoutConstraint!
    @IBOutlet weak var vw_stack: UIStackView!
    @IBOutlet weak var vw_stack_height_const: NSLayoutConstraint!
//    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var slider_vw: ImageSlideshow!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txt_size: UITextField!
    @IBOutlet weak var txt_days: UITextField!
    @IBOutlet weak var txt_detox: UITextField!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var collect_vw: UICollectionView!
    @IBOutlet weak var collect_height_const: NSLayoutConstraint!
    @IBOutlet weak var vw_cart: CardView!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    @IBOutlet weak var lbl_cartQty: UILabel!
    @IBOutlet weak var btn_AddToCart: UIButton!
    @IBOutlet weak var lbl_benefits: UILabel!
    @IBOutlet weak var lbl_benefitsTitle: UILabel!
    @IBOutlet weak var vw_benefits: UIView!
    @IBOutlet weak var vw_benefits_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_ingredientsTitle: UILabel!
    @IBOutlet weak var lbl_ingredients: UILabel!
    @IBOutlet weak var vw_ingredients: UIView!
    @IBOutlet weak var vw_ingredients_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var vw_size: UIView!
    @IBOutlet weak var vw_Sizes: UIView!
    @IBOutlet weak var vw_Days: UIView!
    @IBOutlet weak var vw_Detox: UIView!
    @IBOutlet weak var AddonLine: UILabel!
    @IBOutlet weak var lbl_relatedProduct: UILabel!
    //    @IBOutlet weak var lbl_cartTotals: UILabel!
    
    let pickerView = UIPickerView()
    let pickerDaysView = UIPickerView()
    let pickerSizesView = UIPickerView()
    let pickerData = ["16 oz", "32 oz", "48 oz"]
    var CartTotal = 0
    var ProductId = String()
    var dict_product: ProductsList?
    var arr_relatedProduct: [ProductsList] = []
    var arr_ProductSize: [Product_Size] = []
    var arr_Addon: [Product_Addons] = []
    var arr_ProductDays: [Product_Size] = []
    var arr_ProductSizes: [Product_Size] = []
    var selectAddonId: [String] = []
    var editSelectAddonId: [String] = []
    var selectedDays: String = ""
    var selectedSize: String = ""
    var selectedDetox: String = ""
    
    var arrCartData: [CartData] = []
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Global Arr data \(global.shared.arr_AddCartData)")
        if global.shared.arr_AddCartData.count != 0 {
            for i in 0..<global.shared.arr_AddCartData.count {
                if global.shared.arr_AddCartData[i].Product_Id == self.ProductId {
                    editSelectAddonId = global.shared.arr_AddCartData[i].Cart_Addons.components(separatedBy: ",")
                    selectAddonId = editSelectAddonId
                }
            }
            print("Arr data New \(selectAddonId)")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProductDetailsAPI()
        if global.shared.arr_AddCartData.count != 0 {
            var total = 0
            for i in 0..<global.shared.arr_AddCartData.count {
                let qty = global.shared.arr_AddCartData[i].Cart_Qty
                if let val = Int(qty) {
                    total += val
                }
            }
            print("Arr data total \(total)")
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
    
    @IBAction func act_AddToCart(_ sender: UIButton) {
        var cart_data: CartData?
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        self.CartTotal = 0
        if userId != "" {
            var isSelectionMissing = false
            var missingRequiredAddons: [String] = []
            
            if let addons = dict_product?.product_Addons {
                for addon in addons {
                    if addon.Selection_Required == "1" {
                        let addonIds = addon.addons?.compactMap { $0.addon_Id } ?? []

                        let intersection = addonIds.filter { self.selectAddonId.contains($0) }
                        
                        if intersection.isEmpty {
                            if let title = addon.addon_Title{
                                missingRequiredAddons.append(title)
                            }
                        }
                    }
                }
            }
            
            if !missingRequiredAddons.isEmpty {
                let missingTitles = missingRequiredAddons.joined(separator: ", ")
                alertWithImage(title: "", Msg: "Please select required addon: \(missingTitles)")
                return
            }
            
            if let dict = self.dict_product {
                if let arr = self.dict_product?.product_Size, arr.count != 0 {
                    if let stock = arr[0].available_Stock {
                        if stock != 0 {
                            self.vw_cart.isHidden = false
                            self.CartTotal += 1
//                            self.lbl_cartTotal.text = "\(self.CartTotal)"
                            self.lbl_cartQty.text = "\(self.CartTotal)"
                            var strSelectId = ""
                            if self.selectAddonId.count != 0 {
                                for i in 0..<self.selectAddonId.count {
                                    if i == 0 {
                                        strSelectId.append(self.selectAddonId[i])
                                    } else {
                                        strSelectId.append(","+self.selectAddonId[i])
                                    }
                                }
                            }
                            if let id = dict.product_Id {
                                if (!btn_AddToCart.isHidden) {
                                    if let Special = dict.is_Special, Special == "1" {
                                        if strSelectId != "" {
                                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "", cartAddon: strSelectId)
                                        } else {
                                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "")
                                        }
                                        if let data = cart_data {
                                            global.shared.arr_AddCartData.append(data)
                                        }
                                    } else {
                                        if strSelectId != "" {
                                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""), cartAddon: strSelectId)
                                        } else {
                                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""))
                                        }
                                        if let data = cart_data {
                                            global.shared.arr_AddCartData.append(data)
                                        }
                                    }
                                } else {
                                    let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                                    if arrCart.count != 0 && arrCart.count == 1 {
                                        if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                                            if let Special = dict.is_Special, Special == "1" {
                                                if global.shared.arr_AddCartData[index].Cart_Product_Size == (self.txt_detox.text ?? "") {
                                                    global.shared.arr_AddCartData[index].Cart_Qty = "\(self.CartTotal)"
                                                } else {
                                                    if strSelectId != "" {
                                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "", cartAddon: strSelectId)
                                                    } else {
                                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "")
                                                    }
                                                    if let data = cart_data {
                                                        global.shared.arr_AddCartData.append(data)
                                                    }
                                                }
                                            } else {
                                                if global.shared.arr_AddCartData[index].Cart_Product_Size == (self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? "")) {
                                                    global.shared.arr_AddCartData[index].Cart_Qty = "\(self.CartTotal)"
                                                } else {
                                                    if strSelectId != "" {
                                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""), cartAddon: strSelectId)
                                                    } else {
                                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""))
                                                    }
                                                    if let data = cart_data {
                                                        global.shared.arr_AddCartData.append(data)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        if let Special = dict.is_Special, Special == "1" {
                                            if strSelectId != "" {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "", cartAddon: strSelectId)
                                            } else {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "")
                                            }
                                            if let data = cart_data {
                                                global.shared.arr_AddCartData.append(data)
                                            }
                                        } else {
                                            if strSelectId != "" {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""), cartAddon: strSelectId)
                                            } else {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""))
                                            }
                                            if let data = cart_data {
                                                global.shared.arr_AddCartData.append(data)
                                            }
                                        }
                                    }
                                }
                            }
                        }  else {
                            self.showAlertToast(message: "Only {\(stock)} available at this moment")
                        }
                    }
                }
                self.call_CartAddAPI()
                print("Arr data \(global.shared.arr_AddCartData)")
                print("Arr data count \(global.shared.arr_AddCartData.count)")
            }
        } else {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
        }
    }
    
    @IBAction func act_Plus(_ sender: UIButton) {
        var cart_data: CartData?
        if let arr = self.dict_product?.product_Size, arr.count != 0 {
            if let stock = arr[0].available_Stock {
                if stock != 0 {
                    self.CartTotal += 1
                    if self.CartTotal < 10 {
//                        self.lbl_cartTotal.text = "0\(self.CartTotal)"
                        self.lbl_cartQty.text = "0\(self.CartTotal)"
                    } else {
//                        self.lbl_cartTotal.text = "\(self.CartTotal)"
                        self.lbl_cartQty.text = "\(self.CartTotal)"
                    }
                    var strSelectId = ""
                    if self.selectAddonId.count != 0 {
                        for i in 0..<self.selectAddonId.count {
                            if i == 0 {
                                strSelectId.append(self.selectAddonId[i])
                            } else {
                                strSelectId.append(","+self.selectAddonId[i])
                            }
                        }
                    }
                    if let dict = self.dict_product {
                        if let id = dict.product_Id {
                            let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                            if arrCart.count != 0 {
                                var joinedIds = strSelectId
                                if let index = global.shared.arr_AddCartData.firstIndex(where: {
                                    let cartAddonSet = Set($0.Cart_Addons.components(separatedBy: ","))
                                    let joinedIdSet = Set(joinedIds.components(separatedBy: ","))
                                    return cartAddonSet == joinedIdSet
                                }) {
                                    if let Special = dict.is_Special, Special == "1" {
                                        if global.shared.arr_AddCartData[index].Cart_Product_Size == (self.txt_detox.text ?? "") {
                                            global.shared.arr_AddCartData[index].Cart_Qty = "\(self.CartTotal)"
                                        } else {
                                            if strSelectId != "" {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "1", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "", cartAddon: strSelectId)
                                            } else {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "1", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "")
                                            }
                                            if let data = cart_data {
                                                global.shared.arr_AddCartData.append(data)
                                            }
                                        }
                                    } else {
                                        if global.shared.arr_AddCartData[index].Cart_Product_Size == (self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? "")) {
                                            global.shared.arr_AddCartData[index].Cart_Qty = "\(self.CartTotal)"
                                        } else {
                                            if strSelectId != "" {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "1", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""), cartAddon: strSelectId)
                                            } else {
                                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "1", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""))
                                            }
                                            if let data = cart_data {
                                                global.shared.arr_AddCartData.append(data)
                                            }
                                        }
                                    }
                                }
                            } else {
                                if let Special = dict.is_Special, Special == "1" {
                                    if strSelectId != "" {
                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "", cartAddon: strSelectId)
                                    } else {
                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "")
                                    }
                                    
                                    if let data = cart_data {
                                        global.shared.arr_AddCartData.append(data)
                                    }
                                } else {
                                    if strSelectId != "" {
                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""), cartAddon: strSelectId)
                                    } else {
                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""))
                                    }
                                    if let data = cart_data {
                                        global.shared.arr_AddCartData.append(data)
                                    }
                                }
                            }
                        }
                    }
                }  else {
                    self.showAlertToast(message: "Only {\(stock)} available at this moment")
                }
            }
        }
        self.call_CartAddAPI()
        print("Arr data \(global.shared.arr_AddCartData)")
        print("Arr data count \(global.shared.arr_AddCartData.count)")
    }
    
    @IBAction func act_Minus(_ sender: UIButton) {
        var cart_data: CartData?
        if self.CartTotal > 0 {
            self.CartTotal -= 1
            if self.CartTotal < 10 {
//                self.lbl_cartTotal.text = "0\(self.CartTotal)"
                self.lbl_cartQty.text = "0\(self.CartTotal)"
            } else {
//                self.lbl_cartTotal.text = "\(self.CartTotal)"
                self.lbl_cartQty.text = "\(self.CartTotal)"
            }
        }
        if self.CartTotal == 0 {
            self.vw_cart.isHidden = true
        }
        var strSelectId = ""
        if self.selectAddonId.count != 0 {
            for i in 0..<self.selectAddonId.count {
                if i == 0 {
                    strSelectId.append(self.selectAddonId[i])
                } else {
                    strSelectId.append(","+self.selectAddonId[i])
                }
            }
        }
        if let dict = self.dict_product {
            if let id = dict.product_Id {
                var arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                if arrCart.count != 0 {
                    var joinedIds = strSelectId
                    if self.CartTotal == 0 {
                        if let index = global.shared.arr_AddCartData.firstIndex(where: {
                            let cartAddonSet = Set($0.Cart_Addons.components(separatedBy: ","))
                            let joinedIdSet = Set(joinedIds.components(separatedBy: ","))
                            return cartAddonSet == joinedIdSet
                        }) {
                            global.shared.arr_AddCartData.remove(at: index)
                        }
                    } else {
                        if let index = global.shared.arr_AddCartData.firstIndex(where: {
                            let cartAddonSet = Set($0.Cart_Addons.components(separatedBy: ","))
                            let joinedIdSet = Set(joinedIds.components(separatedBy: ","))
                            return cartAddonSet == joinedIdSet
                        }) {
                            global.shared.arr_AddCartData[index].Cart_Qty = "\(self.CartTotal)"
                        }
                    }
                } else {
                    if self.CartTotal == 0 {
                        if let index = global.shared.arr_AddCartData.firstIndex(where: { $0.Product_Id == id }) {
                            global.shared.arr_AddCartData.remove(at: index)
                        }
                    } else {
                        
                        if let Special = dict.is_Special, Special == "1" {
                            if strSelectId != "" {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "", cartAddon: strSelectId)
                            } else {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.txt_detox.text ?? "", cartDays: self.txt_days.text ?? "")
                            }
                            if let data = cart_data {
                                global.shared.arr_AddCartData.append(data)
                            }
                        } else {
                            if strSelectId != "" {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""), cartAddon: strSelectId)
                            } else {
                                cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(self.CartTotal)", cartProductSize: self.vw_size.isHidden ? (self.lbl_size.text ?? "") : (self.txt_size.text ?? ""))
                            }
                            
                            if let data = cart_data {
                                global.shared.arr_AddCartData.append(data)
                            }
                        }
                    }
                }
            }
        }
        self.call_CartAddAPI()
    }
    
    @IBAction func act_BuyNow(_ sender: UIButton) {
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
  
    @IBAction func act_like(_ sender: UIButton) {
        self.call_AddWishlistAPI(isRelated: false, productId: self.ProductId)
    }
    
    //MARK:- Function
    func SetPickerVW() {
        pickerView.delegate = self
        pickerView.dataSource = self
                
        // Assign the picker view as the input view for the text field
        self.txt_size.inputView = pickerView
        self.txt_size.text = self.arr_ProductSize[0].product_Size ?? "0"
        self.selectedSize = self.arr_ProductSize[0].product_Size ?? ""
    }
    
    func SetPickerVWDays() {
        pickerDaysView.delegate = self
        pickerDaysView.dataSource = self
                
        // Assign the picker view as the input view for the text field
        self.txt_days.inputView = pickerDaysView
        self.txt_days.text = self.arr_ProductDays[0].product_Days ?? ""
        self.selectedDays = self.arr_ProductDays[0].product_Days ?? ""
    }
    
    func SetPickerVWSizes() {
        pickerSizesView.delegate = self
        pickerSizesView.dataSource = self
                
        // Assign the picker view as the input view for the text field
        self.txt_detox.inputView = pickerSizesView
        self.txt_detox.text = self.arr_ProductSizes[0].product_Size ?? ""
        self.selectedDetox = self.arr_ProductSizes[0].product_Size ?? ""
    }
    
    func SetData(fromCart:Bool) {
        if let data = self.dict_product {
            if !fromCart {
                self.lbl_Title.text = data.product_Name
                self.lbl_category.text = data.category_Name
                if let Ingredients = data.ingredients {
                    if Ingredients != "" {
                        self.lbl_ingredients.text = Ingredients
                        // Calculate label height based on text
                        let labelWidth = self.lbl_ingredients.frame.width // Set the width of the label (consider constraints)
                        let maxSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
                        let labelHeight = self.lbl_ingredients.sizeThatFits(maxSize).height
                        
                        // Update the label's frame with the calculated height
                        self.lbl_ingredients.frame.size.height = labelHeight
                        let heights = labelHeight + 44.0
                        self.vw_ingredients.isHidden = false
                        self.lbl_ingredientsTitle.text = "Ingredients:"
                        self.vw_ingredients_height_const.constant = heights
                    } else {
                        self.vw_ingredients.isHidden = true
                        self.lbl_ingredientsTitle.text = ""
                        self.vw_ingredients_height_const.constant = 0.0
                    }
                } else {
                    self.vw_ingredients.isHidden = true
                    self.lbl_ingredientsTitle.text = ""
                    self.vw_ingredients_height_const.constant = 0.0
                }
                if let description = data.product_Description {
                    if description != "" {
                        self.lbl_desc.attributedText = description.htmlToAttributedString
                    }
                }
                if let Benefits = data.benefits {
                    if Benefits != "" {
                        self.lbl_benefits.attributedText = Benefits.htmlToAttributedString
                        
                        let labelWidth = self.lbl_benefits.frame.width // Set the width of the label (consider constraints)
                        let maxSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
                        let labelHeight = self.lbl_benefits.sizeThatFits(maxSize).height
                        
                        // Update the label's frame with the calculated height
                        self.lbl_benefits.frame.size.height = labelHeight
                        let heights = labelHeight + 34.0
                        self.vw_benefits.isHidden = false
                        self.lbl_benefitsTitle.text = "Benefits: "
                        self.vw_benefits_height_const.constant = heights
                    } else {
                        self.vw_benefits.isHidden = true
                        self.lbl_benefitsTitle.text = ""
                        self.vw_benefits_height_const.constant = 0.0
                    }
                } else {
                    self.vw_benefits.isHidden = true
                    self.lbl_benefitsTitle.text = ""
                    self.vw_benefits_height_const.constant = 0.0
                }
                if let arr = data.product_Size, arr.count != 0 {
                    self.lbl_price.text = "$" + (arr[0].product_Price ?? "0")
                    
                    if let Special = data.is_Special, Special == "1" {
                        self.vw_Sizes.isHidden = true
                        self.vw_Days.isHidden = false
                        self.vw_Detox.isHidden = false
                        self.vw_stack.isHidden = false
                        self.vw_stack_height_const.constant = 75.0
                        for i in 0..<arr.count {
                            if let days = arr[i].product_Days {
                                if i == 0 {
                                    self.arr_ProductDays.append(arr[i])
                                } else {
                                    let DaysExists = self.arr_ProductDays.contains { person in
                                        return person.product_Days == days
                                    }
                                    if !DaysExists {
                                        self.arr_ProductDays.append(arr[i])
                                    }
                                }
                            }
                        }
                        let filteredData = self.arr_ProductSize.filter { Data in
                            return Data.product_Days == (self.arr_ProductDays[0].product_Days ?? "")
                        }
                        self.arr_ProductSizes = filteredData
                        print("Product Days : \(arr_ProductDays)")
                        print("Product Sizes : \(arr_ProductSizes)")
                        self.SetPickerVWDays()
                        self.SetPickerVWSizes()
                    } else {
                        self.vw_Sizes.isHidden = false
                        self.vw_Days.isHidden = true
                        self.vw_Detox.isHidden = true
                        self.vw_stack.isHidden = false
                        self.vw_stack_height_const.constant = 55.0
                        if self.arr_ProductSize.count == 1 {
                            if let size = self.arr_ProductSize[0].product_Size, size != ""{
                                if size == " " {
                                    self.lbl_size.text = size
                                    self.vw_Sizes.isHidden = true
                                    self.vw_stack.isHidden = true
                                    self.vw_stack_height_const.constant = 0.0
                                } else {
                                    self.lbl_size.text = size
                                }
                                self.vw_size.isHidden = true
                            } else {
                                self.vw_Sizes.isHidden = true
                                self.vw_stack.isHidden = true
                                self.vw_stack_height_const.constant = 0.0
                            }
                        } else {
                            self.lbl_size.text = ""
                            self.vw_size.isHidden = false
                            self.SetPickerVW()
                        }
                    }
                    if let stock = arr[0].available_Stock {
                        if stock == 0 {
                            self.btn_AddToCart.setTitle("Out of Stock", for: .normal)
                            self.btn_AddToCart.backgroundColor = UIColor(named: "Red")
                            self.btn_AddToCart.isUserInteractionEnabled = false
                        } else {
                            self.btn_AddToCart.setTitle("Add To Cart", for: .normal)
                            self.btn_AddToCart.backgroundColor = UIColor(named: "AccentColor")
                            self.btn_AddToCart.isUserInteractionEnabled = true
                        }
                    }
                }
                if let isWishlist = data.is_Wishlist {
                    if isWishlist {
                        self.btn_like.setImage(UIImage(named: "Like"), for: .normal)
                    } else {
                        self.btn_like.setImage(UIImage(named: "Unlike"), for: .normal)
                    }
                }
                if self.arr_Addon.count != 0 {
                    var totalheight = 0
                    var collectHeight = 0
                    totalheight += 35
                    let collectionwidth = self.tbl_addon_vw.bounds.width - 40
                    for i in 0..<self.arr_Addon.count {
                        var widthTotal = 0.0
                        if let arr = self.arr_Addon[i].addons, arr.count != 0 {
                            collectHeight += 35
                            for i1 in 0..<arr.count {
                                let data = arr[i1]
                                var text = ""
                                if let name = data.addon_Name, let price = data.addon_Price {
                                    text = name + " - $" + price
                                }
                                let font = UIFont(name: "Jost Regular", size: 14.0)// or any font you prefer
                                let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                                
                                let labelSize = (text as NSString).boundingRect(
                                    with: maxSize,
                                    options: .usesLineFragmentOrigin,
                                    attributes: [NSAttributedString.Key.font: font!],
                                    context: nil
                                ).size
                                
                                // You might want to add some padding to the label's width for better aesthetics
                                let cellWidth = labelSize.width + 34
                                if i1 == 0 {
                                    collectHeight += 70
                                }
                                widthTotal += cellWidth
                                if widthTotal > collectionwidth {
                                    widthTotal = 0
                                    collectHeight += 70
                                }
                            }
                        }
                    }
                    totalheight += collectHeight
                    self.vw_addon.isHidden = false
                    self.AddonLine.isHidden = false
                    self.vw_addon_height_const.constant = CGFloat(totalheight)
                    self.tbl_addon_vw.register(UINib(nibName: "Addon_cell", bundle: nil), forCellReuseIdentifier: "cell")
                    self.tbl_addon_vw.delegate = self
                    self.tbl_addon_vw.dataSource = self
                    self.tbl_addon_height_const.constant = CGFloat(collectHeight)
                    self.tbl_addon_vw.isHidden = false
                    self.tbl_addon_vw.reloadData()
                } else {
                    self.vw_addon.isHidden = true
                    self.AddonLine.isHidden = true
                    self.vw_addon_height_const.constant = 0.0
                    self.tbl_addon_height_const.constant = 0.0
                    self.tbl_addon_vw.isHidden = true
                }
                self.banner_add()
               /* if let arr = data.product_Image, arr.count != 0 {
                    let img = arr[0]
                    if img != "" {
                        self.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                            // Your code inside completion block
                            if (error != nil) {
                                // Failed to load image
                                self.img_vw.image = UIImage(named: "ProductDemo")
                            } else {
                                // Successful in loading image
                                self.img_vw.image = image
                            }
                        }
                    }
                } */
            }
            let arr_cart = global.shared.arr_AddCartData
            self.CartTotal = 0
            if arr_cart.count != 0 {
                if let id = data.product_Id {
                    let arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
                    if arrCart.count != 0 {
                        self.vw_cart.isHidden = false
                        for i in 0..<arrCart.count {
                            if let qty = Int(arrCart[i].Cart_Qty) {
                                self.CartTotal = qty
                            }
                        }
                        // self.lbl_cartTotal.text = "\(self.CartTotal)"
                        self.lbl_cartQty.text = "\(self.CartTotal)"
                    } else {
                        self.vw_cart.isHidden = true
                    }
                }
            }
        }
    }
    
    
    //MARK:- Slider View
    func banner_add() {
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let data = self.dict_product {
                if let arr = data.product_Image, arr.count != 0 {
                    self.slider_vw.slideshowInterval = 5.0
                    self.slider_vw.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
                    self.slider_vw.contentScaleMode = .scaleToFill
                    
                    let pageControl = UIPageControl()
                    pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.08235294118, green: 0.3803921569, blue: 0.3764705882, alpha: 1)
                    pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
                    self.slider_vw.pageIndicator = pageControl
                    // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
                    self.slider_vw.activityIndicator = DefaultActivityIndicator()
                    self.slider_vw.currentPageChanged = { page in
                        //   print("current page:", page)
                    }
                    var localSource = [InputSource]()
                    for i in 0..<arr.count {
                        let img = arr[i]
                        if img != "" {
                            self.slider_vw.isHidden = false
                            if let paths = img.encodeUrl() {
                                if let source = SDWebImageSource(urlString: paths) {
                                    localSource = localSource + [source]
                                }
                            }
                        }
                    }
                    self.slider_vw.setImageInputs(localSource)
                } else {
                    self.slider_vw.isHidden = true
                }
            }
        }
    }
    
    //MARK:- API Call
    func call_ProductDetailsAPI() {
            
        var paramer: [String: Any] = [:]
        paramer["Product_Id"] = self.ProductId
        
        WebService.call.POSTT(filePath: global.shared.URL_Product_Details, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:ProductDetailModel = Mapper<ProductDetailModel>().map(JSONObject: result) {
                if let dict = eventResponseModel.product {
                    self.dict_product = dict
                    if let arr = self.dict_product?.product_Size, arr.count != 0 {
                        self.arr_ProductSize = arr
                    }
                    if let arr1 = self.dict_product?.product_Addons, arr1.count != 0 {
                        self.arr_Addon = arr1
                    }
                    self.SetData(fromCart: false)
                }
                if let arr = eventResponseModel.relatedProducts, arr.count != 0 {
                    self.arr_relatedProduct = arr
                    self.collect_vw.register(UINib(nibName: "Product_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
                    self.collect_vw.isHidden = false
                    self.collect_height_const.constant = 270.0
                    self.collect_vw.dataSource = self
                    self.collect_vw.delegate = self
                    self.collect_vw.reloadData()
                    self.lbl_relatedProduct.text = "Related Products"
                } else {
                    self.collect_vw.isHidden = true
                    self.collect_height_const.constant = 0.0
                    self.lbl_relatedProduct.text = ""
                }
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
                self.SetData(fromCart: true)
                if eventResponseModel.status == "1" {
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
//                                self.CartTotal = total
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
    
    
    func call_AddWishlistAPI(isRelated:Bool, productId: String) {
        
        var paramer: [String: Any] = [:]
        if isRelated {
            paramer["Product_Id"] = productId
        } else {
            paramer["Product_Id"] = self.ProductId
        }
        
        WebService.call.POSTT(filePath: global.shared.URL_Add_To_Wishlist, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:StatusModel = Mapper<StatusModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        if isRelated {
                            self.call_ProductDetailsAPI()
                        } else {
                            self.btn_like.setImage(UIImage(named: "Like"), for: .normal)
                        }
                    } else if status == "2" {
                        if isRelated {
                            self.call_ProductDetailsAPI()
                        } else {
                            self.btn_like.setImage(UIImage(named: "Unlike"), for: .normal)
                        }
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


extension ProductDetails_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_Addon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbl_addon_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Addon_cell
        let data = self.arr_Addon[indexPath.row]
        cell.lbl_title.text = data.addon_Title ?? ""
        var collectHeight = 0
        let collectionwidth = self.tbl_addon_vw.bounds.width - 40
        var widthTotal = 0.0
        if let arr = data.addons, arr.count != 0 {
            cell.arr_AddonItem = arr
            cell.ProductId = self.ProductId
            for i1 in 0..<arr.count {
                let data = arr[i1]
                var text = ""
                if let name = data.addon_Name, let price = data.addon_Price {
                    text = name + " - $" + price
                }
                let font = UIFont(name: "Jost Regular", size: 14.0)// or any font you prefer
                let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                
                let labelSize = (text as NSString).boundingRect(
                    with: maxSize,
                    options: .usesLineFragmentOrigin,
                    attributes: [NSAttributedString.Key.font: font!],
                    context: nil
                ).size
                
                // You might want to add some padding to the label's width for better aesthetics
                let cellWidth = labelSize.width + 34
                if i1 == 0 {
                    collectHeight += 70
                }
                widthTotal += cellWidth
                if widthTotal > collectionwidth {
                    widthTotal = 0
                    collectHeight += 70
                }
            }
        }
        cell.CollectionHeight = collectHeight
        cell.SetCollectVw()
        cell.selectType = data.Selection_Type ?? ""
        cell.collect_vw.reloadData()
        cell.Act_AddAddon = { str, old, add in
            if (add) {
                if old != "" {
                    self.selectAddonId.remove(old)
                }
                self.selectAddonId.append(str)
            } else {
                self.selectAddonId.remove(str)
            }
            print("Selected : \(self.selectAddonId)")
            print("Edit Addon : \(self.editSelectAddonId)")
            if (Set(self.selectAddonId) == Set(self.editSelectAddonId)) {
                self.vw_cart.isHidden = false
                self.btn_AddToCart.isHidden = true
            } else {
                self.vw_cart.isHidden = true
                self.btn_AddToCart.isHidden = false
            }
            /*var strSelectedId: String = ""
            
            if self.selectAddonId.count != 0 {
                for i in 0..<self.selectAddonId.count {
                    if i == 0 {
                        strSelectedId.append(self.selectAddonId[i])
                    } else {
                        strSelectedId.append(","+self.selectAddonId[i])
                    }
                }
            }
            
            for item in global.shared.arr_AddCartData {
                if item.Product_Id == self.ProductId {
                    self.selectAddonId = item.Cart_Addons.components(separatedBy: ",")
                    print("AddonID:- \(self.selectAddonId)")
                    print("SelectedAddonID:- \(cell.selectAddonId.joined(separator: ","))")
                    break
                }
            }*/
        }
        return cell
    }
    
}


extension ProductDetails_VC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.collect_vw {
            count = self.arr_relatedProduct.count
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell1 = self.collect_vw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Product_cell {
            let dict = self.arr_relatedProduct[indexPath.item]
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
            
            if dict.product_Addons?.count ?? 0 > 0 {
               cell1.btn_AddToCart.setTitle("View Product", for: .normal)
               cell1.btn_AddToCart.backgroundColor = UIColor(named: "AccentColor")
               cell1.btn_AddToCart.isUserInteractionEnabled = false
            }else{
               cell1.btn_AddToCart.setTitle("Add To Cart", for: .normal)
               cell1.btn_AddToCart.backgroundColor = UIColor(named: "AccentColor")
               cell1.btn_AddToCart.isUserInteractionEnabled = true
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
                    self.call_AddWishlistAPI(isRelated: true, productId: id)
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
//                        self.Totalcart += Cellcart
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
                                if arr.count == 1 {
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
                                    details.ProductId = self.arr_relatedProduct[indexPath.item].product_Id ?? ""
                                    self.navigationController?.pushViewController(details, animated: true)
                                }
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
        return CGSize(width: 150.0, height: 270.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetails_VC") as! ProductDetails_VC
        details.ProductId = self.arr_relatedProduct[indexPath.item].product_Id ?? ""
        self.navigationController?.pushViewController(details, animated: true)
    }
    
}


extension ProductDetails_VC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of components in the picker view (columns)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == self.pickerView {
            count = self.arr_ProductSize.count
        } else if pickerView == self.pickerDaysView {
            count = self.arr_ProductDays.count
        } else if pickerView == self.pickerSizesView {
            count = self.arr_ProductSizes.count
        }
        return count// Replace with the actual data source count
    }
    
    // Content for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var str = ""
        if pickerView == self.pickerView {
            str = self.arr_ProductSize[row].product_Size ?? ""
        } else if pickerView == self.pickerDaysView {
            str = self.arr_ProductDays[row].product_Days ?? ""
        } else if pickerView == self.pickerSizesView {
            str = self.arr_ProductSizes[row].product_Size ?? ""
        }
        return str// Replace with the actual data
    }
    
    // Handle selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
            self.txt_size.text = self.arr_ProductSize[row].product_Size ?? "" // Update the text field's text
            if (self.selectedSize != self.txt_size.text) {
                self.vw_cart.isHidden = true
                self.btn_AddToCart.isHidden = false
            } else {
                self.vw_cart.isHidden = false
                self.btn_AddToCart.isHidden = true
            }
            self.lbl_price.text = "$" + (self.arr_ProductSize[row].product_Price ?? "0")
        } else if pickerView == self.pickerDaysView {
            self.txt_days.text = self.arr_ProductDays[row].product_Days ?? "" // Update the text field's text
            self.lbl_price.text = "$" + (self.arr_ProductDays[row].product_Price ?? "0")
            let filteredData = self.arr_ProductSize.filter { Data in
                return Data.product_Days == (self.arr_ProductDays[row].product_Days ?? "")
            }
            if (self.selectedDays != self.txt_days.text) {
                self.vw_cart.isHidden = true
                self.btn_AddToCart.isHidden = false
            } else {
                self.vw_cart.isHidden = false
                self.btn_AddToCart.isHidden = true
            }
            self.arr_ProductSizes = filteredData
            self.pickerSizesView.reloadAllComponents()
        } else if pickerView == self.pickerSizesView {
            self.txt_detox.text = self.arr_ProductSizes[row].product_Size ?? "" // Update the text field's text
            if (self.selectedDetox != self.txt_detox.text) {
                self.vw_cart.isHidden = true
                self.btn_AddToCart.isHidden = false
            } else {
                self.vw_cart.isHidden = false
                self.btn_AddToCart.isHidden = true
            }
            self.lbl_price.text = "$" + (self.arr_ProductSizes[row].product_Price ?? "0")
        }
        
        self.view.endEditing(true)
    }
    
}

