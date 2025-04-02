//
//
//
//
//  Created by Ilesh's 2018 on 30/09/19.
//  Copyright © 2019 Ilesh's. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

class WebService: NSObject {
    
    static let call : WebService = WebService()
    
    var isPrintLogs : Bool = true
    
    // CLOSUER DECLARATION
    typealias Success = (_ responseData: Any, _ success: Bool) -> Void
    typealias GoogleSuccess = (_ success: Bool) -> Void
    
    typealias Failure = () -> Void
    typealias FailureData = (_ Error:String, _ Flag:Bool) -> Void
    
}

/**
 @METHODS:- METHODS FOR CHECK INTERNET CONNECTION
 **/

extension WebService {
    func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

/**
 @METHODS:- BASIC METHODS FOR CALLING API.
 **/

extension WebService {
    
    func GET(filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIViewController?, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            viewObj?.show_alert(msg: "Internet not available, Cross check your internet connectivity and try again")
            return
        }
        
    
        let strPath = filePath
        var viewSpinner: UIView?
        if (showLoader) {
            viewObj?.showProgressBar()
//            viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        self.isPrintLogs ? print("URL:- \(strPath) \nPARAM:- \(String(describing: params))") : nil
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        var userType = String()
        if UserDefaults.standard.object(forKey: "u_type") != nil {
            userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
        }
        var UserClientId = String()
        if UserDefaults.standard.object(forKey: "u_ClientId") != nil {
            UserClientId = UserDefaults.standard.string(forKey: "u_ClientId") ?? ""
        }
        var TimeStamp = String()
        if UserDefaults.standard.object(forKey: "timeStamp") != nil {
            TimeStamp = UserDefaults.standard.string(forKey: "timeStamp") ?? ""
        }
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var SelectedStoreId = String()
        if UserDefaults.standard.object(forKey: "SelectedStoreId") != nil {
            SelectedStoreId = UserDefaults.standard.string(forKey: "SelectedStoreId") ?? ""
        }
        var headers : HTTPHeaders = []
        var parameter: [String:Any] = params!
        if userId != "" {
            headers = [
                "Timestamp": TimeStamp,
            ]
            print("Header : \(headers)")
            parameter["Accesskey"] = global.shared.Accesskey
            parameter["Device_Id"] = global.shared.DeviceId
            parameter["Device_Name"] = global.shared.Device_Name
            parameter["Device_Type"] = global.shared.Device_Type
            parameter["App_Version"] = global.shared.App_Version
            parameter["User_Id"] = userId
            parameter["User_Type"] = userType
            parameter["User_Client_Id"] = UserClientId
        } else {
            headers = []
            parameter["Accesskey"] = global.shared.Accesskey
            parameter["Device_Id"] = global.shared.DeviceId
            parameter["Device_Name"] = global.shared.Device_Name
            parameter["Device_Type"] = global.shared.Device_Type
            parameter["App_Version"] = global.shared.App_Version
            parameter["Selected_Store_Id"] = SelectedStoreId
            parameter["Order_Type"] = OrderType
        }
        
        AF.request(strPath,method: .get,parameters: parameter, encoding: URLEncoding.default , headers: headers).responseJSON { (response) in
            
            if (showLoader) {
                viewObj?.hideProgressBar()
//                IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            
            debugPrint(response)
            if response.error == nil {
                if let resjson = response.value as? [String:Any] {
                    print("Json File --> \(resjson)")
                    
                    if let code = resjson["code"] as? Int {
                        if code == 200  || code == 400 {
                            onSuccess(resjson, true)
                        } else {
                            viewObj?.show_alert(msg: "No Internet Connection Available")
                            onFailure()
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    func POSTZIPFILE(filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIViewController?, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            viewObj?.show_alert(msg: "Internet not available, Cross check your internet connectivity and try again")
            return
        }
       
        let strPath = filePath
        var viewSpinner: UIView?
        if (showLoader) {
            viewObj?.showProgressBar()
//            viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        self.isPrintLogs ? print("URL:- \(strPath) \nPARAM:- \(String(describing: params))") : nil
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
            
        }
        var userType = String()
        if UserDefaults.standard.object(forKey: "u_type") != nil {
            userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
        }
        var UserClientId = String()
        if UserDefaults.standard.object(forKey: "u_ClientId") != nil {
            UserClientId = UserDefaults.standard.string(forKey: "u_ClientId") ?? ""
        }
        var TimeStamp = String()
        if UserDefaults.standard.object(forKey: "timeStamp") != nil {
            TimeStamp = UserDefaults.standard.string(forKey: "timeStamp") ?? ""
        }
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var SelectedStoreId = String()
        if UserDefaults.standard.object(forKey: "SelectedStoreId") != nil {
            SelectedStoreId = UserDefaults.standard.string(forKey: "SelectedStoreId") ?? ""
        }
        var headers : HTTPHeaders = []
        var parameter: [String:Any] = [:]
        if userId != "" {
            headers = [
                "Timestamp": TimeStamp,
            ]
            parameter = [
                "Accesskey" : global.shared.Accesskey,
                "Device_Id": global.shared.DeviceId,
                "Device_Name": global.shared.Device_Name,
                "Device_Type": global.shared.Device_Type,
                "App_Version": global.shared.App_Version,
                "User_Id": userId,
                "User_Type": userType,
                "User_Client_Id": UserClientId
            ]
        } else {
            headers = []
            parameter = [
                "Accesskey" : global.shared.Accesskey,
                "Device_Id": global.shared.DeviceId,
                "Device_Name": global.shared.Device_Name,
                "Device_Type": global.shared.Device_Type,
                "App_Version": global.shared.App_Version,
                "Selected_Store_Id": SelectedStoreId,
                "Order_Type": OrderType
            ]
        }
        
        AF.request(strPath,method: .post,parameters: params, encoding: URLEncoding.default , headers: headers).responseJSON { (response) in
            
            if (showLoader) {
                viewObj?.hideProgressBar()
//                IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            
            debugPrint(response)
                        if response.error == nil {
                            if let resjson = response.value as? [String:Any] {
                                print("Json File --> \(resjson)")
                                
                                if let code = resjson["CODE"] as? Int {
                                    if code == 200  || code == 400 {
                                        onSuccess(resjson, true)
                                    } else {
                                        viewObj?.show_alert(msg: "No Internet Connection Available")
                                        onFailure()
                                    }
                                }
                            }
                        }
            
        
            
        }
    
    }
    
    func POST(filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIViewController?, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            viewObj?.show_alert(msg: "Internet not available, Cross check your internet connectivity and try again")
            return
        }
        
       
        let strPath = filePath
        var viewSpinner: UIView?
        if (showLoader) {
            viewObj?.showProgressBar()
//            viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        self.isPrintLogs ? print("URL:- \(strPath) \nPARAM:- \(String(describing: params))") : nil
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
            
        }
        var userType = String()
        if UserDefaults.standard.object(forKey: "u_type") != nil {
            userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
        }
        var UserClientId = String()
        if UserDefaults.standard.object(forKey: "u_ClientId") != nil {
            UserClientId = UserDefaults.standard.string(forKey: "u_ClientId") ?? ""
        }
        var TimeStamp = String()
        if UserDefaults.standard.object(forKey: "timeStamp") != nil {
            TimeStamp = UserDefaults.standard.string(forKey: "timeStamp") ?? ""
        }
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var SelectedStoreId = String()
        if UserDefaults.standard.object(forKey: "SelectedStoreId") != nil {
            SelectedStoreId = UserDefaults.standard.string(forKey: "SelectedStoreId") ?? ""
        }
        var headers : HTTPHeaders = []
        var parameter: [String:Any] = [:]
        if userId != "" {
            headers = [
                "Timestamp": TimeStamp,
            ]
            parameter = [
                "Accesskey" : global.shared.Accesskey,
                "Device_Id": global.shared.DeviceId,
                "Device_Name": global.shared.Device_Name,
                "Device_Type": global.shared.Device_Type,
                "App_Version": global.shared.App_Version,
                "User_Id": userId,
                "User_Type": userType,
                "User_Client_Id": UserClientId
            ]
        } else {
            headers = []
            parameter = [
                "Accesskey" : global.shared.Accesskey,
                "Device_Id": global.shared.DeviceId,
                "Device_Name": global.shared.Device_Name,
                "Device_Type": global.shared.Device_Type,
                "App_Version": global.shared.App_Version,
                "Selected_Store_Id": SelectedStoreId,
                "Order_Type": OrderType
            ]
        }
        AF.request(strPath,method: .post,parameters: params, encoding: URLEncoding.default , headers: headers).responseJSON { (response) in
            
            if (showLoader) {
                viewObj?.hideProgressBar()
//                IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            
            debugPrint(response)
                        if response.error == nil {
                            if let resjson = response.value as? [String:Any] {
                                print("Json File --> \(resjson)")
                                
                                if let code = resjson["code"] as? Int {
                                    if code == 200  || code == 400 {
                                        onSuccess(resjson, true)
                                    } else {
                                        viewObj?.show_alert(msg: "No Internet Connection Available")
                                        onFailure()
                                    }
                                }
                            }
                        }
            
        
            
        }
    
    }
    
    
    
    func POSTT(filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIViewController?, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            viewObj?.show_alert(msg: "Internet not available, Cross check your internet connectivity and try again")
            return
        }
        
       
        let strPath = filePath
//        var viewSpinner: UIView?
        if (showLoader) {
            viewObj?.showProgressBar()
//            viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        self.isPrintLogs ? print("URL:- \(strPath) \nPARAM:- \(String(describing: params))") : nil
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
        }
        var userType = String()
        if UserDefaults.standard.object(forKey: "u_type") != nil {
            userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
        }
        var TimeStamp = String()
        if UserDefaults.standard.object(forKey: "timeStamp") != nil {
            TimeStamp = UserDefaults.standard.string(forKey: "timeStamp") ?? ""
        }
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var SelectedStoreId = String()
        if UserDefaults.standard.object(forKey: "SelectedStoreId") != nil {
            SelectedStoreId = UserDefaults.standard.string(forKey: "SelectedStoreId") ?? ""
        }
        var headers : HTTPHeaders = []
        var parameter: [String:Any] = params!
        if userId != "" {
            headers = [
                "Timestamp": TimeStamp,
            ]
            print("Header : \(headers)")
            parameter["Accesskey"] = global.shared.Accesskey
            parameter["Device_Id"] = global.shared.DeviceId
            parameter["Device_Name"] = global.shared.Device_Name
            parameter["Device_Type"] = global.shared.Device_Type
            parameter["App_Version"] = global.shared.App_Version
            parameter["App_Package"] = global.shared.App_Package
            parameter["User_Id"] = userId
            parameter["User_Type"] = userType
        } else {
            headers = []
            parameter["Accesskey"] = global.shared.Accesskey
            parameter["Device_Id"] = global.shared.DeviceId
            parameter["Device_Name"] = global.shared.Device_Name
            parameter["Device_Type"] = global.shared.Device_Type
            parameter["App_Version"] = global.shared.App_Version
            parameter["App_Package"] = global.shared.App_Package
            parameter["Selected_Store_Id"] = SelectedStoreId
            parameter["Order_Type"] = OrderType
        }
        AF.request(strPath,method: .post,parameters: parameter, encoding: URLEncoding.default , headers: headers).responseJSON { (response) in
            
            if (showLoader) {
                viewObj?.hideProgressBar()
//                IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            
            debugPrint(response)
            if response.error == nil {
                if let resjson = response.value as? [String:Any] {
    //                                print("Json File --> \(resjson)")
                    if let code = resjson["Status"] as? String {
                        if code == "1" {
                            onSuccess(resjson, true)
                        } else if code == "-1" {
                            onSuccess(resjson, true)
                        } else if code == "0" {
                            onSuccess(resjson, true)
                        } else if code == "2" {
                            onSuccess(resjson, true)
                        }  else if code == "3" {
                            onSuccess(resjson, true)
                        } else {
                            viewObj?.show_alert(msg: "No Internet Connection Available")
                            onFailure()
                        }
                    } else if response.response?.statusCode == 200 {
                        onSuccess(resjson, true)
                    }
                }
            }
        }
    
    }
    
    
    func FilePOST(filePath: String, params: [String: Any]?, url: URL?  ,  enableInteraction: Bool, showLoader: Bool, viewObj: UIViewController?, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            viewObj?.show_alert(msg: "Internet not available, Cross check your internet connectivity and try again")
            return
        }
        
       
        let strPath = filePath
//        var viewSpinner: UIView?
        if (showLoader) {
            viewObj?.showProgressBar()
//            viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        self.isPrintLogs ? print("URL:- \(strPath) \nPARAM:- \(String(describing: params))") : nil
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
            
        }
        var userType = String()
        if UserDefaults.standard.object(forKey: "u_type") != nil {
            userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
        }
        var UserClientId = String()
        if UserDefaults.standard.object(forKey: "u_ClientId") != nil {
            UserClientId = UserDefaults.standard.string(forKey: "u_ClientId") ?? ""
        }
        var TimeStamp = String()
        if UserDefaults.standard.object(forKey: "timeStamp") != nil {
            TimeStamp = UserDefaults.standard.string(forKey: "timeStamp") ?? ""
        }
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var SelectedStoreId = String()
        if UserDefaults.standard.object(forKey: "SelectedStoreId") != nil {
            SelectedStoreId = UserDefaults.standard.string(forKey: "SelectedStoreId") ?? ""
        }
        var headers : HTTPHeaders = []
        var parameter: [String:Any] = [:]
        if userId != "" {
            headers = [
                "Timestamp": TimeStamp,
            ]
            parameter = [
                "Accesskey" : global.shared.Accesskey,
                "Device_Id": global.shared.DeviceId,
                "Device_Name": global.shared.Device_Name,
                "Device_Type": global.shared.Device_Type,
                "App_Version": global.shared.App_Version,
                "User_Id": userId,
                "User_Type": userType,
                "User_Client_Id": UserClientId
            ]
        } else {
            headers = []
            parameter = [
                "Accesskey" : global.shared.Accesskey,
                "Device_Id": global.shared.DeviceId,
                "Device_Name": global.shared.Device_Name,
                "Device_Type": global.shared.Device_Type,
                "App_Version": global.shared.App_Version,
                "Selected_Store_Id": SelectedStoreId,
                "Order_Type": OrderType
            ]
        }
        AF.upload(multipartFormData: { multipartFormData in

            if let urll = url {
                do {
                    let datas = try Data(contentsOf: urll as URL)
                    var nameEx = ""
                    nameEx = urll.pathExtension
                    print("pathExtension :- \(nameEx)")
                    multipartFormData.append(datas, withName: "courier_slip_image", fileName: "courier_slip_image."+nameEx, mimeType: "application/pdf")
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
            
            
            for (key, value) in params! {
//                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                if JSONSerialization.isValidJSONObject(value) {
                    let array = value as! [String]
                    var i:Int = 0
                    for string in array {
                        if let stringData = string.data(using: .utf8) {
                            multipartFormData.append(stringData, withName: key+"[]")
                            print("key:\(key+"[\(i)]") & value : \(string)" )
                        }
                        i += 1
                    }
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                    print("key:\(key) & value : \(value)" )
                }
            }
        
            
        }, to: strPath, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
           
            if (showLoader) {
                viewObj?.hideProgressBar()
//                IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            
           
            if data.error == nil {
                if let resjson = data.value as? [String:Any] {
                    print("Json File --> \(resjson)")
                    
                    if let code = resjson["code"] as? Int {
                        if code == 200  || code == 400 {
                            onSuccess(resjson, true)
                        } else {
                            viewObj?.show_alert(msg: "No Internet Connection Available")
                            onFailure()
                        }
                    }
                }
            }
        })
    
    }
    
    
    func ImagePOST(filePath: String, params: [String: Any]?, image: UIImage?, fileparam: String, enableInteraction: Bool, showLoader: Bool, viewObj: UIViewController?, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            viewObj?.show_alert(msg: "Internet not available, Cross check your internet connectivity and try again")
            return
        }
        
       
        let strPath = filePath
        var viewSpinner: UIView?
        if (showLoader) {
            viewObj?.showProgressBar()
//            viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        self.isPrintLogs ? print("URL:- \(strPath) \nPARAM:- \(String(describing: params))") : nil
        var userId = String()
        if UserDefaults.standard.object(forKey: "u_id") != nil {
            userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
            
        }
        var userType = String()
        if UserDefaults.standard.object(forKey: "u_type") != nil {
            userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
        }
        var UserClientId = String()
        if UserDefaults.standard.object(forKey: "u_ClientId") != nil {
            UserClientId = UserDefaults.standard.string(forKey: "u_ClientId") ?? ""
        }
        var TimeStamp = String()
        if UserDefaults.standard.object(forKey: "timeStamp") != nil {
            TimeStamp = UserDefaults.standard.string(forKey: "timeStamp") ?? ""
        }
        var OrderType = String()
        if UserDefaults.standard.object(forKey: "orderType") != nil {
            OrderType = UserDefaults.standard.string(forKey: "orderType") ?? ""
        }
        var SelectedStoreId = String()
        if UserDefaults.standard.object(forKey: "SelectedStoreId") != nil {
            SelectedStoreId = UserDefaults.standard.string(forKey: "SelectedStoreId") ?? ""
        }
        var headers : HTTPHeaders = []
        var parameter: [String:Any] = params!
        if userId != "" {
            headers = [
                "Timestamp": TimeStamp,
            ]
            
            parameter["Accesskey"] = global.shared.Accesskey
            parameter["Device_Id"] = global.shared.DeviceId
            parameter["Device_Name"] = global.shared.Device_Name
            parameter["Device_Type"] = global.shared.Device_Type
            parameter["App_Version"] = global.shared.App_Version
            parameter["User_Id"] = userId
            parameter["User_Type"] = userType
            parameter["User_Client_Id"] = UserClientId
            
        } else {
            headers = []
            parameter["Accesskey"] = global.shared.Accesskey
            parameter["Device_Id"] = global.shared.DeviceId
            parameter["Device_Name"] = global.shared.Device_Name
            parameter["Device_Type"] = global.shared.Device_Type
            parameter["App_Version"] = global.shared.App_Version
            parameter["Selected_Store_Id"] = SelectedStoreId
            parameter["Order_Type"] = OrderType
        }
        AF.upload(multipartFormData: { multipartFormData in

            if let img = image {
                let data = img.compress(to: 400)
//                guard let imgData = img.pngData() else { return }
                multipartFormData.append(data, withName: fileparam, fileName: "upload.png", mimeType: "image/png")
            }
            
            
            for (key, value) in params! {
//                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                if JSONSerialization.isValidJSONObject(value) {
                    let array = value as! [String]
                    var i:Int = 0
                    for string in array {
                        if let stringData = string.data(using: .utf8) {
                            multipartFormData.append(stringData, withName: key+"[]")
                            print("key:\(key+"[\(i)]") & value : \(string)" )
                        }
                        i += 1
                    }
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                    print("key:\(key) & value : \(value)" )
                }
            }
        
            
        }, to: strPath, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
           
            if (showLoader) {
                viewObj?.hideProgressBar()
//                IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            
           
            if data.error == nil {
                if let resjson = data.value as? [String:Any] {
                    print("Json File --> \(resjson)")
                    if let code = resjson["Status"] as? String {
                        if code == "1" {
                            onSuccess(resjson, true)
                        } else if code == "-1" {
                            onSuccess(resjson, true)
                        } else if code == "0" {
                            onSuccess(resjson, true)
                        } else if code == "2" {
                            onSuccess(resjson, true)
                        } else {
                            viewObj?.show_alert(msg: "No Internet Connection Available")
                            onFailure()
                        }
                    }else if data.response?.statusCode == 200 {
                        onSuccess(resjson, true)
                    }
                }
            }
        })
    
    }
    


}

public extension UIDevice {
    
    /// pares the deveice name as the standard name
    var modelName: String {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
    
}
