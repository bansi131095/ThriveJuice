/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct ProductModel : Mappable {
	var products : [Products]?
	var limit : Int?


	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		products <- map["Products"]
		limit <- map["Limit"]
	}

}


struct Products : Mappable {
    var product_Id : String?
    var product_Name : String?
    var product_Image : [String]?
    var product_Size : [ProductSize]?
    var category_Name : String?
    var category_Id : String?
    var is_Special : String?
    var is_Wishlist : Bool?
    var product_Addons : [Product_Addons]?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Id <- map["Product_Id"]
        product_Name <- map["Product_Name"]
        product_Image <- map["Product_Image"]
        product_Size <- map["Product_Size"]
        category_Name <- map["Category_Name"]
        category_Id <- map["Category_Id"]
        is_Special <- map["Is_Special"]
        is_Wishlist <- map["Is_Wishlist"]
        product_Addons <- map["Product_Addons"]
    }

}


struct ProductSize : Mappable {
    var product_Days : String?
    var product_Size : String?
    var product_Price : String?
    var available_Stock : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Days <- map["Product_Days"]
        product_Size <- map["Product_Size"]
        product_Price <- map["Product_Price"]
        available_Stock <- map["Available_Stock"]
    }

}
