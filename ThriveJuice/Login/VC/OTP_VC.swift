//
//  OTP_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 03/08/23.
//

import UIKit
import FirebaseAuth
import ObjectMapper


class OTP_VC: UIViewController {

    @IBOutlet weak var txt_1: UITextField!
    @IBOutlet weak var txt_2: UITextField!
    @IBOutlet weak var txt_3: UITextField!
    @IBOutlet weak var txt_4: UITextField!
    @IBOutlet weak var txt_5: UITextField!
    @IBOutlet weak var txt_6: UITextField!
    @IBOutlet weak var lbl_timer: UILabel!
    @IBOutlet weak var btn_resend: UIButton!
    
    var str_forgot = false
    var MobileNumber = String()
    var OTP = String()
    var UserId = String()
    var Password = String()
    var timer: Timer?
    var countdown: Int = 60
    var str_changePsw = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_1.tag = 1
        txt_2.tag = 2
        txt_3.tag = 3
        txt_4.tag = 4
        txt_5.tag = 5
        txt_6.tag = 6
        self.btn_resend.isHidden = true
        self.startTimer()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_Verify(_ sender: UIButton) {
        if txt_1.text != "" && txt_2.text != "" && txt_3.text != "" && txt_4.text != "" && txt_5.text != "" && txt_6.text != "" {
            var otpStr = txt_1.text! + txt_2.text!
            otpStr.append(txt_3.text! + txt_4.text!)
            otpStr.append(txt_5.text! + txt_6.text!)
            if otpStr != ""
            {
                self.OTP = otpStr;
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
            let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otpStr)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    print(error)
                    return
                }
                if self.str_forgot {
                    self.call_ForgotPswOTPAPI()
                } else if self.str_changePsw {
                    self.call_ChangePswAPI()
                } else {
                    self.call_OTPAPI()
                }
              // User is signed in
              // ...
            }
            
                    
            }
        } else {
            self.showAlertToast(message: "Please Enter 6 Digit OTP")
        }
    }
    
    
    @IBAction func act_Resend(_ sender: UIButton) {
        if self.str_forgot {
            self.call_ForgotPswAPI()
        } else {
            
        }
    }
    
    func startTimer() {
        self.btn_resend.isHidden = true // Hide the button initially
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
        guard let self = self else { return }

        // Decrement the countdown and update the UI
            self.countdown -= 1
            self.lbl_timer.text = "00 : \(self.countdown)"

        // Check if the countdown has reached 0
            if self.countdown == 0 {
            // Stop the timer when the countdown is complete
                self.btn_resend.isHidden = false
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
   
    
    //MARK:- API Call
    func call_OTPAPI() {
            
        var paramer: [String: Any] = [:]
        paramer["Mobile_No"] = self.MobileNumber
        paramer["OTP"] = "1122"
        paramer["User_Id"] = self.UserId
        
        WebService.call.POSTT(filePath: global.shared.URL_VerifyOTP, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
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
    
    //Resend OTP
    func call_ForgotPswAPI() {
          
        // Mobile_No, User_Id
        
        var paramer: [String: Any] = [:]
        paramer["Mobile_No"] = self.MobileNumber
        
        WebService.call.POSTT(filePath: global.shared.URL_Forgot_Password, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
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
                    self.startTimer()
                } else if eventResponseModel.status == "3" {
                    
                } else {
                    self.show_alert(msg: eventResponseModel.message ?? "")
                }
            }
        }) {
            
        }
            
    }
    
    func call_ForgotPswOTPAPI() {
            
        var paramer: [String: Any] = [:]
        paramer["OTP"] = "1122"
        paramer["User_Id"] = self.UserId
        
        WebService.call.POSTT(filePath: global.shared.URL_Forgot_Password_Verify, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:LoginModel = Mapper<LoginModel>().map(JSONObject: result) {
                if eventResponseModel.status == "1" {
//                    let sb = UIStoryboard(name: "Home", bundle:nil)
//                    let navigation = sb.instantiateViewController(withIdentifier: "Navigate_home") as! UINavigationController
//                    navigation.modalPresentationStyle = .fullScreen
//                    self.present(navigation, animated: true)
                    let changePsw = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword_VC") as! ChangePassword_VC
                    changePsw.UserId = self.UserId
                    self.navigationController?.pushViewController(changePsw, animated: true)
                } else {
                    self.show_alert(msg: eventResponseModel.message ?? "")
                }
            }
        }) {
            
        }
            
    }
    
    
    func call_ChangePswAPI() {
            
        var paramer: [String: Any] = [:]
        paramer["OTP"] = "1122"
        paramer["Password"] = self.Password
        
        WebService.call.POSTT(filePath: global.shared.URL_Change_Password, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
            print(result)
            if let eventResponseModel:LoginModel = Mapper<LoginModel>().map(JSONObject: result) {
                if eventResponseModel.status == "1" {
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


extension OTP_VC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_4 {
            textField.resignFirstResponder()
            textField.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if let previousTextField = view.viewWithTag(textField.tag - 1) as? UITextField {
                previousTextField.becomeFirstResponder()
            }
            textField.text = string
            return false
        }
        
        // Allow only one character per text field
        if let text = textField.text, text.count >= 1 {
            if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
                nextTextField.text = string
                if (nextTextField.tag == 6) {
                    nextTextField.endEditing(true)
                }
            }
            return false
        }
        
        return true
    }
    
}
