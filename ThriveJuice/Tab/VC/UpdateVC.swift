//
//  UpdateVC.swift
//  ThriveJuice
//
//  Created by MacBook on 24/07/25.
//

import UIKit

class UpdateVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwUpdate: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    
    //MARK: - Global Variable
    var loginres: VersionModel?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if loginres != nil {
            lblTitle.text = loginres?.Message_IOS ?? ""
            lblTitle.sizeToFit()
            
            if loginres?.Update_Show_IOS == 1 {
                self.vwUpdate.isHidden = false
            }else{
                self.vwUpdate.isHidden = true
            }
            
            if loginres?.Skip_Show_IOS == 1 {
                self.btnSkip.isHidden = false
            }else{
                self.btnSkip.isHidden = true
            }
        }
    }
    
    @IBAction func btnUpdateNow_Action(_ sender: Any) {
        self.openExernalLink(site: URL(string: global.shared.AppShareLink))
    }
    
    
    @IBAction func btnSkip_Action(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension UIViewController {
    func openExernalLink(site:URL?) {
        if site == nil {return}
        let appplink : URL = site!
        if UIApplication.shared.canOpenURL(appplink){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appplink, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appplink)
            }
        }
        else {
            self.show_alert(msg: "")
        }
    }
    
//    func ShowFirstTime() {
//        let filter = self.storyboard?.instantiateViewController(withIdentifier: "SelectOrderType_VC") as! SelectOrderType_VC
//        filter.modalPresentationStyle = .overFullScreen
//        self.present(filter, animated: true)
//    }
}

