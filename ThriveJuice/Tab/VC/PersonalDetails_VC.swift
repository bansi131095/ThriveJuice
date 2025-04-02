//
//  PersonalDetails_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 16/08/23.
//

import UIKit
import ObjectMapper


class PersonalDetails_VC: UIViewController {

    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_PhoneNo: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var tbl_height_const: NSLayoutConstraint!
    
    var dict_Profile: User?
    var arr_address: [Addresses] = []
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProfileAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_editName(_ sender: UIButton) {
    }
    
    @IBAction func act_editNumber(_ sender: UIButton) {
    }
    
    @IBAction func act_editEmail(_ sender: UIButton) {
    }
    
    @IBAction func act_AddNewAddress(_ sender: UIButton) {
        let add = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress_VC") as! AddNewAddress_VC
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func act_Update(_ sender: UIButton) {
        if self.txt_name.text == "" {
            self.showAlertToast(message: "Please provide name")
        } else if self.txt_email.text == "" {
            self.showAlertToast(message: "Please provide valid email")
        } else if self.txt_PhoneNo.text == "" {
            self.showAlertToast(message: "Please provide mobile number")
        } else {
            self.call_UpdateProfileAPI()
        }
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
                    self.txt_name.text = dict_Profile?.name
                    self.txt_email.text = dict_Profile?.email_Id
                    self.txt_PhoneNo.text = dict_Profile?.mobile_No
                    if let arr = self.dict_Profile?.addresses {
                        self.arr_address = arr
                        self.tbl_vw.register(UINib(nibName: "AddressList_cell", bundle: nil), forCellReuseIdentifier: "cell")
                        self.tbl_height_const.constant = CGFloat(self.arr_address.count*145)
                        self.tbl_vw.delegate = self
                        self.tbl_vw.dataSource = self
                        self.tbl_vw.reloadData()
                    }
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_UpdateProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Update_Type"] = "Profile"
        paramer["Name"] = self.txt_name.text ?? ""
        paramer["Mobile_No"] = self.txt_PhoneNo.text ?? ""
        paramer["Email_Id"] = self.txt_email.text ?? ""
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Update_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                    self.call_ProfileAPI()
                } else {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_AddAddress(Id: String) {
        // Type = Add / Update / Delete ( Address_Id ), City, Address_Latitude, Address_Longitude, Postal_Code, Landmark, Address, Address_Id
        
        var paramer: [String: Any] = [:]
        paramer["Type"] = "Delete"
        paramer["Address_Id"] = Id
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Add_Address, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                    self.call_ProfileAPI()
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


extension PersonalDetails_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AddressList_cell {
            let dict = self.arr_address[indexPath.row]
            cell.lbl_name.text = dict.landmark
            cell.lbl_address.text = dict.address
            cell.lbl_city.text = (dict.city ?? "") + " - " + (dict.postal_Code ?? "")
            if let select = dict.is_Selected {
                if select {
                    cell.vw_address.borderWidth = 1
                    cell.vw_address.borderColor = UIColor(named: "AccentColor")
                } else {
                    cell.vw_address.borderWidth = 0
                    cell.vw_address.borderColor = UIColor.clear
                }
            }
            cell.Act_edit = {
                let add = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress_VC") as! AddNewAddress_VC
                add.str_edit = true
                add.dictAddresss = dict
                self.navigationController?.pushViewController(add, animated: true)
            }
            cell.Act_delete = {
                self.call_AddAddress(Id: dict.address_Id ?? "")
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
