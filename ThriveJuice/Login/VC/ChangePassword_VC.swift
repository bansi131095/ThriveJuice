//
//  ChangePassword_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 18/08/23.
//

import UIKit
import ObjectMapper
import FirebaseAuth


class ChangePassword_VC: UIViewController {

    
    
    @IBOutlet weak var txt_newPsw: UITextField!
    @IBOutlet weak var txt_confirmPsw: UITextField!
    
    var UserId = String()
    var str_forgot = false
    var MobileNo = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func act_Change(_ sender: UIButton) {
        if self.txt_newPsw.text == "" {
            self.showAlertToast(message: "Please enter password")
        } else if self.txt_newPsw.text != self.txt_confirmPsw.text {
            self.showAlertToast(message: "New password & confirm password are not matched")
        } else {
            if str_forgot {
                self.call_ChangePasswordAPI()
            } else {
                let number = "+1" + (MobileNo)
                PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    let OTP = self.storyboard?.instantiateViewController(withIdentifier: "OTP_VC") as! OTP_VC
                    OTP.str_changePsw = true
                    self.navigationController?.pushViewController(OTP, animated: true)
                    
                    // Sign in using the verificationID and the code sent to the user
                  // ...
                }
            }
        }
    }
    
    
    //MARK:- API Call
    func call_ChangePasswordAPI() {
            
        var paramer: [String: Any] = [:]
        paramer["Password"] = self.txt_confirmPsw.text ?? ""
        paramer["User_Id"] = self.UserId
        
        WebService.call.POSTT(filePath: global.shared.URL_Forgot_Password_Update, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:OTPVerifyModel = Mapper<OTPVerifyModel>().map(JSONObject: result) {
                if eventResponseModel.status == "1" {
                    if let time = eventResponseModel.timestamp {
                        UserDefaults.standard.setValue(time, forKey: "timeStamp")
                    }
                    if let UserId = eventResponseModel.user_Id {
                        UserDefaults.standard.setValue(UserId, forKey: "u_id")
                    }
                    if let UserType = eventResponseModel.user_Type {
                        UserDefaults.standard.setValue(UserType, forKey: "u_type")
                    }
                    let sb = UIStoryboard(name: "Home", bundle:nil)
                    let navigation = sb.instantiateViewController(withIdentifier: "Navigate_home") as! UINavigationController
                    navigation.modalPresentationStyle = .fullScreen
                    self.present(navigation, animated: true)
                } else {
                    self.show_alert(msg: eventResponseModel.message ?? "")
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
