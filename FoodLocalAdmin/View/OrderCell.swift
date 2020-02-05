//
//  OrderCell.swift
//  FoodLocalAdmin
//
//  Created by Martin Parker on 04/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

protocol OrderCellDelegate : class {
   

}

class OrderCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var amount: UILabel!
//    @IBOutlet weak var customerAdd1: UILabel!
//    @IBOutlet weak var customerAdd2: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    
//    @IBOutlet weak var customerName: UILabel!
//    @IBOutlet weak var customerPhone: UILabel!
//    @IBOutlet weak var customerAdd1: UILabel!
//    @IBOutlet weak var customerAdd2: UILabel!
//    @IBOutlet weak var amount: UILabel!
//    @IBOutlet weak var detail: UILabel!
    
    //Variable
    weak var delegate : OrderCellDelegate?
    private var order: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //Action
    @IBAction func completeClicked(_ sender: UIButton) {
     
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Order, delegate: OrderCellDelegate){
        
        var itemArray = ""
        self.order = order

        for i in order.item{
            itemArray.append("\(i) \n")
           
        }
        
        customerName.text = order.customerName
        customerPhone.text = order.phoneNumber
//        customerAdd1.text = order.lineOne
//        customerAdd2.text = order.lineTwo
        orderNumber.text = "Order ID: \(order.id)"
       // detail.text = itemArray
        paymentMethodLbl.text = order.paymentMethod
       

        
        
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
        if let price = formatter.string(from: order.amount as NSNumber){
             amount.text = price
         }
   
    }
}
