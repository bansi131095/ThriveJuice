//
//  AddNewAddress_VC.swift
//  ThriveJuice
//
//  Created by MacBook on 16/08/23.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import ObjectMapper
import DropDown
import Foundation


class MapTitleCell : UITableViewCell{
    
    @IBOutlet weak var lblMapTitle: UILabel!
}


class AddNewAddress_VC: UIViewController {

    
    @IBOutlet weak var map_vw: UIView!
    @IBOutlet weak var map_height_const: NSLayoutConstraint!
//    @IBOutlet weak var lbl_currentLocation: UILabel!
    @IBOutlet weak var txt_FlatName: CustomTextField!
    @IBOutlet weak var txt_city: CustomTextField!
    @IBOutlet weak var txt_Pincode: CustomTextField!
    
    @IBOutlet weak var txt_SearchLocation: CustomTextField!
    @IBOutlet weak var txt_Address: UITextView!
    @IBOutlet weak var txt_AddressHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var tblTopConst: NSLayoutConstraint!
    @IBOutlet weak var tblAddressHeight: NSLayoutConstraint!
    @IBOutlet weak var vwPoweredby: UIView!
    
    
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgOffice: UIImageView!
    @IBOutlet weak var imgWork: UIImageView!
    
    
    
    
    var locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    let marker : GMSMarker = GMSMarker()
    var check_current = true
    var fullAdress : String = ""
    var address : String = ""
    var pincode : String = ""
    var MapView:GMSMapView = GMSMapView()
    
    var str_edit = false
    var dictAddresss: Addresses?
    
    var suggestions: [String] = []
    var isKeyboardVisible = false
    
    let placeholderText = "Falt/House No., Street Name, Area"
    let placeholderColor = UIColor.lightGray
    let textColor = UIColor.black
    var Landmark = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_FlatName.delegate = self
        self.txt_city.delegate = self
        self.txt_Pincode.delegate = self
        self.determineMyCurrentLocation()
        
        self.txt_Address.font = UIFont(name: "Jost-Regular", size: 12)
        self.txt_Address.textColor = UIColor.black
        self.txt_Address.delegate = self
//        self.setupPlaceholder()
        adjustTextViewHeight()
        
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.isHidden = true
        vwPoweredby.isHidden = true
        
