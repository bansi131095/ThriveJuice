//
//  Account_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 04/08/23.
//

import UIKit
import ObjectMapper


class Account_VC: UIViewController {

    @IBOutlet weak var img_vw: UIImageView!
    @IBOutlet weak var lbl_rewards: UILabel!
    @IBOutlet weak var lbl_subscription: UILabel!
    @IBOutlet weak var lbl_cartTotal: UILabel!
    
    var dict_Profile: User?
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProfileAPI()
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
    
    @IBAction func act_Camera(_ sender: UIButton) {
    }
    
    @IBAction func act_PersonalDetails(_ sender: UIButton) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDetails_VC") as! PersonalDetails_VC
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    @IBAction func act_ProductWishlist(_ sender: UIButton) {
        let Wishlist = self.storyboard?.instantiateViewController(withIdentifier: "ProductWishlist_VC") as! ProductWishlist_VC
        self.navigationController?.pushViewController(Wishlist, animated: true)
    }
    
    @IBAction func act_RewardPoints(_ sender: UIButton) {
        let reward = self.storyboard?.instantiateViewController(withIdentifier: "RewardPoints_VC") as! RewardPoints_VC
        self.navigationController?.pushViewController(reward, animated: true)
    }
    
    @IBAction func act_Subscription(_ sender: UIButton) {
        let subscription = self.storyboard?.instantiateViewController(withIdentifier: "MySubscription_VC") as! MySubscription_VC
        self.navigationController?.pushViewController(subscription, animated: true)
    }
    
    @IBAction func act_ChangePsw(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let changePsw = sb.instantiateViewController(withIdentifier: "ChangePassword_VC") as! ChangePassword_VC
        changePsw.MobileNo = dict_Profile?.mobile_No ?? ""
        self.navigationController?.pushViewController(changePsw, animated: true)
    }
    
    @IBAction func act_AboutUs(_ sender: UIButton) {
    }
    
    @IBAction func act_TermsCondi(_ sender: UIButton) {
    }
    
    @IBAction func act_Faqs(_ sender: UIButton) {
    }
    
    @IBAction func act_ReturnPolicy(_ sender: UIButton) {
    }
    
    @IBAction func act_ContactUs(_ sender: UIButton) {
        let contactUs = self.storyboard?.instantiateViewController(withIdentifier: "ContactUs_VC") as! ContactUs_VC
        self.navigationController?.pushViewController(contactUs, animated: true)
    }
    
    @IBAction func act_PrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func act_StoreLocation(_ sender: UIButton) {
    }
    
    @IBAction func act_Logout(_ sender: UIButton) {
        self.showAlertwithOptions(Title: "Logout", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to Logout?", completion: { tap in
            if tap {
                //LOgout
                self.call_UpdateProfileAPI(type: "Logout")
            } else {
                //do nothing
            }
        })
    }
    
    @IBAction func act_deleteAccount(_ sender: UIButton) {
        self.showAlertwithOptions(Title: "Delete Account", optionTitle: "YES", cancelTitle: "NO", message: "Are you sure you want to delete this account?", completion: { tap in
            if tap {
                //LOgout
                self.call_UpdateProfileAPI(type: "Delete_Account")
            } else {
                //do nothing
            }
        })
    }
    
    //MARK:- API Call
    func call_ProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let user = eventResponseModel.user {
                    self.dict_Profile = user
                    if let img = dict_Profile?.profile_Image, img != "" {
                        self.img_vw.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                            // Your code inside completion block
                            if (error != nil) {
                                // Failed to load image
                            } else {
                                // Successful in loading image
                                self.img_vw.image = image
                            }
                        }
                    }
                    if let rewards = self.dict_Profile?.earned_Reward, rewards != "0" {
                        self.lbl_rewards.text = rewards + " POINTS"
                    }
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_UpdateProfileAPI(type: String) {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Update_Type"] = type
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Update_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                    UserDefaults.standard.removeObject(forKey: "u_id")
                    UserDefaults.standard.removeObject(forKey: "u_type")
                    UserDefaults.standard.removeObject(forKey: "timeStamp")
                    UserDefaults.standard.removeObject(forKey: "cartDataList")
                    global.shared.arr_AddCartData.removeAll()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        let sb = UIStoryboard(name: "Main", bundle:nil)
                        let navigation = sb.instantiateViewController(withIdentifier: "Navigate_Login") as! UINavigationController
                        navigation.modalPresentationStyle = .fullScreen
                        self.present(navigation, animated: true)
                    }
                } else {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
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
