//
//  OrderModel.swift
//  ThriveJuice
//
//  Created by MacBook on 11/09/23.
//

import Foundation
import ObjectMapper


struct OrderModel: Mappable {
    
    var status : String?
    var message : String?
    var orderId : String?
    var earnRewardPoints: String?
    var payment_Status : String?
    var grand_Total : String?
    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["Status"]
        message <- map["Message"]
        orderId <- map["Order_Id"]
        earnRewardPoints <- map["Earn_Reward_Points"]
        payment_Status <- map["Payment_Status"]
        grand_Total <- map["Grand_Total"]
        
    }
    
}