        tblAddress.layer.shadowColor = UIColor(red: 0.15, green: 0.16, blue: 0.18, alpha: 0.2).cgColor
        tblAddress.layer.shadowOffset = CGSize(width: 0, height: 4)
        tblAddress.layer.shadowOpacity = 1
        tblAddress.layer.shadowRadius = 12
        tblAddress.layer.masksToBounds = true
//        tblAddress.layer.cornerRadius = 8
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           // Ensure address text view displays multiple lines
           self.adjustTextViewHeight()
       }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*@IBAction func act_Change(_ sender: UIButton) {
        self.autocompleteClicked()
    }*/
    
    @IBAction func act_Home(_ sender: Any) {
        Landmark = "Home"
        imgHome.image = UIImage(named: "Check")
        imgWork.image = UIImage(named: "Uncheck")
        imgOffice.image = UIImage(named: "Uncheck")
    }
    
    @IBAction func act_Office(_ sender: Any) {
        Landmark = "Office"
        imgHome.image = UIImage(named: "Uncheck")
        imgOffice.image = UIImage(named: "Check")
        imgWork.image = UIImage(named: "Uncheck")
    }
    
    @IBAction func act_Work(_ sender: Any) {
        Landmark = "Work"
        imgHome.image = UIImage(named: "Uncheck")
        imgOffice.image = UIImage(named: "Uncheck")
        imgWork.image = UIImage(named: "Check")
    }
    
    
    @IBAction func act_SavePickupAddress(_ sender: UIButton) {
        if self.txt_city.text == "" {
            self.showAlertToast(message: "Please provide city")
        } else if self.txt_Pincode.text == "" {
            self.showAlertToast(message: "Please provide postal code")
        } else {
            if str_edit {
                self.call_AddAddress(type: "Update")
            } else {
                self.call_AddAddress(type: "Add")
            }
        }
    }
    
    // MARK: - Keyboard handlers
    @objc func keyboardWillShow(notification: Notification) {
        isKeyboardVisible = true
        print("🔼 Keyboard Opened")
    }

    @objc func keyboardWillHide(notification: Notification) {
        isKeyboardVisible = false
//        tblTopConst.constant = 5
        self.tblAddress.isHidden = true
        self.vwPoweredby.isHidden = true
        print("🔽 Keyboard Closed")
    }
    
    
    //MARK: - Map function
    func determineMyCurrentLocation()    {
        self.location()
        self.adjustTextViewHeight()
    }
    
    
    //MARK:- display Map on view
    func location()
    {
        locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = self.locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
            if authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
            authorizationStatus == CLAuthorizationStatus.authorizedAlways {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
            self.MapView.setMinZoom(0, maxZoom: 20)
            if self.str_edit {
                if let dict = self.dictAddresss {
                    if let lat = CLLocationDegrees(dict.address_Latitude ?? ""), let long = CLLocationDegrees(dict.address_Longitude ?? "") {
                        self.userLatitude = lat
                        self.userLongitude = long
                        
                        let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                        let options = GMSMapViewOptions()
                        options.camera = camera
                        options.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 340)
                        self.MapView = GMSMapView(options: options)
                        //                self.vw_map = MapView
                        self.map_vw.addSubview(self.MapView)
                        self.MapView.delegate = self
                        self.MapView.delegate = self
                        let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                        self.marker.position = center
                        self.marker.isFlat = true
                        self.marker.icon = #imageLiteral(resourceName: "location1")
                        self.marker.map = self.MapView
                    }
                    self.txt_Address.text = dict.address
                    self.adjustTextViewHeight()
                    self.txt_FlatName.text = dict.landmark
                    /*if dict.landmark == "Home"{
                        self.Landmark = "Home"
                        self.imgHome.image = UIImage(named: "Check")
                        self.imgWork.image = UIImage(named: "Uncheck")
                        self.imgOffice.image = UIImage(named: "Uncheck")
                    }else if dict.landmark == "Work"{
                        self.Landmark = "Work"
                        self.imgHome.image = UIImage(named: "Uncheck")
                        self.imgWork.image = UIImage(named: "Check")
                        self.imgOffice.image = UIImage(named: "Uncheck")
                    }else if dict.landmark == "Office"{
                        self.Landmark = "Office"
                        self.imgHome.image = UIImage(named: "Uncheck")
                        self.imgWork.image = UIImage(named: "Uncheck")
                        self.imgOffice.image = UIImage(named: "Check")
                    }else{
                        self.Landmark = "Home"
                        self.imgHome.image = UIImage(named: "Check")
                        self.imgWork.image = UIImage(named: "Uncheck")
                        self.imgOffice.image = UIImage(named: "Uncheck")
                    }*/
                    self.txt_city.text = dict.city
                    self.txt_Pincode.text = dict.postal_Code
                }
            } else {
                if (self.locationManager.location != nil) {
                    // do your things
                    self.userLatitude = self.locationManager.location?.coordinate.latitude
                    self.userLongitude = self.locationManager.location?.coordinate.longitude
                    let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                    let options = GMSMapViewOptions()
                    options.camera = camera
                    options.frame = self.map_vw.bounds
                    self.MapView = GMSMapView(options: options)
                    //                self.vw_map = MapView
                    self.map_vw.addSubview(self.MapView)
                    self.MapView.delegate = self
                    self.MapView.delegate = self
                    let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                    self.marker.position = center
                    self.marker.isFlat = true
                    self.marker.icon = #imageLiteral(resourceName: "location1")
                    self.marker.map = self.MapView
                } else { }
            }
            
        } else {
            if self.str_edit {
                if let dict = self.dictAddresss {
                    if let lat = CLLocationDegrees(dict.address_Latitude ?? ""), let long = CLLocationDegrees(dict.address_Longitude ?? "") {
                        self.userLatitude = lat
                        self.userLongitude = long
                        
                        let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                        let options = GMSMapViewOptions()
                        options.camera = camera
                        options.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 340)
                        self.MapView = GMSMapView(options: options)
                        //                self.vw_map = MapView
                        self.map_vw.addSubview(self.MapView)
                        self.MapView.delegate = self
                        self.MapView.delegate = self
                        let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                        self.marker.position = center
                        self.marker.isFlat = true
                        self.marker.icon = #imageLiteral(resourceName: "location1")
                        self.marker.map = self.MapView
                    }
                    self.txt_Address.text = dict.address
                    self.adjustTextViewHeight()
                    /*if dict.landmark == "Home"{
                        self.Landmark = "Home"
                        self.imgHome.image = UIImage(named: "Check")
                        self.imgWork.image = UIImage(named: "Uncheck")
                        self.imgOffice.image = UIImage(named: "Uncheck")
                    }else if dict.landmark == "Work"{
                        self.Landmark = "Work"
                        self.imgHome.image = UIImage(named: "Uncheck")
                        self.imgWork.image = UIImage(named: "Check")
                        self.imgOffice.image = UIImage(named: "Uncheck")
                    }else if dict.landmark == "Office"{
                        self.Landmark = "Office"
                        self.imgHome.image = UIImage(named: "Uncheck")
                        self.imgWork.image = UIImage(named: "Uncheck")
                        self.imgOffice.image = UIImage(named: "Check")
                    }else{
                        self.Landmark = "Home"
                        self.imgHome.image = UIImage(named: "Check")
                        self.imgWork.image = UIImage(named: "Uncheck")
                        self.imgOffice.image = UIImage(named: "Uncheck")
                    }*/
                    self.txt_city.text = dict.city
                    self.txt_Pincode.text = dict.postal_Code
                }
            }else{
                self.userLatitude = 52.1259096161503
                self.userLongitude = -106.67167916893959
                let camera = GMSCameraPosition.camera(withLatitude: self.userLatitude, longitude: self.userLongitude, zoom: 15)
                let options = GMSMapViewOptions()
                options.camera = camera
                options.frame = self.map_vw.bounds
                self.MapView = GMSMapView(options: options)
                //                self.vw_map = MapView
                self.map_vw.addSubview(self.MapView)
                self.MapView.delegate = self
                self.MapView.delegate = self
                let center = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                self.marker.position = center
                self.marker.isFlat = true
                self.marker.icon = #imageLiteral(resourceName: "location1")
                self.marker.map = self.MapView
            }
