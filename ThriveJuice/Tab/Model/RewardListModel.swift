/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct RewardListModel : Mappable {
	var reward_Points : [Reward_Points]?
    var earned_Reward : String?
    var earned_Reward_Amount : String?
    var available_Reward : String?
    var available_Reward_Amount : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		reward_Points <- map["Reward_Points"]
        earned_Reward <- map["Earned_Reward"]
        earned_Reward_Amount <- map["Earned_Reward_Amount"]
        available_Reward <- map["Available_Reward"]
        available_Reward_Amount <- map["Available_Reward_Amount"]
	}

}


struct Reward_Points : Mappable {
    var reward_Points_Id : String?
    var _Order_Id : String?
    var reward_Points_Comment : String?
    var reward_Points : String?
    var reward_Points_Added_At : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        reward_Points_Id <- map["Reward_Points_Id"]
        _Order_Id <- map["_Order_Id"]
        reward_Points_Comment <- map["Reward_Points_Comment"]
        reward_Points <- map["Reward_Points"]
        reward_Points_Added_At <- map["Reward_Points_Added_At"]
    }

}
