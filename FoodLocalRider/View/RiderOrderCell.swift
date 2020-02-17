//
//  SellerOrderCell.swift
//  FoodLocalRider
//
//  Created by Martin Parker on 14/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase


//protocol RiderOrderCellDelegate : class {
//    func orderCompleted(order: Order)
//}
class RiderOrderCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var completeBtn: RoundedButton!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var amount: UILabel!

    
    
    //Variable
  //  weak var delegate : RiderOrderCellDelegate?
    private var order: Order!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    @IBAction func completeClicked(_ sender: UIButton) {
//        delegate?.orderCompleted(order: order)
//    }
    
       func configureCell(order: Order ){
            
            var itemArray = ""
            self.order = order
           // self.delegate = delegate

            for i in order.item{
                itemArray.append("\(i) \n")
               
            }
            
            customerName.text = "Name: \(order.customerName)"
            customerPhone.text = "Contact: \(order.phoneNumber)"
    //        customerAdd1.text = order.lineOne
    //        customerAdd2.text = order.lineTwo
            orderNumber.text = "Order ID# \(order.id)"
           // detail.text = itemArray
            paymentMethodLbl.text = "Payment Method: \(order.paymentMethod)"
        
        
            //dateTxt.text = "\(order.timeStamp)"
        
                
        let OrderTime = order.timeStamp
          
           let aDate = OrderTime.dateValue()
           let formatter2 = DateFormatter()
           formatter2.locale = Locale(identifier: "en_US_POSIX")
          // formatter2.dateFormat = "HH:mm '-' dd/MM/yyyy"
           formatter2.dateFormat = "d MMM yyyy 'at' h:mm a"
           let formattedTimeZoneStr = formatter2.string(from: aDate)
           //print(formattedTimeZoneStr)
        
           dateTxt.text = formattedTimeZoneStr
                      
        


        
        
             let formatter = NumberFormatter()
             formatter.numberStyle = .currency
            if let price = formatter.string(from: order.amount as NSNumber){
                 //This is the real customer paying price -->>
                // amount.text = price
                
                amount.text = "Job Price: RM 7.50"
             }
       
        }
    
}
