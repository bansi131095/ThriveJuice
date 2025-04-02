//
//  Product_ListCell.swift
//  ThriveJuice
//
//  Created by MacBook on 07/08/23.
//

import UIKit

class Product_ListCell: UITableViewCell {

    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var collect_vw: UICollectionView!
    @IBOutlet weak var collect_height_const: NSLayoutConstraint!
    
    var controllerss = Shop_VC()
//    var Totalcart = 0
    var arr_data: [ProductsList] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollect() {
        self.collect_vw.register(UINib(nibName: "Product_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collect_vw.dataSource = self
        self.collect_vw.delegate = self
        self.collect_vw.reloadData()
    }
    
}

extension Product_ListCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.collect_vw {
            count = self.arr_data.count
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell1 = self.collect_vw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Product_cell {
            let dict = self.arr_data[indexPath.item]
            var productSize = String()
            var cart_data: CartData?
            var Cellcart = 0
            cell1.lbl_ProductName.text = dict.product_Name
            if let isWishlist = dict.is_Wishlist {
                if isWishlist {
                    cell1.btn_like.setImage(UIImage(named: "Like"), for: .normal)
                } else {
                    cell1.btn_like.setImage(UIImage(named: "Unlike"), for: .normal)
                }
            }
            cell1.Act_Like = {
                if let id = dict.product_Id {
                    self.controllerss.call_AddWishlistAPI(productId: id)
                }
            }
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
                                        cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                        if let data = cart_data {
                                            global.shared.arr_AddCartData.append(data)
                                        }
                                    }
                                }
                                self.controllerss.call_CartAddAPI()
                                print("Arr data \(global.shared.arr_AddCartData)")
                                print("Arr data count \(global.shared.arr_AddCartData.count)")
                               /* if arr.count == 1 {
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
                                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                                            if let data = cart_data {
                                                global.shared.arr_AddCartData.append(data)
                                            }
                                        }
                                    }
                                    self.controllerss.call_CartAddAPI()
                                    print("Arr data \(global.shared.arr_AddCartData)")
                                    print("Arr data count \(global.shared.arr_AddCartData.count)")
                                } else {
                                    let details = self.controllerss.storyboard?.instantiateViewController(withIdentifier: "ProductDetails_VC") as! ProductDetails_VC
                                    details.ProductId = self.arr_data[indexPath.item].product_Id ?? ""
                                    self.controllerss.navigationController?.pushViewController(details, animated: true)
                                } */
                            } else {
                                self.controllerss.showAlertToast(message: "Only {\(stock)} available at this moment")
                            }
                        }
                    }
                } else {
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
                    navigation.modalPresentationStyle = .fullScreen
                    self.controllerss.present(navigation, animated: true)
                }
            }
            cell1.Act_AddPlus = {
                if let arr = dict.product_Size, arr.count != 0 {
                    if let stock = arr[0].available_Stock {
                        if stock != 0 {
                            Cellcart += 1
                            cell1.lbl_cart.text = "\(Cellcart)"
                            if let id = dict.product_Id {
                                var arrCart = global.shared.arr_AddCartData.filter{$0.Product_Id == id}
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
                            self.controllerss.call_CartAddAPI()
                        } else {
                            self.controllerss.showAlertToast(message: "Only {\(stock)} available at this moment")
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
                            cart_data = CartData(productId: dict.product_Id ?? "", cartQty: "\(Cellcart)", cartProductSize: productSize)
                            if let data = cart_data {
                                global.shared.arr_AddCartData.append(data)
                            }
                        }
                    }
                }
                self.controllerss.call_CartAddAPI()
                print("Arr data \(global.shared.arr_AddCartData)")
                print("Arr data count \(global.shared.arr_AddCartData.count)")
            }
            
//            print("Arr data \(global.shared.arr_AddCartData)")
//            print("Arr data count \(global.shared.arr_AddCartData.count)")
            return cell1
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 270.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = self.controllerss.storyboard?.instantiateViewController(withIdentifier: "ProductDetails_VC") as! ProductDetails_VC
        details.ProductId = self.arr_data[indexPath.item].product_Id ?? ""
        self.controllerss.navigationController?.pushViewController(details, animated: true)
    }
    
}
