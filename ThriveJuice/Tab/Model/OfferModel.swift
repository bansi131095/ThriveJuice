/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct OfferModel : Mappable {
	var offers : [Offers]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		offers <- map["Offers"]
	}

}


struct Offers : Mappable {
    var offer_Id : String?
    var _Product_Id : String?
    var _Category_Id : String?
    var offer_Image : String?
    var category_Name : String?
    var product_Name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        offer_Id <- map["Offer_Id"]
        _Product_Id <- map["_Product_Id"]
        _Category_Id <- map["_Category_Id"]
        offer_Image <- map["Offer_Image"]
        category_Name <- map["Category_Name"]
        product_Name <- map["Product_Name"]
    }

}
