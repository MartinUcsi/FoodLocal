//
//  Product.swift
//  Artable
//
//  Created by Martin Parker on 16/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name : String
    var id : String
    var category : String
    var price : Double
    var productDescription : String
    var imageUrl : String
    var timeStampt : Timestamp
    var stock : Int
   // var favorite : Bool
    
    init(data: [String : Any]) {
        self.name = data ["name"] as? String ?? "no name"
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imgUrl"] as? String ?? ""
        self.timeStampt = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0 
    }
    
}