//            self.showLocationPermissionAlert()
            
        }
        }
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Location Permission Required",
                                      message: "Please enable location access in Settings to use this feature.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                // Pop the current view controller
                self.navigationController?.popViewController(animated: true)
            }))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            
            if let appSettings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Map Function
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        /*geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                
                return
            }
            // 3
            self.txt_Address.text = lines.joined(separator: "\n")
            self.adjustTextViewHeight()
            self.txt_city.text = response?.firstResult()?.locality
            self.txt_Pincode.text = response?.firstResult()?.postalCode
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }*/
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines,
                !lines.isEmpty
            else {
                return
            }

            // Example: lines[0] = "137 20th Street West, Saskatoon, Sk S7M 0W7, Canada"
            // Split by comma and take the first part
            let fullLine = lines[0]
            let components = fullLine.components(separatedBy: ",")
            let streetOnly = components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            DispatchQueue.main.async {
                self.txt_Address.text = streetOnly
                self.txt_city.text = address.locality
                self.txt_Pincode.text = address.postalCode
                self.adjustTextViewHeight()

                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
//        filter.country = "IN"
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView) {
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        /*geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                                print("Address : \(address!)")
                if self.check_current {
                    self.txt_Address.text = address
                    self.adjustTextViewHeight()
                    self.txt_city.text = result?.locality
                    self.txt_Pincode.text = result?.postalCode
                } else {
                    print(address ?? "")
                }
            }
        }*/
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            if let error = error {
                print("GMSReverseGeocode Error: \(error.localizedDescription)")
                return
            }

            guard let result = response?.results()?.first else {
                print("No address found")
                return
            }

            // Option 1: Get street using subThoroughfare + thoroughfare
            let streetNumber = result.subLocality ?? ""
            let streetName = result.thoroughfare ?? ""
            let streetAddress = "\(streetNumber) \(streetName)".trimmingCharacters(in: .whitespaces)

            // Option 2: fallback if thoroughfare data is missing, use first part of lines
            var fallbackAddress: String = ""
            if let lines = result.lines, let firstLine = lines.first {
                let components = firstLine.components(separatedBy: ",")
                fallbackAddress = components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }

            let finalAddress = streetAddress.isEmpty ? fallbackAddress : streetAddress

            print("Street Address: \(finalAddress)")

            if self.check_current {
                self.txt_Address.text = finalAddress
                self.adjustTextViewHeight()
                self.txt_city.text = result.locality
                self.txt_Pincode.text = result.postalCode
            } else {
                print(finalAddress)
            }
        }
    }
    
    func call_AddAddress(type: String) {
        // Type = Add / Update / Delete ( Address_Id ), City, Address_Latitude, Address_Longitude, Postal_Code, Landmark, Address, Address_Id
        
        var paramer: [String: Any] = [:]
        paramer["Type"] = type
        paramer["City"] = self.txt_city.text ?? ""
        paramer["Address_Latitude"] = String(userLatitude)
        paramer["Address_Longitude"] = String(userLongitude)
        paramer["Postal_Code"] = self.txt_Pincode.text ?? ""
        paramer["Landmark"] = self.txt_FlatName.text ?? ""
        paramer["Address"] = self.txt_Address.text ?? ""
        if type == "Update" {
            paramer["Address_Id"] = self.dictAddresss?.address_Id ?? ""
        }
        
        
        WebService.call.POSTT(filePath: global.shared.URL_Add_Address, params: paramer, enableInteraction: false, showLoader: true, viewObj: self, onSuccess: { [self] (result, success) in
            print(result)
            if let eventResponseModel:ProfileModel = Mapper<ProfileModel>().map(JSONObject: result) {
                if let status = eventResponseModel.status, status == "1" {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlertToast(message: eventResponseModel.message ?? "")
                }
            }
        }) {
            
        }
    }

    func fetchPlaceSuggestions(input: String, completion: @escaping ([String]) -> Void) {
        let apiKey = "AIzaSyA07KPtrWrl_4GlOVCGHp5RPDYmZZGewWA" // Replace with your own API key
        let baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        
        // Encode the input
        guard let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode input")
            completion([])
            return
        }

        // Build the URL
        let urlString = "\(baseUrl)?input=\(encodedInput)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion([])
            return
        }

        // Perform the network request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network error
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion([])
                return
            }

            // Ensure we received data
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }

            do {
                // Try parsing JSON response
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let predictions = json["predictions"] as? [[String: Any]] {
                    
                    let suggestions = predictions.compactMap { $0["description"] as? String }
                    completion(suggestions)
                } else {
                    print("Invalid JSON structure or 'predictions' key missing")
                    completion([])
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion([])
            }
        }

        task.resume()
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


