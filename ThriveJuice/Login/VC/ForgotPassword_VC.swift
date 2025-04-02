//
//  ForgotPassword_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 27/09/23.
//

import UIKit
import ObjectMapper
import FirebaseAuth


class ForgotPassword_VC: UIViewController {

    @IBOutlet weak var txt_mobileNo: UITextField!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_sendOTP(_ sender: Any) {
        if self.txt_mobileNo.text == "" {
            self.showAlertToast(message: "Please provide mobile number")
        } else {
            self.call_ForgotPswAPI()
        }
    }
    
    @IBAction func act_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- API Call
    func call_ForgotPswAPI() {
          
        // Mobile_No, User_Id
        
        var paramer: [String: Any] = [:]
        paramer["Mobile_No"] = self.txt_mobileNo.text ?? ""
        
        WebService.call.POSTT(filePath: global.shared.URL_Forgot_Password, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:LoginModel = Mapper<LoginModel>().map(JSONObject: result) {
                if eventResponseModel.status == "1" {
                    
                } else if eventResponseModel.status == "2" {
                    let number = "+1" + (self.txt_mobileNo.text ?? "")
                    PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                        let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTP_VC") as! OTP_VC
                        OTPVC.MobileNumber = self.txt_mobileNo.text ?? ""
                        OTPVC.UserId = eventResponseModel.user_Id ?? ""
                        OTPVC.str_forgot = true
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
