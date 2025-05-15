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


class AddNewAddress_VC: UIViewController {

    
    @IBOutlet weak var map_vw: UIView!
    @IBOutlet weak var map_height_const: NSLayoutConstraint!
    @IBOutlet weak var lbl_currentLocation: UILabel!
    @IBOutlet weak var txt_FlatName: CustomTextField!
    @IBOutlet weak var txt_city: CustomTextField!
    @IBOutlet weak var txt_Pincode: CustomTextField!
    
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
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt_FlatName.delegate = self
        self.txt_city.delegate = self
        self.txt_Pincode.delegate = self
        self.determineMyCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func act_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func act_Change(_ sender: UIButton) {
        self.autocompleteClicked()
    }
    
    @IBAction func act_SavePickupAddress(_ sender: UIButton) {
        if self.txt_FlatName.text == "" {
            self.showAlertToast(message: "Please provide nearby location")
        } else if self.txt_city.text == "" {
            self.showAlertToast(message: "Please provide City")
        } else if self.txt_Pincode.text == "" {
            self.showAlertToast(message: "Please provide Pincode")
        } else {
            if str_edit {
                self.call_AddAddress(type: "Update")
            } else {
                self.call_AddAddress(type: "Add")
            }
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
                    self.lbl_currentLocation.text = dict.address
                    self.txt_FlatName.text = dict.landmark
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
            self.showLocationPermissionAlert()
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
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                
                return
            }
            // 3
            self.lbl_currentLocation.text = lines.joined(separator: "\n")
            self.txt_city.text = response?.firstResult()?.locality
            self.txt_Pincode.text = response?.firstResult()?.postalCode
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
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
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                //                print("Address : \(address!)")
                if self.check_current {
                    self.lbl_currentLocation.text = address
                    self.txt_city.text = result?.locality
                    self.txt_Pincode.text = result?.postalCode
                } else {
                    print(address ?? "")
                }
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
        paramer["Address"] = self.lbl_currentLocation.text ?? ""
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
    
    
}
