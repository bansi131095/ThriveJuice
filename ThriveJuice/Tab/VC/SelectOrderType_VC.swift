//
//  SelectOrderType_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 04/10/23.
//

import UIKit
import ObjectMapper




class SelectOrderType_VC: UIViewController {

    @IBOutlet weak var vw_rounded: RoundedTopCornersView!
    @IBOutlet weak var btn_LocalDelivery: UIButton!
    @IBOutlet weak var btn_storePickup: UIButton!
    @IBOutlet weak var btn_pickupToday: UIButton!
    
    var OrderType = String()
    var userId = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if userId != "" {
            self.call_ProfileAPI()
        } else {
            if UserDefaults.standard.object(forKey: "orderType") != nil {
                self.OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.vw_rounded{
            self.dismiss(animated: true)
        }
    }
    
    //MARK:- button Action
    @IBAction func act_save(_ sender: UIButton) {
        if userId != "" {
            self.call_UpdateProfileAPI()
        } else {
            UserDefaults.standard.set(self.OrderType, forKey: "orderType")
            NotificationCenter.default.post(name: NSNotification.Name("OrderTypeSelect"), object: nil, userInfo: ["OrderType": true])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func act_localDelivery(_ sender: UIButton) {
        self.btn_LocalDelivery.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.OrderType = "Local_Delivery"
    }
    
    @IBAction func act_storePickup(_ sender: UIButton) {
        self.btn_storePickup.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_LocalDelivery.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.OrderType = "Store_Pickup"
    }
    
    // Right_Away
    @IBAction func act_pickupToday(_ sender: UIButton) {
        self.btn_pickupToday.setImage(UIImage(named: "Check"), for: .normal)
        self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.btn_LocalDelivery.setImage(UIImage(named: "Uncheck"), for: .normal)
        self.OrderType = "Right_Away"
    }
    
    
    //MARK:- API Call
    func call_ProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let user = eventResponseModel.user {
                    if let type = user.order_Type {
                        self.OrderType = type
                        if self.OrderType == "Local_Delivery" {
                            self.btn_LocalDelivery.setImage(UIImage(named: "Check"), for: .normal)
                            self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
                            self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
                        } else if self.OrderType == "Store_Pickup" {
                            self.btn_storePickup.setImage(UIImage(named: "Check"), for: .normal)
                            self.btn_LocalDelivery.setImage(UIImage(named: "Uncheck"), for: .normal)
                            self.btn_pickupToday.setImage(UIImage(named: "Uncheck"), for: .normal)
                        }  else if self.OrderType == "Right_Away" {
                            self.btn_pickupToday.setImage(UIImage(named: "Check"), for: .normal)
                            self.btn_storePickup.setImage(UIImage(named: "Uncheck"), for: .normal)
                            self.btn_LocalDelivery.setImage(UIImage(named: "Uncheck"), for: .normal)
                        }
                    }
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_UpdateProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Update_Type"] = "Order_Type"
        paramer["Order_Type"] = self.OrderType
        
        WebService.call.POSTT(filePath: global.shared.URL_Update_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                    UserDefaults.standard.set(self.OrderType, forKey: "orderType")
                    NotificationCenter.default.post(name: NSNotification.Name("OrderTypeSelect"), object: nil, userInfo: ["OrderType": true])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true)
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
