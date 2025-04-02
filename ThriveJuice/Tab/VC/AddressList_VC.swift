//
//  AddressList_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 14/09/23.
//

import UIKit
import ObjectMapper


class AddressList_VC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    
    var arr_address: [Addresses] = []
    var selectAddressId = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_ProfileAPI()
    }
    
    @IBAction func act_Add(_ sender: UIButton) {
        let add = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress_VC") as! AddNewAddress_VC
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- API Call
    func call_ProfileAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.user?.addresses {
                    self.arr_address = arr
                    self.tbl_vw.register(UINib(nibName: "Address_cell", bundle: nil), forCellReuseIdentifier: "cell")
                    self.tbl_vw.delegate = self
                    self.tbl_vw.dataSource = self
                    self.tbl_vw.reloadData()
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_UpdateProfileAPI() {
            
        // User_Id, User_Type, Accesskey, Update_Type = Device ( Device_Key ) / Logout / Delete_Account / Profile ( Name, Mobile_No, Email_Id ) / Profile_Image ( Profile_Image ) / Address_Id ( Address_Id ) ( for set selected address ), Device_Id, Device_Name, Device_Type, App_Version, App_Package, Device_Key, Address_Id, Mobile_No, Email_Id, Name, Profile_Image = FILES
        
        var paramer: [String: Any] = [:]
        paramer["Update_Type"] = "Address_Id"
        paramer["Address_Id"] = self.selectAddressId
        
        WebService.call.POSTT(filePath: global.shared.URL_Update_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status {
                    if status == "1" {
                        self.showAlertToast(message: "Address Update Successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.navigationController?.popViewController(animated: true)
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


extension AddressList_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Address_cell {
            let dict = self.arr_address[indexPath.row]
            cell.lbl_id.text = dict.landmark
            cell.lbl_address.text = dict.address
            cell.lbl_city.text = (dict.city ?? "") + " - " + (dict.postal_Code ?? "")
            if let select = dict.is_Selected {
                if select {
                    self.selectAddressId = dict.address_Id ?? ""
                    cell.vw_address.borderWidth = 1
                    cell.vw_address.borderColor = UIColor(named: "AccentColor")
                } else {
                    cell.vw_address.borderWidth = 0
                    cell.vw_address.borderColor = UIColor.clear
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = self.arr_address[indexPath.row].address_Id {
            self.selectAddressId = id
            if let cell = self.tbl_vw.cellForRow(at: indexPath) as? Address_cell {
                cell.vw_address.borderWidth = 1
                cell.vw_address.borderColor = UIColor(named: "AccentColor")
            }
            self.call_UpdateProfileAPI()
        }
    }
    
}
