/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct CartModel : Mappable {
	var status : String?
	var message : String?
	var cart_Data_Price : [Cart_Data_Price]?
	var cart_Data : [Cart_Data]?
	var cart_Products : [Cart_Products]?
	var cart_Product_Total : String?
	var shipping_Charge : String?
	var tax_PST_Charge : String?
	var tax_GST_Charge : String?
	var tax_Charge : String?
	var discount_Amount : String?
	var coupon_Id : String?
	var available_Reward_Points : String?
    var available_Reward_Amount : String?
	var available_Reward_Points_Rate : String?
    var minimum_Point_Usage: String?
	var reward_Points_Amount : String?
	var reward_Points : String?
    var reward_Amount : String?
    var earn_Reward_Points : String?
	var subscribe_Weeks : [Subscribe_Weeks]?
	var subscribe_Percentage : String?
	var subscribe_Amount : String?
	var subscribe_Discount_Amount : String?
    var bottle_Environment_Fees : String?
	var grand_Total : String?
	var stores : [Stores]?
	var selected_Stores : Selected_Stores?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		status <- map["Status"]
		message <- map["Message"]
		cart_Data_Price <- map["Cart_Data_Price"]
		cart_Data <- map["Cart_Data"]
		cart_Products <- map["Cart_Products"]
		cart_Product_Total <- map["Cart_Product_Total"]
		shipping_Charge <- map["Shipping_Charge"]
		tax_PST_Charge <- map["Tax_PST_Charge"]
		tax_GST_Charge <- map["Tax_GST_Charge"]
		tax_Charge <- map["Tax_Charge"]
		discount_Amount <- map["Discount_Amount"]
		coupon_Id <- map["Coupon_Id"]
		available_Reward_Points <- map["Available_Reward_Points"]
        minimum_Point_Usage <- map["Minimum_Point_Usage"]
        available_Reward_Amount <- map["Available_Reward_Amount"]
		available_Reward_Points_Rate <- map["Available_Reward_Points_Rate"]
		reward_Points_Amount <- map["Reward_Points_Amount"]
		reward_Points <- map["Reward_Points"]
        reward_Amount <- map["Reward_Amount"]
        earn_Reward_Points <- map["Earn_Reward_Points"]
		subscribe_Weeks <- map["Subscribe_Weeks"]
		subscribe_Percentage <- map["Subscribe_Percentage"]
		subscribe_Amount <- map["Subscribe_Amount"]
		subscribe_Discount_Amount <- map["Subscribe_Discount_Amount"]
        bottle_Environment_Fees <- map["Bottle_Environment_Fees"]
		grand_Total <- map["Grand_Total"]
		stores <- map["Stores"]
		selected_Stores <- map["Selected_Stores"]
	}

}

struct Cart_Data_Price : Mappable {
    var product_Id : String?
    var cart_Product_Size : String?
    var cart_Days : String?
    var cart_Addons : String?
    var cart_Qty : String?
    var product_Price : String?
    var product_Addon_Price : String?
    var cart_Addons_Price : [String]?
    var cart_Product_Price : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Id <- map["Product_Id"]
        cart_Product_Size <- map["Cart_Product_Size"]
        cart_Days <- map["Cart_Days"]
        cart_Addons <- map["Cart_Addons"]
        cart_Qty <- map["Cart_Qty"]
        product_Price <- map["Product_Price"]
        product_Addon_Price <- map["Product_Addon_Price"]
        cart_Addons_Price <- map["Cart_Addons_Price"]
        cart_Product_Price <- map["Cart_Product_Price"]
    }

}

struct Cart_Products : Mappable {
    var product_Id : String?
    var product_Name : String?
    var product_Image : [String]?
    var product_Size : [Product_Size]?
    var _Category_Id : String?
    var is_Only_Store_Pickup : String?
    var category_Name : String?
    var category_Id : String?
    var is_Special : String?
    var product_Addons : [Product_Addons]?
    var is_Available : Int?
    var product_Addon_Price : String?
    var cart_Addons_Price : [Addons]?
    var product_Price : String?
    var cart_Product_Base_Price : String?
    var cart_Product_Price : String?
    var cart_Qty : String?
    var cart_Product_Size : String?
    var cart_Days : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Id <- map["Product_Id"]
        product_Name <- map["Product_Name"]
        product_Image <- map["Product_Image"]
        product_Size <- map["Product_Size"]
        _Category_Id <- map["_Category_Id"]
        is_Only_Store_Pickup <- map["Is_Only_Store_Pickup"]
        category_Name <- map["Category_Name"]
        category_Id <- map["Category_Id"]
        is_Special <- map["Is_Special"]
        product_Addons <- map["Product_Addons"]
        is_Available <- map["Is_Available"]
        product_Addon_Price <- map["Product_Addon_Price"]
        cart_Addons_Price <- map["Cart_Addons_Price"]
        product_Price <- map["Product_Price"]
        cart_Product_Base_Price <- map["Cart_Product_Base_Price"]
        cart_Product_Price <- map["Cart_Product_Price"]
        cart_Qty <- map["Cart_Qty"]
        cart_Product_Size <- map["Cart_Product_Size"]
        cart_Days <- map["Cart_Days"]
    }

}


struct Selected_Stores : Mappable {
    var user_Id : String?
    var name : String?
    var store_Address : String?
    var store_City : String?
    var store_Postal_Code : String?
    var store_PST : String?
    var store_GST : String?
    var _Store_Category_Ids : String?
    var store_Latitude : String?
    var store_Longitude : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user_Id <- map["User_Id"]
        name <- map["Name"]
        store_Address <- map["Store_Address"]
        store_City <- map["Store_City"]
        store_Postal_Code <- map["Store_Postal_Code"]
        store_PST <- map["Store_PST"]
        store_GST <- map["Store_GST"]
        _Store_Category_Ids <- map["_Store_Category_Ids"]
        store_Latitude <- map["Store_Latitude"]
        store_Longitude <- map["Store_Longitude"]
    }

}


struct Stores : Mappable {
    var user_Id : String?
    var name : String?
    var mobile_No : String?
    var email_Id : String?
    var store_Address : String?
    var store_City : String?
    var store_Postal_Code : String?
    var store_PST : String?
    var store_GST : String?
    var _Store_Category_Ids : String?
    var store_Latitude : String?
    var store_Longitude : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user_Id <- map["User_Id"]
        name <- map["Name"]
        mobile_No <- map["Mobile_No"]
        email_Id <- map["Email_Id"]
        store_Address <- map["Store_Address"]
        store_City <- map["Store_City"]
        store_Postal_Code <- map["Store_Postal_Code"]
        store_PST <- map["Store_PST"]
        store_GST <- map["Store_GST"]
        _Store_Category_Ids <- map["_Store_Category_Ids"]
        store_Latitude <- map["Store_Latitude"]
        store_Longitude <- map["Store_Longitude"]
    }

}


struct Subscribe_Weeks : Mappable {
    var subscribe_Week : String?
    var subscribe_Week_Display : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        subscribe_Week <- map["Subscribe_Week"]
        subscribe_Week_Display <- map["Subscribe_Week_Display"]
    }

}