extension AddNewAddress_VC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let customTextField = textField as? CustomTextField {
            customTextField.setUnderlineColor(UIColor(named: "AccentColor") ?? .tintColor) // Change to your desired color
        }
    }

    // UITextFieldDelegate method - called when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let customTextField = textField as? CustomTextField {
            customTextField.setUnderlineColor(.lightGray) // Reset to the original color
        }
    }
    
}


// MARK: - CLLocationManagerDelegate
extension AddNewAddress_VC: CLLocationManagerDelegate {

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
                self.map_vw.isHidden = true
                DispatchQueue.main.async {
                    self.showAlertToast(message: "msglocation")
                }
                return
            }
        }
        print(error)
    }
    
}

extension AddNewAddress_VC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.wrapperFunctionToShowPosition(mapView: mapView)
        marker.position = position.target
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
}


extension AddNewAddress_VC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        self.dismiss(animated: true, completion: nil)
        self.userLatitude = place.coordinate.latitude
        self.userLongitude = place.coordinate.longitude
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.icon = #imageLiteral(resourceName: "location1")
        marker.isFlat = true
        marker.map = self.MapView
        self.SetUpMap()
        //            Pickmarker.isDraggable = true
        self.reverseGeocode(coordinate: place.coordinate)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func SetUpMap() {
        let camera = GMSCameraPosition.camera(withLatitude:self.userLatitude, longitude: self.userLongitude, zoom: 16)
        self.MapView.camera = camera
//        self.map_vw.bringSubviewToFront(self.img_pin)
    }
    
    func moveMapToCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        MapView.animate(to: camera)
        
        marker.position = coordinate
        marker.map = MapView
    }
    
    
}
/*extension AddNewAddress_VC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = ""
            textView.textColor = textColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            suggestions.removeAll()
            tblAddress.reloadData()
            tblAddress.isHidden = true
        } else {
            fetchPlaceSuggestions(input: textView.text) { predictions in
                DispatchQueue.main.async {
                    self.suggestions = predictions
                    self.tblAddress.reloadData()
                    self.tblAddress.isHidden = predictions.isEmpty
                }
            }
        }
        adjustTextViewHeight()
    }
    
    func adjustTextViewHeight() {
       // Calculate the height of the content
        let size = txt_Address.sizeThatFits(CGSize(width: txt_Address.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
       // Update the height constraint
            txt_AddressHeight.constant = size.height
       self.view.layoutIfNeeded()  // Animate and update the layout
    }
}*/

