//
//  orderDetailVC.swift
//  FoodLocal
//
//  Created by Martin Parker on 26/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class orderDetailVC: UIViewController {

    //Outlets
    @IBOutlet weak var orderidTxt: UILabel!
    @IBOutlet weak var userAddressTxt: UITextView!
    @IBOutlet weak var orderItemTxt: UITextView!
    @IBOutlet weak var priceTxt: UILabel!
    
    
    
    //Variable
    var order : Order!
    var addressArray = ""
    var itemArray = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        
        
        //Show order time
            let OrderTime = order.timeStamp
          
           let aDate = OrderTime.dateValue()
           let formatter2 = DateFormatter()
           formatter2.locale = Locale(identifier: "en_US_POSIX")
          // formatter2.dateFormat = "HH:mm '-' dd/MM/yyyy"
           formatter2.dateFormat = "d MMM yyyy 'at' h:mm a"
           let formattedTimeZoneStr = formatter2.string(from: aDate)
           //print(formattedTimeZoneStr)
        
           
                  
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
      
       self.title = formattedTimeZoneStr
       
    }
    override func viewWillAppear(_ animated: Bool) {
       // orderidTxt.text = order.id\v
        //print(order.item)
        orderidTxt.text = order.id
        
        addressArray.append("\(order.lineOne) \n")
        addressArray.append("\(order.lineTwo)")
        
        //Append the item into itemArray
        for i in order.item{
                   itemArray.append("\(i) \n")
                  
               }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Show address
        userAddressTxt.text = addressArray
        
        //show item order
        orderItemTxt.text = itemArray
        
        //Show total amount
        let formatter = NumberFormatter()
              formatter.numberStyle = .currency
              if let price = formatter.string(from: order.amount as NSNumber){
                  priceTxt.text = price
              }
    }

}
