/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct DashboardModel : Mappable {
	
    var banners : [Banners]?
    var categories : [Categories]?
    var trendingProducts : [ProductsList]?
    var recommendProducts : [ProductsList]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        banners <- map["Banners"]
        categories <- map["Categories"]
        trendingProducts <- map["TrendingProducts"]
        recommendProducts <- map["RecommendProducts"]
    }

}


struct Banners : Mappable {
    var banner_Id : String?
    var banner_Image : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        banner_Id <- map["Banner_Id"]
        banner_Image <- map["Banner_Image"]
    }

}


struct Categories : Mappable {
    var category_Id : String?
    var category_Name : String?
    var category_Image : String?
    var is_Special : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        category_Id <- map["Category_Id"]
        category_Name <- map["Category_Name"]
        category_Image <- map["Category_Image"]
        is_Special <- map["Is_Special"]
    }

}


struct ProductsList : Mappable {
    var product_Id : String?
    var product_Name : String?
    var product_Image : [String]?
    var product_Description : String?
    var product_Size : [Product_Size]?
    var category_Name : String?
    var category_Id : String?
    var is_Special : String?
    var benefits : String?
    var ingredients : String?
    var is_Wishlist : Bool?
    var product_Addons : [Product_Addons]?

    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Id <- map["Product_Id"]
        product_Name <- map["Product_Name"]
        product_Image <- map["Product_Image"]
        product_Description <- map["Product_Description"]
        product_Size <- map["Product_Size"]
        category_Name <- map["Category_Name"]
        category_Id <- map["Category_Id"]
        is_Special <- map["Is_Special"]
        benefits <- map["Benefits"]
        ingredients <- map["Ingredients"]
        is_Wishlist <- map["Is_Wishlist"]
        product_Addons <- map["Product_Addons"]

    }

}


struct Product_Size : Mappable {
    var product_Size : String?
    var product_Price : String?
    var available_Stock : Int?
    var is_Selected : Bool?
    var product_Days : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Size <- map["Product_Size"]
        product_Price <- map["Product_Price"]
        available_Stock <- map["Available_Stock"]
        is_Selected <- map["Is_Selected"]
        product_Days <- map["Product_Days"]
    }

}


struct Product_Addons : Mappable {
    var addon_Title : String?
    var addons : [Addons]?
    var Selection_Type : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        addon_Title <- map["Addon_Title"]
        addons <- map["Addons"]
        Selection_Type <- map["Selection_Type"]
    }

}


struct Addons : Mappable {
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
