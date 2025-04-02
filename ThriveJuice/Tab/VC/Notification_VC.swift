//
//  Notification_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 18/09/23.
//

import UIKit
import ObjectMapper

class Notification_VC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    
    var arr_notification: [Notifications] = []
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.call_NotificationAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- API Call
    func call_NotificationAPI() {
            
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Notifications, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:NotificationModel = Mapper<NotificationModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.notifications {
                    self.arr_notification = arr
                    self.tbl_vw.register(UINib(nibName: "Notification_cell", bundle: nil), forCellReuseIdentifier: "cell")
                    self.tbl_vw.delegate = self
                    self.tbl_vw.dataSource = self
                    self.tbl_vw.reloadData()
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


extension Notification_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbl_vw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Notification_cell
        let data = self.arr_notification[indexPath.row]
        cell.lbl_title.text = data.notification_Message
        cell.lbl_date.text = data.notification_Created_At
        return cell
    }

    
}
