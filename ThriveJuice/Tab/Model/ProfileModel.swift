/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct ProfileModel : Mappable {
	var status : String?
	var user : User?
	var message : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		status <- map["Status"]
		user <- map["User"]
		message <- map["Message"]
	}

}


struct User : Mappable {
    var user_Id : String?
    var user_Type : String?
    var mobile_No : String?
    var name : String?
    var email_Id : String?
    var profile_Image : String?
    var signup_Via : String?
    var social_Id : String?
    var _Address_Id : String?
    var addresses : [Addresses]?
    var earned_Reward : String?
    var order_Type : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user_Id <- map["User_Id"]
        user_Type <- map["User_Type"]
        mobile_No <- map["Mobile_No"]
        name <- map["Name"]
        email_Id <- map["Email_Id"]
        profile_Image <- map["Profile_Image"]
        signup_Via <- map["Signup_Via"]
        social_Id <- map["Social_Id"]
        _Address_Id <- map["_Address_Id"]
        addresses <- map["Addresses"]
        earned_Reward <- map["Earned_Reward"]
        order_Type <- map["Order_Type"]
    }

}


struct Addresses : Mappable {
    var address_Id : String?
    var city : String?
    var postal_Code : String?
    var landmark : String?
    var address : String?
    var address_Latitude : String?
    var address_Longitude : String?
    var is_Selected : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        address_Id <- map["Address_Id"]
        city <- map["City"]
        postal_Code <- map["Postal_Code"]
        landmark <- map["Landmark"]
        address <- map["Address"]
        address_Latitude <- map["Address_Latitude"]
        address_Longitude <- map["Address_Longitude"]
        is_Selected <- map["Is_Selected"]
    }

}
