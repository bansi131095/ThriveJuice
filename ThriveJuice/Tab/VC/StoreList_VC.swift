//
//  StoreList_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 09/10/23.
//

import UIKit
import ObjectMapper


class StoreList_VC: UIViewController {

    @IBOutlet weak var vw_search: UIView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var tbl_vw: UITableView!
    
    var arr_Store: [Stores] = []
    var arr_AllStore: [Stores] = []
    var selectedStoreId = String()
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
        self.call_StoreListAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
      
    @IBAction func act_Search(_ sender: UIButton) {
        self.vw_search.isHidden = false
    }
    
    @IBAction func act_close(_ sender: UIButton) {
        self.vw_search.isHidden = true
    }
    
    //MARK:- API Call
    func call_StoreListAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Stores, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:StoreList = Mapper<StoreList>().map(JSONObject: result) {
                if let storeId = eventResponseModel.selected_Store_Id {
                    self.selectedStoreId = storeId
                }
                if let arr = eventResponseModel.stores, arr.count != 0 {
                    self.arr_Store = arr
                    self.arr_AllStore = arr
                    self.tbl_vw.register(UINib(nibName: "StoreList_cell", bundle: nil), forCellReuseIdentifier: "cell")
                    self.tbl_vw.delegate = self
                    self.tbl_vw.dataSource = self
                    self.tbl_vw.reloadData()
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_UpdateProfileAPI(selectStoreId: String) {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Update_Type"] = "Store_Id"
        paramer["Store_Id"] = selectStoreId
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Update_Profile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    UserDefaults.standard.setValue(selectStoreId, forKey: "SelectedStoreId")
                    self.navigationController?.popViewController(animated: true)
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


extension StoreList_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_Store.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StoreList_cell {
            let dict = self.arr_Store[indexPath.row]
            if let id = dict.user_Id {
                if self.selectedStoreId == id {
                    cell.vw_card.borderColor = UIColor(named: "AccentColor")
                } else {
                    cell.vw_card.borderColor = UIColor(named: "BorderColor")
                }
            }
            cell.lbl_Name.text = dict.name
            cell.lbl_Address.text = dict.store_Address
            cell.lbl_City.text = (dict.store_City ?? "") + " - " + (dict.store_Postal_Code ?? "")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StoreList_cell {
            if let id = self.arr_Store[indexPath.row].user_Id {
                self.selectedStoreId = id
                if userId != "" {
                    self.call_UpdateProfileAPI(selectStoreId: id)
                } else {
                    UserDefaults.standard.setValue(self.selectedStoreId, forKey: "SelectedStoreId")
                    self.navigationController?.popViewController(animated: true)
                }
                cell.vw_card.borderColor = UIColor(named: "AccentColor")
            }
        }
    }
    
}

extension StoreList_VC: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{

        let searchText  = textField.text! + string

        if searchText.count > 1 {
            self.arr_Store = self.arr_AllStore.filter({($0.name?.lowercased() ?? "").contains(searchText)})
            self.tbl_vw.reloadData()
        }
        else{
        }

        return true
    }
    
}
