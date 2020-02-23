//
//  UserOrderCell.swift
//  FoodLocal
//
//  Created by Martin Parker on 22/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class UserOrderCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var orderidTxt: UILabel!
    @IBOutlet weak var orderTimeTxt: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var estimateTimeTxt: UILabel!
    
    
    //Variable
    private var order: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configureCell(order: Order){
        
         orderidTxt.text = "OrderID#\(order.id)"
        
            //Show order time
            let OrderTime = order.timeStamp
          
           let aDate = OrderTime.dateValue()
           let formatter2 = DateFormatter()
           formatter2.locale = Locale(identifier: "en_US_POSIX")
          // formatter2.dateFormat = "HH:mm '-' dd/MM/yyyy"
           formatter2.dateFormat = "d MMM yyyy 'at' h:mm a"
           let formattedTimeZoneStr = formatter2.string(from: aDate)
           //print(formattedTimeZoneStr)
        
           orderTimeTxt.text = formattedTimeZoneStr
                      
        
    }
    
    
    @IBAction func contactClicked(_ sender: UIButton) {
        
    }
    @IBAction func callRiderClicked(_ sender: UIButton) {
        
    }
    
}