extension AddNewAddress_VC : UITextViewDelegate{
    func setupPlaceholder() {
        txt_Address.text = placeholderText
        txt_Address.textColor = placeholderColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, !text.isEmpty else {
            suggestions.removeAll()
            DispatchQueue.main.async {
                self.tblAddress.reloadData()
                self.tblAddress.isHidden = true
                self.vwPoweredby.isHidden = true
            }
            return
        }
        if isKeyboardVisible {
            tblTopConst.constant = -180
            print("✅ Keyboard is open while typing")
        }else{
            print("❌ Keyboard is closed (possibly dismissed)")
        }
        
        fetchPlaceSuggestions(input: text) { predictions in
            DispatchQueue.main.async {
                self.suggestions = predictions
                self.tblAddress.reloadData()
                self.vwPoweredby.isHidden = false
                self.tblAddress.isHidden = predictions.isEmpty
//                self.tblAddressHeight.constant = CGFloat(predictions.count * 44)
            }
        }
        adjustTextViewHeight()
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        adjustTextViewHeight()
        return true
    }
    
    func adjustTextViewHeight() {
       // Calculate the height of the content
        let size = txt_Address.sizeThatFits(CGSize(width: txt_Address.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
       // Update the height constraint
            txt_AddressHeight.constant = size.height
       self.view.layoutIfNeeded()  // Animate and update the layout
    }
    
    // When the user begins editing, remove the placeholder if it's there
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = textColor
        }
    }
    
    // When the user finishes editing, show the placeholder if the text is empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }
}

extension AddNewAddress_VC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblAddress.dequeueReusableCell(withIdentifier: "MapTitleCell", for: indexPath) as? MapTitleCell
        let prediction = suggestions[indexPath.row]
        cell?.lblMapTitle.text = prediction
        return cell!
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = suggestions[indexPath.row]
        txt_SearchLocation.text = selectedSuggestion
        suggestions.removeAll()
        tblAddress.reloadData()
        tblAddress.isHidden = true
        vwPoweredby.isHidden = true
        // Optional: fetch coordinates using Places API
        let placesClient = GMSPlacesClient.shared()
        placesClient.findAutocompletePredictions(fromQuery: selectedSuggestion, filter: nil, sessionToken: nil) { (results, error) in
            if let placeID = results?.first?.placeID {
                placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.coordinate, .formattedAddress], sessionToken: nil) { (place, error) in
                    if let place = place {
                        self.userLatitude = place.coordinate.latitude
                        self.userLongitude = place.coordinate.longitude
                        self.txt_Address.text = place.formattedAddress
                        print("Place:- \(place.formattedAddress ?? "")")
                        self.adjustTextViewHeight()
                        self.moveMapToCoordinate(place.coordinate)
                    }
                }
            }
        }
    }

}

