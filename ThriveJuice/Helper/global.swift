//
//  global.swift
//  Easy Homes Realty
//
//  Created by My Mac on 5/1/17.
//  Copyright © 2017 ciestosolutions. All rights reserved.
//

import UIKit

class global: NSObject
{
    
    //MARK:- Global Variable
    static let shared: global = global()
    
    //MARK:- Url
    
    
//    GOOGLE_MAP_KEY_RUSH_MALL=AIzaSyDNE-nH7aaKw21nG3yVaDtPZQm-6yaqHh8
    
    static let base_url = "https://thrivejuiceco.ca/admin/"
    static let server_url = global.base_url + "API/"
    
    let Accesskey  = "THRIVE693JUICE753"
    let Device_Type = "IOS"
    var App_Version = Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""
    var App_Package = Bundle.main.infoDictionary?["CFBundleIdentifier"] ?? ""
    var selectCategoryId = String()
    var selectSubCategoryId = String()
    var arr_AmenityId: [String] = []
//    var arr_filters: [RequestList] = []
    var Address = String()
    var str_back = false
    var str_bookComplete = false
    var select_Index = 0
    var DeviceId = String() // DeviceId.getDeviceID()
    var Device_Name = UIDevice.modelName
    
    var arr_AddCartData: [CartData] = []
    var str_AddCartData = String()
    
// public_html/Food/Admin/Restaurant_Logo


    let PROFILE_IMG_PATH = global.base_url + "images/Profiles/"
    
    
    //Common Parameter
        
    //MARK:- Login & register
    var URL_LOGIN = global.server_url + "Login.php"
    // Accesskey, Mobile_No
    
    var URL_VerifyOTP = global.server_url + "Verify_OTP.php"
    // Mobile_No, OTP
    
    var URL_Sign_Up = global.server_url + "Sign_Up.php"
    // Email_Id, Name, Signup_Via = APP / FB / Google, Password, Social_Id
    
    var URL_Sign_Up_Update_Mobile = global.server_url + "Sign_Up_Update_Mobile.php"
    // Mobile_No, User_Id
    
    var URL_Forgot_Password = global.server_url + "Forgot_Password.php"
    // Mobile_No
    
    var URL_Forgot_Password_Verify = global.server_url + "Forgot_Password_Verify.php"
    // OTP,  User_Id (get from step-1)

    var URL_Forgot_Password_Update = global.server_url + "Forgot_Password_Update.php"
    // Password, User_Id (get from step-1 and 2)
    
    var URL_Change_Password = global.server_url + "Change_Password.php"
    // OTP, Password
    
    var URL_Dashboard = global.server_url + "Dashboard.php"
    //
   
    var URL_Products = global.server_url + "Products.php"
    // Offset, Type= Category/Wishlist, Category_Id, Product_Id,
    
    var URL_Product_Details = global.server_url + "Product_Details.php"
    // Product_Id
    
    var URL_Orders = global.server_url + "Orders.php"
    
    
    var URL_Order_Details = global.server_url + "Order_Details.php"
    // Order_Id
    
    var URL_Cart_Add = global.server_url + "Cart_Add.php"
    // Cart_Data = [{"Product_Id":"1","Cart_Qty":"2","Cart_Product_Size":"16oz"},{"Product_Id":"2","Cart_Qty":"2","Cart_Product_Size":"16oz"}]
    
    var URL_Cart = global.server_url + "Cart.php"
    // Coupon_Code, Order_Type = Local_Delivery / Store_Pickup, Subscribe_Week, Use_Reward_Points,
    
    var URL_Schedule_Dates = global.server_url + "Schedule_Dates.php"
    //
    
    var URL_Add_Order = global.server_url + "Add_Order.php"
    // Delivery_Date, Subscribe_Week, Order_Type = Local_Delivery / Store_Pickup
    
    var URL_StripepaymentAPI = global.base_url + "Stripe/paymentAPI-New.php"
    // Order_Id
    
    var URL_Complete_Order_Payment = global.server_url + "Complete_Order_Payment.php"
    // Order_Id
    
    var URL_Profile = global.server_url + "Profile.php"
    //
    
    var URL_Add_Address = global.server_url + "Add_Address.php"
    // Type = Add / Update / Delete ( Address_Id ), City, Address_Latitude, Address_Longitude, Postal_Code, Landmark, Address, Address_Id
    
    var URL_Update_Profile = global.server_url + "Update_Profile.php"
    // User_Id, User_Type, Accesskey, Update_Type = Device ( Device_Key ) / Logout / Delete_Account / Profile ( Name, Mobile_No, Email_Id ) / Profile_Image ( Profile_Image ) / Address_Id ( Address_Id ) ( for set selected address ), Device_Id, Device_Name, Device_Type, App_Version, App_Package, Device_Key, User_Id, Address_Id, Mobile_No, Email_Id, Name, Profile_Image = FILES
    
    var URL_Add_To_Wishlist = global.server_url + "Add_To_Wishlist.php"
    // Product_Id
    
    var URL_Cancel_Subscription = global.server_url + "Cancel_Subscription.php"
    // Order_Id
    
    var URL_Order_Cancel = global.server_url + "Order_Cancel.php"
    // Order_Id
    
    var URL_Notifications = global.server_url + "Notifications.php"
    //
    
    var URL_Categories = global.server_url + "Categories.php"
    //
    
    var URL_Rewards_Points = global.server_url + "Rewards_Points.php"
    //
    
    var URL_Stores = global.server_url + "Stores.php"
    //
    
    var URL_FAQ = global.server_url + "FAQ.php"
    // Category_Id
    
    var URL_Contact_Us = global.server_url + "Contact_Us.php"
    //
    
    var URL_Contact_Us_Inquiry = global.server_url + "Contact_Us_Inquiry.php"
    // Name, Email_Id, Message
    
    var URL_Offers = global.server_url + "Offers.php"
    
    //MARK:-
    override init()
    {
        
    }
    
    //MARK:- Global Function
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }


    func cleanCartDuplicates() {
        var uniqueCart: [CartData] = []

        for item in arr_AddCartData {
            if let index = uniqueCart.firstIndex(where: {
                $0.Product_Id == item.Product_Id &&
                $0.Cart_Product_Size == item.Cart_Product_Size &&
                $0.Cart_Days == item.Cart_Days &&
                $0.Cart_Addons == item.Cart_Addons
            }) {
                // If duplicate found, update quantity
                let existingQty = Int(uniqueCart[index].Cart_Qty) ?? 0
                let newQty = Int(item.Cart_Qty) ?? 0
                uniqueCart[index].Cart_Qty = String(existingQty + newQty)
            } else {
                // Add as unique entry
                uniqueCart.append(item)
            }
        }

        arr_AddCartData = uniqueCart
    }

    
    /*
     print(distance(Double(32.9697), lon1: Double(-96.80322), lat2: Double(29.46786), lon2: Double(-98.53506), unit: "M"), "Miles")
     print(distance(Double(32.9697), lon1: Double(-96.80322), lat2: Double(29.46786), lon2: Double(-98.53506), unit: "K"), "Kilometers")
     print(distance(Double(32.9697), lon1: Double(-96.80322), lat2: Double(29.46786), lon2: Double(-98.53506), unit: "N"), "Nautical Miles")
     */
}



