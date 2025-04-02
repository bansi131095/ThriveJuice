//
//  MobileNo_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 03/08/23.
//

import UIKit
import ObjectMapper
import FirebaseAuth


class MobileNo_VC: UIViewController {

    
    @IBOutlet weak var txt_MobileNo: UITextField!
    
    var UserId = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_SignUp(_ sender: UIButton) {
        if self.txt_MobileNo.text == "" {
            self.showAlertToast(message: "Please Enter Mobile Number")
        } else {
            self.call_SignUpAPI()
        }
    }
    
    @IBAction func act_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- API Call
    func call_SignUpAPI() {
          
        // Mobile_No, User_Id
        
        var paramer: [String: Any] = [:]
        paramer["Mobile_No"] = self.txt_MobileNo.text ?? ""
        paramer["User_Id"] = self.UserId
        
        WebService.call.POSTT(filePath: global.shared.URL_Sign_Up_Update_Mobile, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:LoginModel = Mapper<LoginModel>().map(JSONObject: result) {
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
                } else if eventResponseModel.status == "2" {
//                    let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTP_VC") as! OTP_VC
//                    OTPVC.MobileNumber = self.txt_MobileNo.text ?? ""
//                    OTPVC.UserId = self.UserId
//                    self.navigationController?.pushViewController(OTPVC, animated: true)
                    let number = "+1" + (self.txt_MobileNo.text ?? "")
                    PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                        let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTP_VC") as! OTP_VC
                        OTPVC.MobileNumber = self.txt_MobileNo.text ?? ""
                        OTPVC.UserId = eventResponseModel.user_Id ?? ""
                        self.navigationController?.pushViewController(OTPVC, animated: true)
                        // Sign in using the verificationID and the code sent to the user
                      // ...
                    }       
                } else if eventResponseModel.status == "3" {
                    
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
