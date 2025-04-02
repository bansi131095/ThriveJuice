//
//  APIManager.swift
//  APIManager
//

// This class is use for API Parcing.

import Foundation

class APIManager
{
    static let sharedInstance = APIManager()
    
    
    func ServiceCall(method: String, url:String, parameter:String, completion: @escaping (_ dictionary: Any?, _ error: Error?) -> Void)
    {
        DispatchQueue.global(qos: .background).async {
            
            var request = URLRequest(url: URL(string:url)!)
            request.httpMethod = method
            global.shared.DeviceId = DeviceId.getDeviceID()
            var userId = String()
            if UserDefaults.standard.object(forKey: "u_id") != nil {
                userId = UserDefaults.standard.string(forKey: "u_id") ?? ""
                
            }
            var userType = String()
            if UserDefaults.standard.object(forKey: "u_type") != nil {
                userType = UserDefaults.standard.string(forKey: "u_type") ?? ""
            }
            var str_parameter = String()
            if userId != "" {
                str_parameter = "Accesskey=\(global.shared.Accesskey)&Device_Id=\(global.shared.DeviceId)&Device_Name=\(global.shared.Device_Name)&Device_Type=\(global.shared.Device_Type)&App_Version=\(global.shared.App_Version)&User_Id=\(userId)&User_Type=\(userType)&User_Client_Id="
            } else {
                str_parameter = "Accesskey=\(global.shared.Accesskey)&Device_Id=\(global.shared.DeviceId)&Device_Name=\(global.shared.Device_Name)&Device_Type=\(global.shared.Device_Type)&App_Version=\(global.shared.App_Version)"
            }
            let Parameter = str_parameter + parameter
            request.httpBody = Parameter.data(using: .utf8)
           
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {  // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    completion(nil, error)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    // make error here and then
                    completion(nil, error)
                    return
                }
                
               // let responseString = String(data: data, encoding: .utf8)
                
               // print("responseString = \(responseString!)")
                
                DispatchQueue.main.async {
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        
                        completion(jsonDictionary, nil)
                    }
                    catch {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
}
