/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper


struct ScheduleDatesModel : Mappable {
    
    var status : String?
    var message : String?
    var start_Date : String?
    var end_Date : String?
    var active_Dates : [String]?
    var deActive_Dates : [String]?
    var dates : [String]?
    var active_Dates_Slots : [Active_Dates_Slots]?
    var deActive_Dates_Slots : [DeActive_Dates_Slots]?
    var dates_Slots : [Dates_Slots]?
    var pickup_Slots : [Time_Slots]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["Status"]
        message <- map["Message"]
        start_Date <- map["Start_Date"]
        end_Date <- map["End_Date"]
        active_Dates <- map["Active_Dates"]
        deActive_Dates <- map["DeActive_Dates"]
        dates <- map["Dates"]
        active_Dates_Slots <- map["Active_Dates_Slots"]
        deActive_Dates_Slots <- map["DeActive_Dates_Slots"]
        dates_Slots <- map["Dates_Slots"]
        pickup_Slots <- map["Pickup_Slots"]
    }

}


struct Time_Slots : Mappable {
    var time_Slot : String?
    var time_Slot_Display : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        time_Slot <- map["Time_Slot"]
        time_Slot_Display <- map["Time_Slot_Display"]
    }

}


struct DeActive_Dates_Slots : Mappable {
    var date : String?
    var time_Slots : [Time_Slots]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        date <- map["Date"]
        time_Slots <- map["Time_Slots"]
    }

}


struct Dates_Slots : Mappable {
    var date : String?
    var time_Slots : [Time_Slots]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        date <- map["Date"]
        time_Slots <- map["Time_Slots"]
    }

}


struct Active_Dates_Slots : Mappable {
    var date : String?
    var time_Slots : [Time_Slots]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        date <- map["Date"]
        time_Slots <- map["Time_Slots"]
    }

}

