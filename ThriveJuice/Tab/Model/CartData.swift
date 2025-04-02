//
//  CartData.swift
//  ThriveJuice
//
//  Created by MacBook on 22/08/23.
//

import Foundation


struct CartData: Codable {
    
    var Product_Id: String
    var Cart_Qty: String
    var Cart_Product_Size: String
    var Cart_Days: String  = ""
    var Cart_Addons: String = ""
    
    init(productId: String, cartQty: String, cartProductSize: String, cartDays: String = "", cartAddon: String = ""){
        self.Product_Id = productId
        self.Cart_Qty = cartQty
        self.Cart_Product_Size = cartProductSize
        self.Cart_Days = cartDays
        self.Cart_Addons = cartAddon
    }
    
}


struct OrderData: Codable {
    
    var DeliveryDate: String
    var SubscribeWeek: String
    var OrderType: String
    var DeliveryTime: String
    var OrderNotes: String

    init(deliveryDate: String, subscribeWeek: String, orderType: String, deliveryTime: String, orderNotes: String){
        self.DeliveryDate = deliveryDate
        self.SubscribeWeek = subscribeWeek
        self.OrderType = orderType
        self.DeliveryTime = deliveryTime
        self.OrderNotes = orderNotes
    }
    
}

