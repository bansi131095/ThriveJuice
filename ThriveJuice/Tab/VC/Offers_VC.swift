//
//  Offers_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 04/08/23.
//

import UIKit
import ObjectMapper


class OfferCell: UICollectionViewCell {
    
    
    @IBOutlet weak var img_vw: UIImageView!
    
}


class Offers_VC: UIViewController {

    @IBOutlet weak var collect_vw: UICollectionView!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    
    var arr_offers: [Offers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.call_OffersAPI()
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
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_Shop(_ sender: UIButton) {
        let shop = self.storyboard?.instantiateViewController(withIdentifier: "Shop_VC") as! Shop_VC
        self.navigationController?.pushViewController(shop, animated: true)
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
    
    
    
    func call_OffersAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Offers, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:OfferModel = Mapper<OfferModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.offers, arr.count != 0 {
                    self.arr_offers = arr
                    self.collect_vw.reloadData()
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


extension Offers_VC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OfferCell {
            let dict = self.arr_offers[indexPath.row]
            if let img = dict.offer_Image, img != "" {
                cell.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                    // Your code inside completion block
                    if (error != nil) {
                        // Failed to load image
                    } else {
                        // Successful in loading image
                        cell.img_vw.image = image
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arr_offers[indexPath.row]
        if let catId = dict._Category_Id {
            if catId != "0" {
                let List = self.storyboard?.instantiateViewController(withIdentifier: "ShopList_VC") as! ShopList_VC
                List.categoryId = dict._Category_Id ?? ""
                List.categoryName = dict.category_Name ?? ""
                self.navigationController?.pushViewController(List, animated: true)
            }
        } else if let productId = dict._Product_Id {
            if productId != "0" {
                let details = self.storyboard?.instantiateViewController(withIdentifier: "ProductDtails_VC") as! ProductDetails_VC
                details.ProductId = productId
                self.navigationController?.pushViewController(details, animated: true)
            }
        }
    }
    
}
