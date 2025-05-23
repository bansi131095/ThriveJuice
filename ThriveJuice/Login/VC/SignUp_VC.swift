//
//  SignUp_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 03/08/23.
//

import UIKit
import ObjectMapper
import GoogleSignIn
import FirebaseCore
import FirebaseAuth


class SignUp_VC: UIViewController {

    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var btn_terms: UIButton!
    
    var str_terms = true
    var googleId = ""
    var googleIdToken = ""
    var googleName = ""
    var googleEmail = ""
    var googleProfileURL = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_LoginPage(_ sender: UIButton) {
        let Login = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
        self.navigationController?.pushViewController(Login, animated: true)
    }
    
    @IBAction func act_SignUp(_ sender: UIButton) {
        if self.txt_name.text == "" {
            self.showAlertToast(message: "Please Enter Name")
        } else if self.txt_email.text == "" {
            self.showAlertToast(message: "Please Enter Email")
        } else if self.txt_Password.text == "" {
            self.showAlertToast(message: "Please Enter Password")
        } else {
            self.call_SignUpAPI(socialId: "")
        }
    }
    
    @IBAction func act_Facebook(_ sender: UIButton) {
    }
    
    @IBAction func act_Google(_ sender: UIButton) {
        //        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            guard error == nil else { return }

          // If sign in succeeded, display the app's main content View.
            guard let signInResult = signInResult else { return }
            let user = signInResult.user

            self.googleEmail = user.profile?.email ?? ""
            self.googleName = user.profile?.name ?? ""
            self.googleId = user.userID ?? ""
            self.call_SignUpAPI(socialId: self.googleId)
            
        }
    }
    
    @IBAction func act_terms(_ sender: UIButton) {
        if str_terms {
            self.str_terms = false
            self.btn_terms.setImage(UIImage(named: "RdUnCheck"), for: .normal)
        } else {
            self.str_terms = true
            self.btn_terms.setImage(UIImage(named: "RdCheck"), for: .normal)
        }
    }
    

    //MARK:- API Call
    func call_SignUpAPI() {
          
        // Email_Id, Name, Signup_Via = APP / FB / Google, Password, Social_Id
        
        var paramer: [String: Any] = [:]
        paramer["Email_Id"] = self.txt_email.text ?? ""
        paramer["Name"] = self.txt_name.text ?? ""
        paramer["Password"] = self.txt_Password.text ?? ""
        paramer["Signup_Via"] = "APP"
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Sign_Up, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
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
                  /*  let number = "+1" + (self.txt_mobileNo.text ?? "")
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
                    } */
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
    
    
    func call_SignUpAPI(socialId: String) {
          
        // Email_Id, Name, Signup_Via = APP / FB / Google, Password, Social_Id
        
        var paramer: [String: Any] = [:]
        paramer["Email_Id"] = self.googleEmail
        paramer["Name"] = self.googleName
        if socialId != "" {
            paramer["Social_Id"] = socialId
            paramer["Signup_Via"] = "Google"
        }
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Sign_Up, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { (result, success) in
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
                   /* let number = "+1" + (self.txt_mobileNo.text ?? "")
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
                    } */
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
