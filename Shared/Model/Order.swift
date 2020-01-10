//
//  Order.swift
//  Artable
//
//  Created by Martin Parker on 10/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation

struct Order {
    var id : String
    var amount : Double
    var item = [String]()
    
    
    init(
        id : String,
        amount :Double,
        item : [String] = []) {
        
        self.id = id
        self.amount = amount
        self.item = item
    }
    
    init(data: [String : Any]) {
        self.id = data ["id"] as? String ?? ""
        self.amount = data ["amount"] as? Double ?? 0.0
        self.item = data ["item"] as? [String] ?? []
        
    }
    
    static func modelToData(order: Order) -> [String: Any]{
        let data : [String: Any] = [
            "id" : order.id,
            "amount" : order.amount,
            "item" : order.item[]
        ]
        return data
    }
    
    
}
