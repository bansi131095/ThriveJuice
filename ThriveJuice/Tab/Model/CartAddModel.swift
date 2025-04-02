/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct CartAddModel : Mappable {
	var status : String?
	var message : String?
	var cart_Data : [Cart_Data]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		status <- map["Status"]
		message <- map["Message"]
		cart_Data <- map["Cart_Data"]
	}

}


struct Cart_Data : Mappable {
    var product_Id : String?
    var cart_Product_Size : String?
    var cart_Days : String?
    var cart_Addons : String?
    var cart_Qty : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        product_Id <- map["Product_Id"]
        cart_Product_Size <- map["Cart_Product_Size"]
        cart_Days <- map["Cart_Days"]
        cart_Addons <- map["Cart_Addons"]
        cart_Qty <- map["Cart_Qty"]
    }

}
