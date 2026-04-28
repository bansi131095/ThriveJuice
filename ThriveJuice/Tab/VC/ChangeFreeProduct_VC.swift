//
//  ChangeFreeProduct_VC.swift
//  ThriveJuice
//
//  Created by mini new on 19/12/25.
//

import UIKit

class ChangeFreeProduct_VC: UIViewController {

    @IBOutlet weak var cv_Product: UICollectionView!
    
    
    var arrCartProduct: [Cart_Products] = []
    var buyId = String()
    var selectedProductId = String()

    var onProductSelect: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cv_Product.register(UINib(nibName: "Product_cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.cv_Product.dataSource = self
        self.cv_Product.delegate = self
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}


extension ChangeFreeProduct_VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCartProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.cv_Product.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Product_cell {
            let dict = self.arrCartProduct[indexPath.row]
            cell.lbl_ProductName.text = dict.product_Name
            let productId = dict.product_Id ?? ""
            
            var productSize = String()
            var productDays = String()
            var cart_data: CartData?
            var Cellcart = 0
            cell.lbl_price.text = "$" + (dict.product_Price ?? "0")
            cell.btn_like.isHidden = true
            cell.btn_AddToCart.isHidden = true
            cell.btn_Select.isHidden = false
            
            cell.vw_Background.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.btn_Select.setTitle("Select", for: .normal)
            cell.btn_Select.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.3803921569, blue: 0.3764705882, alpha: 1)
            cell.btn_Select.setTitleColor(.white, for: .normal)
            
            if let arr = dict.product_Size, arr.count != 0 {
                if arr.count == 1 {
                    cell.lbl_price.text = "$" + (arr[0].product_Price ?? "0")
                    productSize = arr[0].product_Size ?? "0"
                    productDays = arr[0].product_Days ?? ""
                } else {
                    cell.lbl_price.text = "From $" + (arr[0].product_Price ?? "0")
                    productSize = arr[0].product_Size ?? "0"
                    productDays = arr[0].product_Days ?? ""
                }
            }
//            cell.btn_Select.setTitle("Select", for: .normal)
            if let arr = dict.product_Image, arr.count != 0 {
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
            
            if productId == selectedProductId {
                cell.vw_Background.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.737254902, alpha: 1)
                cell.btn_Select.setTitle("Selected", for: .normal)
                cell.btn_Select.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.5450980392, blue: 0.1647058824, alpha: 1)
                cell.btn_Select.setTitleColor(.white, for: .normal)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 42) / 3 // Adjust the width according to your needs
        let height = 270.0// Calculate the height of your cell
                
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrCartProduct[indexPath.row]
        let productId = dict.product_Id ?? ""
        selectedProductId = productId
        cv_Product.reloadData()
        onProductSelect?(buyId, productId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: true)
            }
    }
    
}
