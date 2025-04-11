/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct OrderListModel : Mappable {
	var orders : [Orders]?
	var limit : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		orders <- map["Orders"]
		limit <- map["Limit"]
	}

}


struct Orders : Mappable {
    var order_Id : String?
    var delivery_Date : String?
    var delivery_Time : String?
    var order_Status : String?
    var cart_Data : [Cart_Datas]?
    var grand_Total : String?
    var order_Added_At : String?
    var subscribe_Week : String?
    var subscribe_Week_Cancel : String?
    var product_Total : String?
    var shipping_Charge : String?
    var tax_Charge : String?
    var tax_PST_Charge : String?
    var tax_GST_Charge : String?
    var discount_Amount : String?
    var reward_Points_Amount : String?
    var subscribe_Discount_Amount : String?
    var _Address_Id : String?
    var _Store_Id : String?
    var address : Addresses?
    var store : Stores?
    var bottle_Environment_Fees : String?
    var bottle_Return_Amount : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        order_Id <- map["Order_Id"]
        delivery_Date <- map["Delivery_Date"]
        delivery_Time <- map["Delivery_Time"]
        order_Status <- map["Order_Status"]
        cart_Data <- map["Cart_Data"]
        grand_Total <- map["Grand_Total"]
        order_Added_At <- map["Order_Added_At"]
        subscribe_Week <- map["Subscribe_Week"]
        subscribe_Week_Cancel <- map["Subscribe_Week_Cancel"]
        product_Total <- map["Product_Total"]
        shipping_Charge <- map["Shipping_Charge"]
        tax_Charge <- map["Tax_Charge"]
        tax_PST_Charge <- map["Tax_PST_Charge"]
        tax_GST_Charge <- map["Tax_GST_Charge"]
        discount_Amount <- map["Discount_Amount"]
        reward_Points_Amount <- map["Reward_Points_Amount"]
        subscribe_Discount_Amount <- map["Subscribe_Discount_Amount"]
        _Address_Id <- map["_Address_Id"]
        _Store_Id <- map["_Store_Id"]
        address <- map["Address"]
        store <- map["Store"]
        bottle_Environment_Fees <- map["Bottle_Environment_Fees"]
        bottle_Return_Amount <- map["Bottle_Return_Amount"]
    }
    

}


struct Cart_Datas : Mappable {
    var product_Id : String?
    var cart_Product_Size : String?
    var cart_Days : String?
    var cart_Addons : String?
    var cart_Qty : String?
    var product_Price : String?
    var product_Addon_Price : String?
    var cart_Addons_Price : [Cart_Addons_Price]?
    var cart_Product_Price : String?
    var product_Name : String?

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
        product_Name <- map["Product_Name"]
    }

}


struct Cart_Addons_Price : Mappable {
    var addon_Id : String?
    var addon_Name : String?
    var addon_Price : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        addon_Id <- map["Addon_Id"]
        addon_Name <- map["Addon_Name"]
        addon_Price <- map["Addon_Price"]
    }

}
