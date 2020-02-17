//
//  Rider.swift
//  FoodLocalRider
//
//  Created by Martin Parker on 17/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation

struct Rider {
    var id : String
    var email: String
    var username: String
    var riderIncome : Double
    
    init(id: String = "",
         email: String = "",
         username: String = "",
         riderIncome: Double = 0.0) {
                
        self.id = id
        self.email = email
        self.username = username
        self.riderIncome = riderIncome
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? " "
        username = data["username"] as? String ?? ""
        riderIncome = data["riderIncome"] as? Double ?? 0.0
    }
    
    static func modelToData(rider: Rider) -> [String: Any]{
        
        let data : [String: Any] = [
            "id" : rider.id,
            "email": rider.email,
            "username" : rider.username,
            "riderIncome" : rider.riderIncome
        ]
        return data
    }
}
