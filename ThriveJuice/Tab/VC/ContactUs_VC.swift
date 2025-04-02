//
//  ContactUs_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 29/09/23.
//

import UIKit
import GoogleMaps
import ObjectMapper


class ContactUs_VC: UIViewController {

    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var img_1: UIImageView!
    @IBOutlet weak var img_2: UIImageView!
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_question: UITextView!
    @IBOutlet weak var txt_question_height_const: NSLayoutConstraint!
    @IBOutlet weak var vw_map: UIView!
    
    var locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    let marker : GMSMarker = GMSMarker()
    var check_current = true
    var fullAdress : String = ""
    var address : String = ""
    var pincode : String = ""
    var MapView:GMSMapView = GMSMapView()
    var arr_settings: [Settings] = []
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.determineMyCurrentLocation()
        self.call_ContactUsDataAPI()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_Submit(_ sender: UIButton) {
        if self.txt_name.text == "" {
            self.showAlertToast(message: "Please provide name")
        } else if self.txt_email.text == "" {
            self.showAlertToast(message: "Please provide valid email")
        } else if self.txt_question.text == "" {
            self.showAlertToast(message: "Please provide message")
        } else {
            self.call_ContactUsAPI()
        }
    }
    
    @IBAction func act_fb(_ sender: UIButton) {
        for i in 0..<self.arr_settings.count {
            if let key = self.arr_settings[i].setting_Key {
                if key == "Follow_Us_FB" {
                    if let url = self.arr_settings[i].setting_Value {
                        guard let URl = URL(string: url) else {
                          return //be safe
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URl, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URl)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func act_instagram(_ sender: UIButton) {
        for i in 0..<self.arr_settings.count {
            if let key = self.arr_settings[i].setting_Key {
                if key == "Follow_Us_Insta" {
                    if let url = self.arr_settings[i].setting_Value {
                        guard let URl = URL(string: url) else {
                          return //be safe
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URl, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URl)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func act_twitter(_ sender: UIButton) {
        for i in 0..<self.arr_settings.count {
            if let key = self.arr_settings[i].setting_Key {
                if key == "Follow_Us_Twitter" {
                    if let url = self.arr_settings[i].setting_Value {
                        guard let URl = URL(string: url) else {
                          return //be safe
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URl, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URl)
                        }
                    }
                }
            }
        }
    }
    
    func setData() {
        if self.arr_settings.count != 0 {
            for i in 0..<self.arr_settings.count {
                if let key = self.arr_settings[i].setting_Key {
                    if key == "Find_Us" {
                        self.lbl_address.text = self.arr_settings[i].setting_Value
                    } else if key == "Contact_Us" {
                        if let val = self.arr_settings[i].setting_Value {
                            let split = val.components(separatedBy: "?")
                            self.lbl_phone.text = split[0]
                            self.lbl_email.text = split[1]
                        }
                    } else if key == "Contact_Us_Image_1" {
                        if let img = self.arr_settings[i].setting_Value, img != "" {
                            self.img_1.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                                // Your code inside completion block
                                if (error != nil) {
                                    // Failed to load image
                                } else {
                                    // Successful in loading image
                                    self.img_1.image = image
                                }
                            }
                        }
                    } else if key == "Contact_Us_Image_2" {
                        if let img = self.arr_settings[i].setting_Value, img != "" {
                            self.img_2.sd_setImage(with: URL(string: img)) { (image, error, cache, url) in
                                // Your code inside completion block
                                if (error != nil) {
                                    // Failed to load image
                                } else {
                                    // Successful in loading image
                                    self.img_2.image = image
                                }
                            }
                        }
                    } else if key == "Contact_Us_Location" {
                        if let val = self.arr_settings[i].setting_Value {
                            let split = val.components(separatedBy: ",")
                            let lat = CLLocationDegrees(split[0]) ?? userLatitude
                            let long = CLLocationDegrees(split[1]) ?? userLongitude
                            DispatchQueue.main.async
                            {
                                
                                let center = CLLocationCoordinate2D(latitude: lat ?? self.userLatitude, longitude: long ?? self.userLongitude)
                                self.MapView.camera = GMSCameraPosition(target: center, zoom: 13)
                                self.marker.position = center
                                self.marker.isFlat = false
                                self.marker.icon = #imageLiteral(resourceName: "location1")
                                self.marker.map = self.MapView
                            }
                        }
                    } else if key == "Store_Hours" {
                        if let val = self.arr_settings[i].setting_Value {
                            if val != "" {
                                self.lbl_content.attributedText = val.htmlToAttributedString
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    
    func call_ContactUsDataAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        
        WebService.call.POSTT(filePath: global.shared.URL_Contact_Us, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ContactUsModel = Mapper<ContactUsModel>().map(JSONObject: result) {
                if let arr = eventResponseModel.settings, arr.count != 0 {
                    self.arr_settings = arr
                    self.setData()
                }
            }
        }) {
            
        }
    }
    
    
    
    func call_ContactUsAPI() {
            
        // Offset, Type= Category, Category_Id, Product_Id
        var paramer: [String: Any] = [:]
        paramer["Name"] = self.txt_name.text ?? ""
        paramer["Email_Id"] = self.txt_email.text ?? ""
        paramer["Message"] = self.txt_question.text ?? ""
        
        WebService.call.POSTT(filePath: global.shared.URL_Contact_Us_Inquiry, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:StatusModel = Mapper<StatusModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                    self.txt_name.text = ""
                    self.txt_email.text = ""
                    self.txt_question.text = ""
                }
            }
        }) {
            
        }
    }
    
    //MARK:- Map function
    func determineMyCurrentLocation()
    {
        self.location()
    }
    
    //MARK:- display Map on view
    func location()
    {
        locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        if authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
            authorizationStatus == CLAuthorizationStatus.authorizedAlways {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
            self.MapView.setMinZoom(0, maxZoom: 20)
            if (self.locationManager.location != nil) {
                // do your things
                userLatitude = locationManager.location?.coordinate.latitude
                userLongitude = locationManager.location?.coordinate.longitude
                let camera = GMSCameraPosition.camera(withLatitude: userLatitude, longitude: userLongitude, zoom: 12)
                let options = GMSMapViewOptions()
                options.camera = camera
                options.frame = self.vw_map.bounds
                MapView = GMSMapView(options: options)
                //                self.vw_map = MapView
                self.vw_map.addSubview(MapView)
                MapView.delegate = self
                self.MapView.delegate = self
                let center = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
//                marker.position = center
//                marker.isFlat = false
//                marker.icon = #imageLiteral(resourceName: "location1")
//                marker.map = self.MapView
            } else { }
        } else { }
    }
    
    
    
    /*
     else if self.txt_question.text == "" || self.txt_question.text == LocalizationSystem.sharedInstance.localizedStringForKey(key: "Detailed description of the ticket", comment: "Detailed description of the ticket") {
         self.showAlertToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please provide ticket description", comment: "Please provide ticket description"))
     }
     */
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension ContactUs_VC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.txt_question {
            let sizeToFitIn = CGSize(width: self.txt_question.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = self.txt_question.sizeThatFits(sizeToFitIn)
            if newSize.height >= 100.0 {
                self.txt_question_height_const.constant = newSize.height
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.txt_question {
            if textView.text == "Enter Question / Message"  {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == self.txt_question {
            if textView.text.isEmpty {
                textView.text = "Enter Question / Message"
                textView.textColor = UIColor(named: "BorderColor")
            }
        }
        return true
    }
    
}


extension ContactUs_VC: CLLocationManagerDelegate {

    //MARK: FOR IOS 13
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        userLatitude = (self.locationManager.location?.coordinate.latitude)
        userLongitude = (self.locationManager.location?.coordinate.longitude)
        if self.locationManager.location == nil {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status
        {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.location()
            //print("A_lat:\(userLatitude!)")
            // print("A_long:\(userLongitude!)")
            //MapView.isMyLocationEnabled = true
            //MapView.settings.myLocationButton = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            self.location()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            if let settingUrl = URL(string:UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingUrl as URL)
                }
            }
            else {
                print("Setting URL invalid")
            }
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if #available(iOS 14.0, *) {
            print(manager.authorizationStatus.rawValue)
            if manager.authorizationStatus.rawValue == 2 {
                self.vw_map.isHidden = true
                DispatchQueue.main.async {
                    self.showAlertToast(message: "msglocation")
                }
                return
            }
        }
        print(error)
    }
    
}


extension ContactUs_VC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
}

