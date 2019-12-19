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
    
    
}
