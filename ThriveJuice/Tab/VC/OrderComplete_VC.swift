//
//  OrderComplete_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 11/09/23.
//

import UIKit

class OrderComplete_VC: UIViewController {

    
    @IBOutlet weak var lbl_OrderNo: UILabel!
    @IBOutlet weak var lbl_congr: UILabel!
    @IBOutlet weak var lbl_Earned: UILabel!
    
    var OrderId = String()
    var EarnRewardPoints = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelText = "Your order no #\(OrderId) \n has been successfully placed"
        let attributedText = NSMutableAttributedString(string: labelText)
        let specificTextStyle: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Jost-Bold", size: 16) as Any,
            .foregroundColor: UIColor(named: "AccentColor") as Any]
        let rangeToStyle = (labelText as NSString).range(of: "\(OrderId)")
        attributedText.addAttributes(specificTextStyle, range: rangeToStyle)
        self.lbl_OrderNo.attributedText = attributedText
        if let reward = Double(EarnRewardPoints) {
            if reward > 0 {
                self.lbl_congr.text = "Congratulations"
                let labelText1 = "You Earned \(EarnRewardPoints) Points \n You can use it for a discount on future orders"
                let attributedText1 = NSMutableAttributedString(string: labelText1)
                let specificTextStyle1: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Jost-Bold", size: 16) as Any,
                    .foregroundColor: UIColor(named: "AccentColor") as Any]
                let rangeToStyle1 = (labelText1 as NSString).range(of: "\(EarnRewardPoints)")
                attributedText1.addAttributes(specificTextStyle1, range: rangeToStyle1)
                self.lbl_Earned.attributedText = attributedText1
            } else {
                self.lbl_congr.text = ""
                self.lbl_Earned.text = ""
            }
        } else {
            self.lbl_congr.text = ""
            self.lbl_Earned.text = ""
        }
        
    }
    
    
    //MARK:- Button Action
    @IBAction func act_continueShopping(_ sender: UIButton) {
        let orders = self.storyboard?.instantiateViewController(withIdentifier: "Orders_VC") as! Orders_VC
        self.navigationController?.pushViewController(orders, animated: true)
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
