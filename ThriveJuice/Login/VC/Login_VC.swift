//
//  Login_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 03/08/23.
//

import UIKit
import ObjectMapper
import FirebaseAuth


class Login_VC: UIViewController {

    
    @IBOutlet weak var txt_mobileNo: UITextField!
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_Signup(_ sender: UIButton) {
        let signUp = self.storyboard?.instantiateViewController(withIdentifier: "SignUp_VC") as! SignUp_VC
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    
    @IBAction func act_LoginWithOTP(_ sender: UIButton) {
//        let Otp = self.storyboard?.instantiateViewController(withIdentifier: "OTP_VC") as! OTP_VC
//        self.navigationController?.pushViewController(Otp, animated: true)
        if self.txt_mobileNo.text == "" {
            self.showAlertToast(message: "Please Enter Mobile Number")
        } else {
            self.call_LoginAPI()
        }
    }
    
    @IBAction func act_LoginWithEmailOrSocial(_ sender: UIButton) {
        let LoginSocial = self.storyboard?.instantiateViewController(withIdentifier: "LoginMobileNumber_VC") as! LoginMobileNumber_VC
        self.navigationController?.pushViewController(LoginSocial, animated: true)
    }
    
    
    
    //MARK:- API Call
    func call_LoginAPI() {
            
            var paramer: [String: Any] = [:]
        paramer["Mobile_No"] = self.txt_mobileNo.text ?? ""
        
        WebService.call.POSTT(filePath: global.shared.URL_LOGIN, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
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
                        self.navigationController?.pushViewController(OTPVC, animated: true)
                        // Sign in using the verificationID and the code sent to the user
                      // ...
                    }                    
                } else if eventResponseModel.status == "3" {
                    let mobileNo = self.storyboard?.instantiateViewController(withIdentifier: "MobileNo_VC") as! MobileNo_VC
                    mobileNo.UserId = eventResponseModel.user_Id ?? ""
                    self.navigationController?.pushViewController(mobileNo, animated: true)
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
