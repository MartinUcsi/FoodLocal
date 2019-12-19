//
//  Category.swift
//  Artable
//
//  Created by Martin Parker on 13/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    
    var name: String
    var id: String
    var imgUrl: String
    var isActive : Bool = true
    var timeStamp: Timestamp
    
    
    init(data : [String : Any]) {
        self.name  = data["name"] as? String ?? "no name"
        self.id  = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        
    }
}
