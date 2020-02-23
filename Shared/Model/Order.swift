//
//  Order.swift
//  Artable
//
//  Created by Martin Parker on 10/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Order {
    var id : String
    var customerId : String
    var amount : Double
    var customerName : String
    var phoneNumber : String
    var lineOne : String
    var lineTwo : String
    var paymentMethod : String
    var item = [String]()
    var timeStamp : Timestamp
    var isCompleted : Bool
    var riderId : String
    
    
    
    init(
        id : String,
        customerId : String,
        amount :Double,
        customerName : String,
        phoneNumber : String,
        lineOne : String,
        lineTwo : String,
        paymentMethod : String,
        item : [String] = [],
        timeStamp : Timestamp = Timestamp(),
        isCompleted : Bool = false,
        riderId : String = "") {
        
        self.id = id
        self.customerId = customerId
        self.amount = amount
        self.customerName = customerName
        self.phoneNumber = phoneNumber
        self.lineOne = lineOne
        self.lineTwo = lineTwo
        self.paymentMethod = paymentMethod
        self.item = item
        self.timeStamp = timeStamp
        self.isCompleted = isCompleted
        self.riderId = riderId
    }
    
    init(data: [String : Any]) {
        self.id = data ["id"] as? String ?? ""
        self.customerId = data ["customerId"] as? String ?? ""
        self.amount = data ["amount"] as? Double ?? 0.0
        self.customerName = data ["customerName"] as? String ?? ""
        self.phoneNumber = data ["phoneNumber"] as? String ?? ""
        self.lineOne = data ["lineOne"] as? String ?? ""
        self.lineTwo = data ["lineTwo"] as? String ?? ""
        self.paymentMethod = data ["paymentMethod"] as? String ?? ""
        self.item = data ["item"] as? [String] ?? []
        self.timeStamp = data ["timeStamp"] as? Timestamp ?? Timestamp()
        self.isCompleted = data ["isCompleted"] as? Bool ?? false
        self.riderId = data ["riderId"] as? String ?? ""
        
    }
    
    static func modelToData(order: Order) -> [String: Any]{
        let data : [String: Any] = [
            "id" : order.id,
            "customerId" : order.customerId,
            "amount" : order.amount,
            "customerName" : order.customerName,
            "phoneNumber" : order.phoneNumber,
            "lineOne" : order.lineOne,
            "lineTwo" : order.lineTwo,
            "paymentMethod" : order.paymentMethod,
            "item" : order.item,
            "timeStamp" : order.timeStamp,
            "isCompleted" : order.isCompleted,
            "riderId" : order.riderId
            
            
        ]
        return data
    }
    
    
}
extension Order : Equatable {
    
    static func ==(lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
        
    }
}
