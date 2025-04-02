//
//  RewardPoints_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 17/08/23.
//

import UIKit
import ObjectMapper


class RewardPoints_VC: UIViewController {

    
    @IBOutlet weak var tbl_vw: UITableView!
    @IBOutlet weak var lbl_EarnedPoints: UILabel!
    @IBOutlet var lbl_availablePoints: UILabel!
    @IBOutlet weak var vw_EmptyData: UIView!
    
    var arr_rewardsList: [Reward_Points] = []
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_vw.register(UINib(nibName: "RewardPoints_Cell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tbl_vw.delegate = self
        self.tbl_vw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_RewardsPointsAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK:- API Call
    func call_RewardsPointsAPI() {
            
        let paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Rewards_Points, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:RewardListModel = Mapper<RewardListModel>().map(JSONObject: result) {
                if let points = eventResponseModel.earned_Reward {
                    self.lbl_EarnedPoints.text = points + " Points"
                }
                if let Availablepoints = eventResponseModel.available_Reward {
                    self.lbl_availablePoints.text = Availablepoints + " Points"
                }
                if let list = eventResponseModel.reward_Points, list.count != 0 {
                    self.arr_rewardsList = list
                    self.tbl_vw.reloadData()
                    self.tbl_vw.isHidden = false
                    self.vw_EmptyData.isHidden = true
                } else {
                    self.tbl_vw.isHidden = true
                    self.vw_EmptyData.isHidden = false
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


extension RewardPoints_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_rewardsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RewardPoints_Cell {
            let data = self.arr_rewardsList[indexPath.row]
            cell.lbl_note.text = data.reward_Points_Comment
            if let points = data.reward_Points, let doubleval = Double(points) {
                cell.lbl_rewardsPoints.text = points + " Points"
                if doubleval > 0 {
                    cell.lbl_rewardsPoints.textColor = UIColor(named: "Green")
                } else {
                    cell.lbl_rewardsPoints.textColor = UIColor(named: "Red")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
